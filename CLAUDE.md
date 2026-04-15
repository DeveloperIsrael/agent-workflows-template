# [NOME_DO_PROJETO] — Entry Point Canonico para Agentes

> **Este e o documento canonico para todos os agentes** (Claude, Gemini, Codex, Copilot, Cursor, OpenCode).
> `GEMINI.md` e `AGENTS.md` sao stubs que apontam para aqui.
>
> Substitua `[NOME_DO_PROJETO]` e demais placeholders `[TEXTO]` ao adotar o template.

---

## Leitura Obrigatoria

Ao iniciar uma task, leia nesta ordem:

1. **Workflow de desenvolvimento** — [`.agent/governance/workflow.md`](./.agent/governance/workflow.md)
2. **Regras de codigo** — [`.agent/rules/`](./.agent/rules/) (ler todas as rules ativas)
3. **Contexto do dominio** — [`context/README.md`](./context/README.md)
4. **ADRs ativos** — [`context/adr/README.md`](./context/adr/README.md) — consulte antes de alterar areas governadas (status `accepted`) e referencie o ADR em comentario no ponto de entrada da mudanca

---

## TL;DR — Regras Criticas

### Workflow
- **Task first**: abra task/issue ANTES de modificar codigo
- **Branch**: `feature/[TASK-ID]-nome` ou `fix/[TASK-ID]-nome`
- **Commits**: atomicos, mensagens descritivas (Conventional Commits)
- **PR**: descricao clara + criterios de teste

### Qualidade de Codigo
- Seguir [`.agent/rules/`](./.agent/rules/)
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

```
[PROJETO]/
├── CLAUDE.md                    # Entry point canonico (este arquivo)
├── GEMINI.md                    # Stub -> CLAUDE.md
├── AGENTS.md                    # Stub -> CLAUDE.md (Codex/OpenCode convention)
├── README.md                    # Para humanos (setup, stack)
│
├── .agent/                      # Governance + rules (cross-provider)
│   ├── governance/workflow.md
│   ├── rules/                   # 01-architecture.md, 02-*.md, ...
│   └── skills/                  # Symlinks -> .agents/skills/
│
├── .agents/                     # SSoT das skills instaladas
│   └── skills/
│
├── context/                     # Documentacao de dominio (ver context/README.md)
│   ├── product/
│   ├── architecture/
│   ├── domain/
│   ├── guides/
│   ├── adr/
│   └── providers/
│
└── .claude/ .gemini/ .cursor/ .codex/ .opencode/ .github/
    # Configuracoes especificas por provedor
```

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

Skills instaladas (ver [`skills-lock.json`](./skills-lock.json) para versoes exatas):

| Skill | Quando usar |
|-------|-------------|
| `clean-architecture` | Camadas, boundaries, use cases |
| `clean-code` | Nomenclatura, funcoes, comentarios, erros |
| `clean-code-principles` | DRY, KISS, YAGNI, SOLID |
| `solid-principles` | SOLID, TDD, design patterns, code smells |
| `coding-standards` | Padroes universais TS/JS/React/Node |
| `typescript-best-practices` | Tipos avancados, illegal states, exhaustive handling |
| `vercel-react-best-practices` | Performance React/Next.js |
| `frontend-design` | Componentes UI de alta qualidade |
| `ai-agents-architect` | Design de agentes, tool use, orquestracao |
| `git-commit` | Mensagens de commit (Conventional Commits) |
| `find-skills` | Descobrir e instalar novas skills |

### Instalando novas skills

```bash
# Instala nos providers suportados (claude, gemini, github, cursor, codex, opencode)
npx skills add <owner/repo@skill-name> -y
```

> Apos instalar, remova diretorios de providers nao suportados neste template.

---

**Versao do template**: 2.0.0
**Filosofia**: DRY — uma unica fonte de verdade para cada aspecto
