# Agent Workflows Template

Template de estrutura de documentacao e configuracao para projetos que utilizam **AI Coding Agents** (Claude Code, Gemini, Cursor, OpenCode, Codex, etc.).

---

## Proposito

Este template fornece uma estrutura padronizada para:

1. **Documentacao de Contexto** (`context/`) - Arquivos que os agentes leem para entender o projeto
2. **Regras e Governanca** (`.agent/`) - Padroes de codigo e workflows de desenvolvimento
3. **Configuracoes de Agentes** (`.claude/`, `.gemini/`, `.cursor/`, etc.) - Settings especificos por ferramenta

---

## Estrutura de Pastas

```
.
├── context/                    # Documentacao de contexto do projeto
│   ├── 00-overview.md          # Indice e guia de leitura
│   ├── 01-product-prd.md       # Product Requirements Document
│   ├── 02-business-rules.md    # Regras de negocio
│   ├── 03-data-model.md        # Modelo de dados
│   ├── 04-engineering.md       # Arquitetura tecnica e ADRs
│   ├── 05-dictionary.md        # Dicionario de entidades
│   ├── 06-user-guide.md        # Guia de uso/fluxos de UI
│   └── 07-technical-specs.md   # Especificacoes tecnicas adicionais
│
├── .agent/                     # Regras e governanca (agnóstico de ferramenta)
│   ├── governance/             # Workflows e processos
│   │   └── workflow.md         # Workflow de desenvolvimento
│   └── rules/                  # Regras de codigo
│       └── 01-architecture.md  # Padroes de arquitetura
│
├── .claude/                    # Configuracoes Claude Code
│   └── settings.json           # Permissoes e ambiente
│
├── .gemini/                    # Configuracoes Gemini
│   └── settings.json           # Configuracoes do Gemini
│
├── .cursor/                    # Configuracoes Cursor
│   └── settings.json           # Configuracoes do Cursor
│
├── .codex/                     # Configuracoes Codex
│   └── settings.json           # Configuracoes do Codex
│
├── .opencode/                  # Configuracoes OpenCode
│   └── settings.json           # Configuracoes do OpenCode
│
├── .github/                    # GitHub Actions e templates
│   └── ...
│
└── .agents/                    # Skills compartilhados (opcional)
    └── skills/                 # Skills instalados
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

Siga a ordem dos arquivos em `context/`:

| Arquivo | O que preencher | Quem deve preencher |
|---------|-----------------|---------------------|
| `00-overview.md` | Nome do projeto, links para outros docs | Tech Lead / PM |
| `01-product-prd.md` | Visao, problema, solucao, escopo | Product Manager |
| `02-business-rules.md` | Regras de negocio e validacoes | PM + Devs |
| `03-data-model.md` | Entidades, schemas, relacionamentos | Arquiteto / Senior Dev |
| `04-engineering.md` | Stack, ADRs, estrutura de pastas | Tech Lead |
| `05-dictionary.md` | Glossario de termos e entidades | Time todo |
| `06-user-guide.md` | Fluxos de usuario, UI/UX | Designer / PM |
| `07-technical-specs.md` | Specs tecnicas especificas | Senior Devs |

### 3. Configure as Regras do Agente

Edite os arquivos em `.agent/`:

- **`.agent/rules/01-architecture.md`** - Adapte para seu stack (React, Vue, Node, etc.)
- **`.agent/governance/workflow.md`** - Configure seu workflow (Jira, Linear, ClickUp, etc.)

### 4. Configure as Ferramentas

Ajuste os arquivos de configuracao por ferramenta:

- **`.claude/settings.json`** - Permissoes de comandos
- **`.gemini/settings.json`** - Configuracoes do Gemini
- **`.cursor/settings.json`** - Rules e comportamentos

---

## Guia de Leitura por Perfil

| Perfil | Caminho de Leitura | Objetivo |
|--------|-------------------|----------|
| **Novo no Projeto** | `00-overview` → `01-product-prd` → `04-engineering` | Entender visao e arquitetura |
| **Desenvolvedor** | `03-data-model` → `05-dictionary` → `02-business-rules` | Implementar features |
| **LLM/Agente** | `CLAUDE.md` ou `GEMINI.md` → `.agent/governance/` | Executar tarefas |

---

## Regras de Ouro

1. **Single Source of Truth (SSoT)**: Cada conceito tem um unico lugar canonico. Outros arquivos apenas referenciam.
2. **Terminologia Consistente**: Defina termos no `05-dictionary.md` e use-os consistentemente.
3. **Documentacao Viva**: Atualize os docs junto com o codigo.
4. **Agentes como Primeira Classe**: Escreva documentacao pensando que um LLM vai ler.

---

## Arquivos Entry Point por Ferramenta

Cada ferramenta tem seu arquivo de entrada que deve referenciar os docs relevantes:

| Ferramenta | Entry Point | Descricao |
|------------|-------------|-----------|
| Claude Code | `CLAUDE.md` | Instrucoes e contexto para Claude |
| Gemini | `GEMINI.md` | Instrucoes e contexto para Gemini |
| Cursor | `.cursorrules` | Rules do Cursor |
| GitHub Copilot | `.github/copilot-instructions.md` | Instrucoes do Copilot |

---

## Contribuindo

1. Fork este repositorio
2. Crie uma branch (`git checkout -b feature/melhoria`)
3. Commit suas mudancas (`git commit -m 'feat: adiciona X'`)
4. Push para a branch (`git push origin feature/melhoria`)
5. Abra um Pull Request

---

## Licenca

MIT License - veja [LICENSE](LICENSE) para detalhes.
