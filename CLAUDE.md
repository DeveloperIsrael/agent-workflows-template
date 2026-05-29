# [NOME_DO_PROJETO] — Entry Point Canonico para Agentes

> **Este e o documento canonico para todos os agentes** (Claude, Gemini, Codex, Copilot, Cursor, OpenCode).
> `GEMINI.md` e `AGENTS.md` sao stubs que apontam para aqui.
>
> Substitua `[NOME_DO_PROJETO]` e demais placeholders `[TEXTO]` ao adotar o template.

> **AVISO PARA AGENTES — ESTE É UM TEMPLATE.** Este repositorio (`agent-workflows-template`) é um template feito para ser **herdado por projetos clonados a partir dele**. Tudo dentro de `.agents/`, `.claude/`, `.cursor/`, `.gemini/`, etc. existe para que o template funcione standalone — NAO remova skills, regras, ou configuracoes daqui sob argumento de "duplicacao com setup global do usuario": a duplicacao **é intencional**. Mudancas aqui afetam todos os projetos futuros.
>
> **Se você é um agente operando num projeto que ADOTOU este template** (não no template mesmo): o usuário humano precisa completar a checklist de adaptação descrita em [`README.md` → seção "Como Adaptar Este Template"](./README.md#como-adaptar-este-template). Se ao ler `context/architecture/engineering.md` você ainda encontrar placeholders `[TECH_*]`/`[FRAMEWORK_*]` ou comandos `[COMANDO_*]` na skill `pre-pr-checks` (`.agents/skills/pre-pr-checks/SKILL.md`), **pare e peça ao usuário pra completar a adaptação** antes de prosseguir com a task — você não conseguirá rodar checks que não existem.

---

## Leitura Obrigatoria

Governanca e regras de codigo vivem como **skills** em `.agents/skills/` (expostas
via symlink em `.claude/skills/`). No Claude carregam sozinhas pelo gatilho do
frontmatter; demais providers leem este `CLAUDE.md` e abrem o `SKILL.md` citado
(ver ADR [`2026-05-27-governance-rules-as-skills.md`](./context/adr/2026-05-27-governance-rules-as-skills.md)).

Ao iniciar uma task:

1. **Inicio de task** — skill `task-start` (ritual de inicio; **tracker/task e opcional**)
2. **Workflow e governanca** — skill `workflow-governance`
3. **Regras de codigo** — skill `architecture-rules` (+ `testing-discipline` ao tocar testes, `pre-pr-checks` antes do PR)
4. **Fechamento de task** — skill `task-flow`
5. **Contexto do dominio** — [`context/README.md`](./context/README.md)
6. **ADRs ativos** — [`context/adr/README.md`](./context/adr/README.md) — consulte antes de alterar areas governadas (status `accepted`) e referencie o ADR em comentario no ponto de entrada da mudanca

---

## Multi-Stack — Discovery Obrigatorio

Este template e **stack-agnostico** (ver ADR [`context/adr/2026-05-01-template-multi-stack-strategy.md`](./context/adr/2026-05-01-template-multi-stack-strategy.md)). Os exemplos React/TS espalhados pelo template — estrutura `src/components/`, comandos `npm run *`, snippets `.tsx`, settings de Cursor/Copilot com globs `**/*.tsx` — sao **exemplos concretos**, nao prescricoes. Antes de aplicar qualquer recomendacao, identifique a stack real:

1. **Brownfield com docs preenchidas**: se [`context/architecture/engineering.md`](./context/architecture/engineering.md) ja esta preenchido (sem placeholders `[TECH_*]`/`[FRAMEWORK_*]`), use-o como SSoT da stack.
2. **Brownfield com docs vazias**: inspecione manifests reais na raiz na ordem — `package.json`, `pyproject.toml`/`requirements.txt`, `go.mod`, `Cargo.toml`, `pom.xml`/`build.gradle`, `Gemfile`, `composer.json`, `mix.exs`. O primeiro encontrado define a stack base. **Atualize `engineering.md`** com o que detectou para evitar nova descoberta na proxima task.
3. **Greenfield (nada encontrado)**: pergunte ao user qual stack antes de aplicar exemplos. Nao assuma TS/React por default.

Em qualquer caso: ao escrever novos arquivos/comandos no projeto, use as convencoes da stack detectada, nao as do template. Skills com afinidade de stack (`typescript-best-practices`, `playwright-best-practices`, etc.) so devem ser invocadas quando a stack do projeto as justifica.

---

## TL;DR — Regras Criticas

### Workflow
- **Task first**: abra task/issue ANTES de modificar codigo
- **Branch**: `feature/[TASK-ID]-nome` ou `fix/[TASK-ID]-nome`
- **Commits**: atomicos, mensagens descritivas (Conventional Commits)
- **PR**: use [`.github/PULL_REQUEST_TEMPLATE.md`](./.github/PULL_REQUEST_TEMPLATE.md) — Summary, Changes, Why, Test plan, Risk, Checklist

### Qualidade de Codigo
- Seguir as skills `architecture-rules` (+ `testing-discipline`, `pre-pr-checks`)
- Documentar funcoes publicas
- Tratar erros adequadamente
- Arquivos pequenos e focados

### Documentacao (OBRIGATORIO)
Sempre que houver mudanca significativa, **atualize a documentacao afetada**:
- Nova feature / endpoint / schema → `context/` correspondente
- Decisao arquitetural relevante → novo ADR em `context/adr/`
- Mudanca de stack / dependencia → `context/architecture/engineering.md`

### Anti-Patterns (NUNCA FACA)
1. Modificar codigo sem task criada
2. Commits com codigo de debug
3. Ignorar erros de linting/tipos
4. Arquivos muito grandes (> [LIMITE_LINHAS, ex. 500])
5. Logica de negocio em componentes UI

---

## Estrutura do Repositorio

> Arvore completa em [`README.md`](./README.md#estrutura-de-pastas). O agente em runtime precisa conhecer apenas:

- [`.agents/skills/`](./.agents/skills/) — skills instaladas: **governanca + regras de codigo** (`workflow-governance`, `task-start`, `task-flow`, `architecture-rules`, `testing-discipline`, `pre-pr-checks`, `codex-review`) + skills stack-especificas. SSoT, expostas via symlink em cada provider.
- [`context/`](./context/) — documentacao de dominio (PRD, arquitetura, ADRs, glossario)
- [`.mcp.json`](./.mcp.json) — MCPs configurados

---

## MCPs Configurados

> Liste os MCPs ativos em [`.mcp.json`](./.mcp.json) (exemplo em [`.mcp.json.example`](./.mcp.json.example)).

| MCP | Proposito |
|-----|-----------|
| [MCP_1] | [PROPOSITO] |
| [MCP_2] | [PROPOSITO] |

---

## Comandos Uteis

```bash
# Desenvolvimento
[COMANDO_DEV]

# Build
[COMANDO_BUILD]

# Testes
[COMANDO_TESTS]

# Linting
[COMANDO_LINT]
```

---

## Skills Disponiveis

Skills vivem em `.agents/skills/` e sao expostas via symlink para cada provider (`.claude/skills/`, `.gemini/skills/`, etc.). Fonte unica de verdade — sem duplicacao.

Skills instaladas (ver [`skills-lock.json`](./skills-lock.json) para versoes das skills gerenciadas via `npx skills`).

> Agrupamento por **aplicabilidade**, nao por tema. Skills stack-especificas seguem o ADR multi-stack: ficam no template mas so disparam quando o frontmatter `description`/`triggers` da skill casa com a stack/contexto do projeto.

### Workflow & Processo — governanca como skill

> Substituem as antigas pastas `.agents/governance/` + `.agents/rules/` (ver ADR [`2026-05-27-governance-rules-as-skills.md`](./context/adr/2026-05-27-governance-rules-as-skills.md)). **Tracker/task e opcional** em `workflow-governance`/`task-start`/`task-flow` — projetos sem ClickUp/Jira/Linear pulam os passos de tracker.

| Skill | Quando usar |
|-------|-------------|
| `task-start` | Inicio de task de codigo (ritual: tracker opcional → branch → analise) |
| `task-flow` | Fechamento de task (commit → docs → checks → tracker opcional) |
| `workflow-governance` | Golden rules, status, Conventional Commits, protocolo de PR |
| `architecture-rules` | SoC/SRP, estado, erros, performance, tamanho, anti-patterns |
| `testing-discipline` | Anti-skip + 8 classes de vulnerabilidade (ao tocar testes) |
| `pre-pr-checks` | Lint/type-check/test/build antes de `gh pr create` |
| `codex-review` | Segunda opiniao em DB/security/refactor grande |

### Universal — sempre uteis, qualquer stack

| Skill | Quando usar |
|-------|-------------|
| `clean-architecture` | Camadas, boundaries, use cases |
| `clean-code` | Nomenclatura, funcoes, comentarios, erros |
| `clean-code-principles` | DRY, KISS, YAGNI, SOLID |
| `solid-principles` | SOLID, TDD, design patterns, code smells |
| `coding-standards` | Padroes gerais de codigo (exemplos em TS/JS, principios aplicaveis a qualquer linguagem) |
| `git-commit` | Mensagens de commit (Conventional Commits) |
| `update-docs` | Sincronizar docs apos mudanca significativa (le perfil em [`.agents/update-docs.profile.yaml`](./.agents/update-docs.profile.yaml)) |
| `root-cause-debugging` | Investigar bug ja manifestado — hipotese-first, verifica DB→API→state→render antes de fixar |
| `ai-agents-architect` | Design de agentes, tool use, orquestracao |
| `find-skills` | Descobrir e instalar novas skills |
| `adr-skill` | Criar/manter ADRs |

### Stack-especificas — lazy-triggered

> Estas skills ficam silenciosas em projetos que nao casam com seu trigger. **Nao invoque manualmente** sem antes confirmar que a stack do projeto justifica.

| Skill | Trigger / quando aplica |
|-------|--------------------------|
| `typescript-best-practices` | Projeto usa TypeScript (presenca de `tsconfig.json`, arquivos `.ts`/`.tsx`) |
| `typescript-advanced-types` | TS, ao trabalhar com generics complexos / mapped / conditional types |
| `web-performance-optimization` | Projeto frontend web (Core Web Vitals, bundle size) |
| `api-security-best-practices` | Projeto expoe API HTTP (auth, authz, rate limit) — exemplos em Node, principios universais |
| `top-web-vulnerabilities` | Aplicacao web (OWASP Top 10) |
| `xss-html-injection` | Frontend web com renderizacao de input do usuario |
| `playwright-best-practices` | Testes E2E com Playwright |

### Instalando novas skills

Padrao: conteudo da skill vive em `.agents/skills/<nome>/`; cada provider expoe via symlink (ex.: `.claude/skills/<nome>` → `../../.agents/skills/<nome>`). Sem duplicacao.

```bash
# Skills do registry oficial (gerenciadas via skills-lock.json)
npx skills add <owner/repo@skill-name> -y

# Skills manuais: copie o conteudo para .agents/skills/<nome>/ e crie symlinks nos
# providers usados. Skills assim NAO ficam registradas em skills-lock.json.
```

> Apos instalar, remova diretorios de providers nao suportados neste template.
