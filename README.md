# Agent Workflows Template

Template de estrutura de documentacao e configuracao para projetos que utilizam **AI Coding Agents** (Claude Code, Gemini, Cursor, OpenCode, Codex, etc.).

> **Agentes** (Claude/Gemini/Codex/Copilot/Cursor/OpenCode): leiam [`CLAUDE.md`](./CLAUDE.md) — entry point canonico em runtime. Este README e para humanos (setup, configuracao inicial, contribuicao).

---

## Proposito

Este template fornece uma estrutura padronizada para:

1. **Documentacao de Contexto** (`context/`) - Arquivos que os agentes leem para entender o projeto
2. **Regras e Governanca** (`.agents/`) - Padroes de codigo e workflows de desenvolvimento
3. **Configuracoes de Agentes** (`.claude/`, `.gemini/`, `.cursor/`, etc.) - Settings especificos por ferramenta

---

## Estrutura de Pastas

```
.
├── CLAUDE.md                   # Entry point CANONICO para agentes
├── GEMINI.md                   # Stub -> CLAUDE.md
├── AGENTS.md                   # Stub -> CLAUDE.md (Codex/OpenCode)
├── README.md                   # Este arquivo (para humanos)
│
├── context/                    # Documentacao de contexto (semantica por pasta)
│   ├── README.md               # Indice e guia de leitura
│   ├── product/                # PRD, regras de negocio
│   │   ├── prd.md
│   │   └── business-rules.md
│   ├── architecture/           # Stack, engenharia, specs tecnicas
│   │   ├── engineering.md
│   │   └── technical-specs.md
│   ├── domain/                 # Modelo de dados e glossario
│   │   ├── data-model.md
│   │   └── glossary.md
│   ├── guides/                 # Guias de uso e onboarding
│   │   └── user-guide.md
│   ├── adr/                    # Architecture Decision Records
│   │   ├── README.md           # Convencao + indice
│   │   └── _template.md        # Template de ADR
│   ├── quality/                # Metricas, cobertura (slot vazio)
│   ├── history/                # Roadmaps e analises passadas
│   ├── archive/                # Docs substituidos
│   └── providers/              # Guias por provedor de AI
│
├── .agents/                    # SSoT: governanca + regras + skills (cross-provider)
│   ├── governance/workflow.md
│   ├── rules/
│   │   ├── README.md           # Convencao de rules
│   │   └── 01-architecture.md  # Padroes de arquitetura
│   └── skills/                 # Skills instaladas (expostas via symlink em .claude/, .gemini/, etc.)
│
├── .claude/                    # Configuracoes Claude Code
├── .gemini/                    # Configuracoes Gemini
├── .cursor/                    # Configuracoes Cursor
├── .codex/                     # Configuracoes Codex (OpenAI)
├── .opencode/                  # Configuracoes OpenCode
├── .github/                    # Configuracoes GitHub Copilot
│
└── .mcp.json.example           # Template de MCPs (renomear para .mcp.json)
```

---

## Como Usar Este Template

### 1. Clone ou Fork

```bash
# Via GitHub template
gh repo create meu-projeto --template seu-usuario/agent-workflows-template

# Ou copie manualmente
cp -r agent-workflows-template/ meu-projeto/
```

### 2. Preencha a Documentacao de Contexto

Preencha os arquivos em `context/`:

| Arquivo | O que preencher | Quem deve preencher |
|---------|-----------------|---------------------|
| `README.md` | Nome do projeto, links para outros docs | Tech Lead / PM |
| `product/prd.md` | Visao, problema, solucao, escopo | Product Manager |
| `product/business-rules.md` | Regras de negocio e validacoes | PM + Devs |
| `domain/data-model.md` | Entidades, schemas, relacionamentos | Arquiteto / Senior Dev |
| `architecture/engineering.md` | Stack, estrutura de pastas | Tech Lead |
| `architecture/technical-specs.md` | Specs tecnicas especificas | Senior Devs |
| `domain/glossary.md` | Glossario de termos e entidades | Time todo |
| `guides/user-guide.md` | Fluxos de usuario, UI/UX | Designer / PM |
| `adr/*.md` | Decisoes arquiteturais relevantes | Tech Lead |

