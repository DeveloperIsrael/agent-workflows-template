# [NOME_DO_PROJETO] - Gemini Entry Point

> **Entry Point para Gemini** - Substitua `[NOME_DO_PROJETO]` pelo nome do seu projeto.

---

## Leitura Obrigatoria

Ao iniciar uma task, leia na ordem:

1. **Workflow de Desenvolvimento**:
   - [`.agent/governance/workflow.md`](./.agent/governance/workflow.md)

2. **Padroes de Codigo**:
   - [`.agent/rules/01-architecture.md`](./.agent/rules/01-architecture.md)

3. **Contexto do Dominio**:
   - [`context/00-overview.md`](./context/00-overview.md)

---

## TL;DR - Regras Criticas

### Workflow
- **Task First**: Crie task ANTES de modificar codigo
- **Branch**: `feature/[TASK-ID]-nome` ou `fix/[TASK-ID]-nome`
- **Commits**: Atomicos, com mensagens descritivas
- **PR**: Sempre com descricao clara e criterios de teste

### Qualidade de Codigo
- Seguir padroes definidos em `.agent/rules/`
- Documentar funcoes publicas
- Tratar erros adequadamente
- Manter arquivos pequenos e focados

### Anti-Patterns (NUNCA FACA)
1. Modificar codigo sem task criada
2. Commits com codigo de debug
3. Ignorar erros de linting/tipos
4. Arquivos muito grandes (>500 linhas)
5. Logica de negocio em componentes UI

---

## Estrutura de Documentacao

```
[PROJETO]/
├── GEMINI.md                              # Este arquivo (entry point Gemini)
├── CLAUDE.md                              # Entry point Claude Code
├── README.md                              # Para humanos (setup, stack)
│
├── .agent/
│   ├── governance/
│   │   └── workflow.md                    # Workflow de desenvolvimento
│   ├── rules/
│   │   └── 01-architecture.md             # Padroes de arquitetura
│   └── skills/                            # Skills de agentes
│
├── context/                               # Documentacao de dominio
│   ├── 00-overview.md                     # Indice e visao geral
│   ├── 01-product-prd.md                  # PRD
│   ├── 02-business-rules.md               # Regras de negocio
│   ├── 03-data-model.md                   # Modelo de dados
│   ├── 04-engineering.md                  # Arquitetura tecnica
│   ├── 05-dictionary.md                   # Glossario de termos
│   ├── 06-user-guide.md                   # Fluxos de UI
│   └── 07-technical-specs.md              # Specs tecnicas
│
└── .gemini/
    └── settings.json                      # Configuracoes Gemini
```

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

Skills instaladas em `.agents/skills/` com symlinks nos providers suportados:

| Skill | Quando usar |
|-------|------------|
| `clean-architecture` | Arquitetura em camadas, boundaries, use cases |
| `clean-code` | Nomenclatura, funcoes, comentarios, erros |
| `solid-principles` | SOLID, TDD, design patterns, code smells |
| `ai-agents-architect` | Design de agentes, tool use, orquestracao |
| `git-commit` | Gerar mensagens de commit (Conventional Commits) |
| `clean-code-principles` | DRY, KISS, YAGNI, SOLID |
| `coding-standards` | Padroes universais TS/JS/React/Node |
| `typescript-best-practices` | Tipos avancados, illegal states, exhaustive handling |
| `vercel-react-best-practices` | Performance React/Next.js |
| `find-skills` | Descobrir e instalar novas skills |
| `frontend-design` | Componentes UI de alta qualidade |

### Instalando novas skills

```bash
# Instalar skill no projeto (sem -g) para os providers suportados:
# claude, gemini, github, cursor, codex, opencode
npx skills add <owner/repo@skill-name> -y

# Providers suportados neste template:
# .claude/ .gemini/ .github/ .cursor/ .codex/ .opencode/ .agent/ .agents/
```

> Apos instalar, remover quaisquer diretorios de providers nao listados acima.

---

**Versao**: 1.0.0
**Filosofia**: DRY - Uma unica fonte de verdade para cada aspecto
