# [NOME_DO_PROJETO] — Entry Point Canonico para Agentes

> **Este e o documento canonico para todos os agentes** (Claude, Gemini, Codex, Copilot, Cursor, OpenCode).
> `GEMINI.md` e `AGENTS.md` sao stubs que apontam para aqui.
>
> Substitua `[NOME_DO_PROJETO]` e demais placeholders `[TEXTO]` ao adotar o template.

> **AVISO PARA AGENTES** — este repositorio **é um template** (`agent-workflows-template`). Tudo dentro de `.agents/`, `.claude/`, `.cursor/`, `.gemini/`, etc. existe para ser **herdado por projetos clonados a partir deste template**. NAO remova skills, regras, ou configuracoes daqui sob argumento de "duplicacao com setup global do usuario" — a duplicacao **e intencional**: o template precisa funcionar de forma standalone para quem clona. Mudancas aqui afetam todos os projetos futuros.

---

## Leitura Obrigatoria

Ao iniciar uma task, leia nesta ordem:

1. **Workflow de desenvolvimento** — [`.agents/governance/workflow.md`](./.agents/governance/workflow.md)
2. **Regras de codigo** — [`.agents/rules/`](./.agents/rules/) (`01-architecture.md`, `02-pdi.md`, `03-testing.md`, `04-pre-pr-checks.md`)
3. **Contexto do dominio** — [`context/README.md`](./context/README.md)
4. **ADRs ativos** — [`context/adr/README.md`](./context/adr/README.md) — consulte antes de alterar areas governadas (status `accepted`) e referencie o ADR em comentario no ponto de entrada da mudanca

---

## TL;DR — Regras Criticas

### Workflow
- **Task first**: abra task/issue ANTES de modificar codigo
- **Branch**: `feature/[TASK-ID]-nome` ou `fix/[TASK-ID]-nome`
- **Commits**: atomicos, mensagens descritivas (Conventional Commits)
- **PR**: use [`.github/PULL_REQUEST_TEMPLATE.md`](./.github/PULL_REQUEST_TEMPLATE.md) — Summary, Changes, Why, Test plan, Risk, Checklist

### Qualidade de Codigo
- Seguir [`.agents/rules/`](./.agents/rules/)
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

- [`.agents/governance/`](./.agents/governance/) — workflow de desenvolvimento
- [`.agents/rules/`](./.agents/rules/) — regras de codigo (arquitetura, PDI, testes)
- [`.agents/skills/`](./.agents/skills/) — skills instaladas (SSoT, expostas via symlink em cada provider)
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

Skills instaladas (ver [`skills-lock.json`](./skills-lock.json) para versoes das skills gerenciadas via `npx skills`):

**Arquitetura & qualidade de codigo**

| Skill | Quando usar |
|-------|-------------|
| `clean-architecture` | Camadas, boundaries, use cases |
| `clean-code` | Nomenclatura, funcoes, comentarios, erros |
| `clean-code-principles` | DRY, KISS, YAGNI, SOLID |
| `solid-principles` | SOLID, TDD, design patterns, code smells |
| `coding-standards` | Padroes universais TS/JS/React/Node |

**TypeScript & performance**

| Skill | Quando usar |
|-------|-------------|
| `typescript-best-practices` | Tipos avancados, illegal states, exhaustive handling |
| `typescript-advanced-types` | Conditional, mapped, template literal types, inference |
| `web-performance-optimization` | Bundle size, runtime perf, Core Web Vitals |

**Seguranca**

| Skill | Quando usar |
|-------|-------------|
| `api-security-best-practices` | Auth, authz, rate limit, input validation |
| `top-web-vulnerabilities` | OWASP Top 10, categorias de vulnerabilidades |
| `xss-html-injection` | XSS, HTML injection, client-side injection |

**Testes & operacao**

| Skill | Quando usar |
|-------|-------------|
| `playwright-best-practices` | E2E, browser automation, test patterns |
| `update-docs` | Sincronizar docs apos mudanca significativa (le perfil em [`.agents/update-docs.profile.yaml`](./.agents/update-docs.profile.yaml)) |
| `git-commit` | Mensagens de commit (Conventional Commits) |

**Agentes & meta**

| Skill | Quando usar |
|-------|-------------|
| `ai-agents-architect` | Design de agentes, tool use, orquestracao |
| `find-skills` | Descobrir e instalar novas skills |

### Instalando novas skills

Padrao: conteudo da skill vive em `.agents/skills/<nome>/`; cada provider expoe via symlink (ex.: `.claude/skills/<nome>` → `../../.agents/skills/<nome>`). Sem duplicacao.

```bash
# Skills do registry oficial (gerenciadas via skills-lock.json)
npx skills add <owner/repo@skill-name> -y

# Skills manuais: copie o conteudo para .agents/skills/<nome>/ e crie symlinks nos
# providers usados. Skills assim NAO ficam registradas em skills-lock.json.
```

> Apos instalar, remova diretorios de providers nao suportados neste template.
