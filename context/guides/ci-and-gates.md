# CI & Gates — Estratégia de Validação em Camadas

> **Este arquivo é parte do template.** Descreve o **conceito** de gates em camadas, não a implementação concreta. Ao adotar o template, preencha os placeholders `<comando-*>` e ajuste a tabela de branches conforme seu workflow real.

Este guia explica **onde** o código é validado antes de chegar em produção, **o que** roda em cada camada e **por que** essa arquitetura é eficaz. A decisão final de como adaptar fica registrada num ADR do seu projeto (ex.: `context/adr/YYYY-MM-DD-gate-strategy.md`).

---

## TL;DR

Três camadas independentes, do mais rápido pro mais autoritativo:

| Camada | Onde | Quando dispara | O que faz |
|---|---|---|---|
| **1. Pre-push local** | `.githooks/pre-push` | Antes de `git push` | Lint + type-check + testes rápidos. Bloqueia o push se falhar. |
| **2. CI remoto** | `.github/workflows/ci.yml` (ou equivalente) | Push para branch protegida + Pull Request | Pipeline completo: lint + type-check + testes + build + e2e + a11y + secret scan. |
| **3. Branch protection** | Settings do hosting (GitHub/GitLab/etc.) | Botão "Merge" | Bloqueia merge se status checks da camada 2 não passaram. |

Cada camada **complementa** a anterior: o pre-push é rápido (segundos), o CI é autoritativo (minutos), e branch protection é o guard final declarativo.

---

## Por que três camadas?

- **Só pre-push** não é confiável: pode ser bypassado (`SKIP_GATE=1 git push`, push direto pelo servidor, agente que ignora o hook).
- **Só CI** é caro (consome minutos do plano) e tarde demais — dev espera 15min pra descobrir que esqueceu um `lint`.
- **Só branch protection** não roda nada — só impede o merge se houver status check falhando.

A combinação dá: **feedback rápido local** + **verdade remota** + **enforcement declarativo**.

---

## Camada 1 — Pre-push local

**Quando dispara:** todo `git push` (qualquer branch).

**O que tipicamente roda:**

1. **Detecção de área alterada** — analisa `git diff` entre o ref local e o remoto para rodar apenas o que mudou (evita re-rodar tudo a cada push). Exemplos de áreas: workspace específico num monorepo, módulo afetado, package alterado.
2. **Pipeline mínimo por área:**
   - `<comando-lint>` — linter (Biome / ESLint / Ruff / golangci-lint / etc.)
   - `<comando-type-check>` — verificação de tipos (se a stack tem)
   - `<comando-test-unit>` — testes rápidos (unit + integração leve)

**O que normalmente NÃO roda no pre-push** (decisão consciente para manter rápido):

- **E2E pesado** (Playwright, Cypress, Selenium em browser real)
- **A11y/Visual regression**
- **Builds completos** (mover pra CI ou rodar manualmente antes de PR pra branch crítica)
- **Lint em arquivos não alterados** (em monorepos grandes evita OOM)

**Tempo-alvo:** 30s a 2min. Se passar de 2min, devs vão burlar.

**Setup one-time por clone** (essencial — sem isso o hook não roda):

```bash
git config core.hooksPath .githooks
```

Sem esse comando, git usa `.git/hooks/` (vazio por default). Verificar:

```bash
git config --get core.hooksPath  # deve retornar: .githooks
```

**Bypass consciente:**

```bash
SKIP_GATE=1 git push   # pula o gate inteiro
```

Use **apenas** quando souber exatamente o que está fazendo (ex.: push de docs em branch isolada). Bypass casual em código vai eventualmente cair na branch protegida com erro.

---

## Camada 2 — CI remoto

**Quando dispara** (escolha a estratégia que casa com custo/branches):

- **Estratégia "tudo em todo PR"** — simples, cara em minutos. Boa pra times pequenos / projetos novos.
- **Estratégia "scoped por branch"** — CI completo só em PRs pra branches protegidas (ex.: `main`, `homolog`); branches de integração (`develop`) confiam só no pre-push. Reduz custo de Actions/Pipelines significativamente.
- **Estratégia "matriz por área"** — usa filtros de path (`paths:` no GitHub Actions, `rules:changes:` no GitLab) pra rodar só jobs afetados.

**Jobs típicos** (cada projeto adapta):

