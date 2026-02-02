# [NOME_DO_PROJETO] - Claude Code Entry Point

> **Entry Point para Claude Code** - Substitua `[NOME_DO_PROJETO]` pelo nome do seu projeto.

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
├── CLAUDE.md                              # Este arquivo (entry point Claude Code)
├── GEMINI.md                              # Entry point Gemini
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
└── .claude/
    └── settings.json                      # Permissoes
```

---

## MCPs Configurados (Opcional)

> Liste os MCPs configurados no seu projeto, se houver.

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

**Versao**: 1.0.0
**Filosofia**: DRY - Uma unica fonte de verdade para cada aspecto
