---
name: workflow-governance
description: >
  Workflow de desenvolvimento e governanca stack-agnostico — golden rules
  (task-first QUANDO houver tracker, doc viva, commits atomicos), mapeamento de
  status, Conventional Commits, protocolo de PR e skill defaults. Carrega ao
  iniciar/fechar trabalho, abrir PR, escrever mensagem de commit, ou quando o
  user menciona "workflow", "governance", "governanca", "task", "status",
  "branch", "commit convention", "PR". Orquestracao detalhada vive em `task-start`
  (inicio) e `task-flow` (fechamento).
license: MIT
allowed-tools: Bash
---

# Workflow de Desenvolvimento & Governanca

Documento canonico de governanca do projeto. Define as regras; a coreografia de
execucao vive nas skills `task-start` (inicio) e `task-flow` (fechamento).

> ⚠️ **TRACKER E OPCIONAL — leia antes de aplicar.**
> Nem todo projeto usa um gerenciador de tasks (ClickUp, Jira, Linear, GitHub
> Issues). Onde este documento fala em "task", "status" ou "comentario na task",
> trate como **condicional**: aplica-se **somente se o projeto tiver tracker**.
> Sem tracker, a unidade de trabalho e o **branch + PR** — pule os passos de
> tracker sem ceremonia e nao invente um. **IA/agente:** se nao houver tracker
> configurado (sem MCP de issues, sem mencao no `CLAUDE.md`/`context/`), **nao
> pergunte por task ID nem bloqueie o trabalho** — siga direto pro branch.

---

## 1. Regras de Ouro (Governanca)

1. **Task First (se houver tracker)**: quando o projeto usa tracker, a task e
   criada ANTES de tocar codigo. Sem tracker, o branch nomeado e o registro.
2. **Documentacao Viva**: doc sincronizada com o codigo, no **mesmo PR** — nao depois.
3. **Code Review**: todo codigo passa por review antes de merge.
4. **Testes**: features novas incluem testes quando aplicavel (ver `testing-discipline`).
5. **Commits Atomicos**: cada commit representa uma unica mudanca logica.
6. **Escopo Estrito**: edite apenas o que a task pede; nao formate codebase inteiro.

---

## 2. Mapeamento de Status (opcional — so com tracker)

> Adapte a tabela a ferramenta do projeto (Jira, Linear, ClickUp, GitHub Projects).
> Os slugs abaixo sao genericos — substitua pelos do seu tracker. **Pule esta
> secao inteira se o projeto nao tem tracker.**

| Acao | Status |
|------|--------|
| Ideia / Backlog | `backlog` |
| Pronto para Iniciar | `todo` |
| Em Desenvolvimento | `in_progress` |
| Em Review | `in_review` |
| Finalizado | `done` |

---

## 3. Convencoes de Commit (Conventional Commits)

```
type(scope): descricao curta

[corpo opcional]
[footer opcional]
```

| Tipo | Uso |
|------|-----|
| `feat` | Nova funcionalidade |
| `fix` | Correcao de bug |
| `docs` | Documentacao |
| `style` | Formatacao (sem mudanca de codigo) |
| `refactor` | Refatoracao |
| `test` | Adicao/correcao de testes |
| `chore` | Tarefas de manutencao |

Exemplos:
```
feat(auth): implementa login com provider externo
fix(cart): corrige calculo de desconto
docs(readme): adiciona instrucoes de setup
refactor(api): extrai logica de validacao
```

> A skill `git-commit` automatiza analise de diff + geracao da mensagem.

---

## 4. Protocolo de Pull Request

- **Branch**: `feature/[TASK-ID]-nome-kebab` ou `fix/[TASK-ID]-nome-kebab`.
  Sem tracker, use um slug descritivo: `feature/login-com-provider`.
- **Antes de abrir o PR**: rode os checks da skill `pre-pr-checks` (lint /
  type-check / test / build). Reviewer humano nao descobre PR quebrado.
- **PR body**: use [`.github/PULL_REQUEST_TEMPLATE.md`](../../../.github/PULL_REQUEST_TEMPLATE.md) — Summary, Changes, Why, Test plan, Risk, Checklist.

```bash
git push -u origin feature/[TASK-ID]-nome
gh pr create --base main --title "[TASK-ID] Nome da mudanca"
```

---

## 5. Ferramentas Recomendadas

| Categoria | Opcoes |
|-----------|--------|
| Gestao de Tasks (opcional) | Jira, Linear, ClickUp, GitHub Projects |
| CI/CD | GitHub Actions, GitLab CI, CircleCI |
| Code Review | GitHub PRs, GitLab MRs |
| Documentacao | Markdown no repo, Notion, Confluence |

---

## 6. Skill Defaults (gatilhos operacionais)

| Gatilho | Skill | Por que |
|---|---|---|
| Inicio de task de codigo (feature/fix/refactor) | `task-start` | Ritual de inicio: tracker (se houver) → branch → analise |
| Inicio de task comportamental | `tdd` | Garante Red → Green → Refactor |
| Tocar arquivos de teste | `testing-discipline` | Anti-skip + 8 classes de vulnerabilidade |
| Antes de `gh pr create` | `pre-pr-checks` | Lint/type-check/test/build verdes antes do PR |
| Fechamento de task (PR pronto) | `task-flow` | Ritual de fechamento: commit → docs → checks → tracker |
| Sincronizar docs apos mudanca | `update-docs` | Doc viva no mesmo PR |
| Decisao arquitetural relevante | `adr-skill` | ADR no formato MADR 4.0 |
| Commit | `git-commit` | Conventional Commits |
| Segunda opiniao antes de merge critico | `codex-review` | Reduz blind spot do agente em DB/security/refactor grande |

> CSS puro, copy/typo, chore mecanico, comentario: **exceto TDD** — as outras skills continuam valendo onde aplicavel.

---

## Referencias

- `architecture-rules` — padroes de codigo (SoC, SRP, error handling, tamanho)
- `testing-discipline` — anti-skip + 8 vulnerabilidades obrigatorias
- `pre-pr-checks` — protocolo de checks pre-PR
- [`context/guides/ci-and-gates.md`](../../../context/guides/ci-and-gates.md) — estrategia de gates em camadas
- [`context/adr/README.md`](../../../context/adr/README.md) — decisoes arquiteturais