| Job | Tempo aproximado | Quando rodar |
|---|---|---|
| `<comando-lint>` | <2min | Sempre |
| `<comando-type-check>` | <2min | Sempre |
| `<comando-test-unit>` | <5min | Sempre |
| `secrets-scan` (TruffleHog, gitleaks, etc.) | <2min | Sempre — proteção mínima |
| `<comando-test-e2e>` | 10–30min | Em PR pra branch protegida |
| `<comando-test-a11y>` (axe-core, etc.) | 5–15min | Em PR pra branch protegida |
| `<comando-test-visual>` (visual regression) | 5–15min | Em PR pra branch protegida |
| `<comando-build>` | 2–10min | Sempre (valida que build sai) |
| `all-checks-passed` (orquestrador "needs:") | <1min | Sempre — único required status |

**Padrão recomendado:** ter um job `all-checks-passed` que depende de todos os outros via `needs:`. Branch protection requer só ESSE job — assim você pode adicionar/remover jobs sem mexer nas settings remotas.

> **Exemplo de configuração:** ver [`.github/workflows/ci.example.yml`](../../.github/workflows/ci.example.yml) na raiz do template — pipeline mínimo com placeholders para sua stack.

---

## Camada 3 — Branch protection rules

**Status no template:** declarativo. Cada projeto configura no settings do hosting (GitHub, GitLab, Bitbucket).

**Configuração típica para branch protegida** (ex.: `main`):

- ✅ Require pull request reviews (1+ reviewer)
- ✅ Require status checks to pass: `all-checks-passed` (da camada 2)
- ✅ Require branches up to date before merging
- ✅ Require linear history (alinha com commits atômicos)
- ✅ Restrict force-push
- ✅ Restrict deletions
- ⚠️ Include administrators (opcional — fechar bypass administrativo)

**Branch de integração rápida** (ex.: `develop`):

- ✅ Restrict force-push
- ✅ Restrict deletions
- ⚠️ Status checks **opcionais** (se você optou pela estratégia "scoped por branch" — develop confia no pre-push)
- ⚠️ Reviews opcionais (depende do tamanho do time)

> Em hosts privados sem feature de branch protection (ex.: GitHub Free em repo privado), **o pre-push local vira o único gate** — disciplina vira essencial. Considere upgrade de plano se o time crescer.

---

## Trade-offs a considerar

### Decisão: CI scoped por branch (só em main)

**Ganho:** consumo de Actions previsível e baixo (5–10× menos PRs disparando CI completo).

**Custo:** branch de integração pode acumular regressões que só caem no PR `develop → main`. Custo de desfazer um bug que passou pra main é maior (revert + nova merge train).

**Mitigação:** pre-push local rigoroso + smoke test rodável manualmente antes de PR pra main.

### Decisão: pre-push sem E2E

**Ganho:** push rápido (30s–2min), devs não burlam por irritação.

**Custo:** regressões de UI/integração só caem no CI da branch protegida.

**Mitigação:** comando `<comando-test-smoke>` rodável manualmente antes de PR (3–5 testes cobrindo fluxos críticos com mocks).

### Decisão: bypass com flag de ambiente

**Ganho:** dev tem escape hatch consciente (ex.: emergência, docs-only).

**Custo:** se virar default, gate vira teatro.

**Mitigação:** logar no PR body quando bypass foi usado. Auditar periodicamente.

---

## Quando atualizar este guia

- Mudou `.githooks/pre-push` (áreas, comandos, ordem)
- Mudou `.github/workflows/ci.yml` (triggers, jobs, matrix)
- Mudou política de branch protection
- Mudou plano do hosting (Free → Team → Enterprise)
- Mudou pipeline de release (nova branch staging/homolog ativa)

Toda mudança na arquitetura de gates exige update aqui no mesmo PR. Considere registrar a decisão como ADR (`context/adr/YYYY-MM-DD-gate-strategy.md`) se for mudança estrutural.

---

## Referências

- [`.githooks/pre-push.example`](../../.githooks/pre-push.example) — modelo de pre-push hook
- [`.github/workflows/ci.example.yml`](../../.github/workflows/ci.example.yml) — modelo de pipeline CI
- [`.agents/rules/04-pre-pr-checks.md`](../../.agents/rules/04-pre-pr-checks.md) — protocolo de checks pré-PR (agente)
- [`.agents/rules/03-testing.md`](../../.agents/rules/03-testing.md) — anti-skip + 8 vulnerabilidades obrigatórias