### 3. Configure as Regras do Agente

Edite os arquivos em `.agents/`:

- **`.agents/rules/01-architecture.md`** - Adapte para seu stack (React, Vue, Node, etc.)
- **`.agents/governance/workflow.md`** - Configure seu workflow (Jira, Linear, ClickUp, etc.)

### 4. Configure as Ferramentas

Ajuste os arquivos de configuracao por ferramenta (veja `context/providers/` para detalhes):

| Ferramenta | Arquivo | Formato |
|------------|---------|---------|
| Claude Code | `.claude/settings.json` | JSON |
| Gemini | `.gemini/settings.json` | JSON |
| Cursor | `.cursor/rules/*.mdc` | MDC (Markdown + YAML) |
| Codex | `.codex/config.toml` | TOML |
| OpenCode | `.opencode/settings.json` | JSON |
| Copilot | `.github/copilot-instructions.md` | Markdown |

### 5. Configure MCPs (opcional)

Para usar MCP servers com Claude Code:

```bash
cp .mcp.json.example .mcp.json
# Edite .mcp.json com suas configuracoes
```

---

## Guia de Leitura por Perfil

| Perfil | Caminho de Leitura | Objetivo |
|--------|-------------------|----------|
| **Novo no Projeto** | `context/README` → `product/prd` → `architecture/engineering` | Entender visao e arquitetura |
| **Desenvolvedor** | `domain/data-model` → `domain/glossary` → `product/business-rules` → `adr/` | Implementar features |
| **LLM/Agente** | [`CLAUDE.md`](./CLAUDE.md) (entry point canonico — define a propria leitura obrigatoria) | Executar tarefas |

---

## Regras de Ouro

1. **Single Source of Truth (SSoT)**: Cada conceito tem um unico lugar canonico. Outros arquivos apenas referenciam.
2. **Terminologia Consistente**: Defina termos em `context/domain/glossary.md` e use-os consistentemente.
3. **Documentacao Viva**: Atualize os docs junto com o codigo.
4. **ADRs para decisoes**: registre decisoes arquiteturais em `context/adr/` antes de implementar.
5. **Agentes como Primeira Classe**: escreva documentacao pensando que um LLM vai ler — por isso `CLAUDE.md` e canonico e outros entry points sao stubs.

---

## Configuracao por Ferramenta

Cada ferramenta tem sua estrutura de configuracao. Veja detalhes em `context/providers/`.

| Ferramenta | Entry Point | Config | MCPs |
|------------|-------------|--------|------|
| Claude Code | `CLAUDE.md` (canonico) | `.claude/settings.json` | `.mcp.json` (raiz) |
| Gemini | `GEMINI.md` (stub) | `.gemini/settings.json` | Dentro do settings |
| Cursor | `.cursor/rules/*.mdc` | `.cursor/settings.json` | Via settings |
| Codex (OpenAI) | `AGENTS.md` (stub) | `.codex/config.toml` | Via config |
| OpenCode | `AGENTS.md` (stub) | `.opencode/settings.json` | Via config |
| GitHub Copilot | `.github/copilot-instructions.md` | VS Code settings | N/A |

> **Nota**: Consulte `context/providers/` para guias detalhados de cada ferramenta.
>
> **Skills, MCPs e comandos ativos** vivem em [`CLAUDE.md`](./CLAUDE.md) — nao duplique aqui.

---

## Contribuindo

1. Fork este repositorio
2. Crie uma branch (`git checkout -b feature/melhoria`)
3. Commit suas mudancas (`git commit -m 'feat: adiciona X'`)
4. Push para a branch (`git push origin feature/melhoria`)
5. Abra um Pull Request

---

## Licenca

CC BY 4.0 - veja [LICENSE](LICENSE) para detalhes.

---

**Versao do template**: 2.0.0 — filosofia DRY (uma unica fonte de verdade para cada aspecto).
