# Context Documentation - [NOME_DO_PROJETO]

> Este diretorio contem a documentacao de contexto para o projeto **[NOME_DO_PROJETO]**.
>
> **Como preencher**: Substitua todos os placeholders `[TEXTO]` com informacoes do seu projeto.

---

## Guia de Leitura

| Perfil | Arquivos Recomendados | Objetivo |
|--------|----------------------|----------|
| **Novo no Projeto** | `00-overview` → `01-product-prd` → `04-engineering` | Entender visao e arquitetura |
| **Desenvolvedor** | `03-data-model` → `05-dictionary` → `02-business-rules` | Implementar features |
| **LLM/Agente** | `CLAUDE.md` ou `GEMINI.md` → `.agent/governance/workflow.md` | Executar tarefas |

---

## Indice de Arquivos

### Produto & Negocio

| Arquivo | Conteudo |
|---------|----------|
| [01-product-prd.md](./01-product-prd.md) | PRD - Visao, escopo, user stories |
| [02-business-rules.md](./02-business-rules.md) | Regras de negocio e validacoes |

### Modelagem de Dados

| Arquivo | Conteudo |
|---------|----------|
| [03-data-model.md](./03-data-model.md) | Entidades, Schemas, Relacionamentos |

### Engenharia & Arquitetura

| Arquivo | Conteudo |
|---------|----------|
| [04-engineering.md](./04-engineering.md) | Stack tecnico, ADRs, estrutura de pastas |
| [05-dictionary.md](./05-dictionary.md) | Dicionario de entidades e termos |
| [06-user-guide.md](./06-user-guide.md) | Guia de Uso e Fluxos de UI |
| [07-technical-specs.md](./07-technical-specs.md) | Especificacoes tecnicas adicionais |

### Processo & Governanca

| Arquivo | Conteudo |
|---------|----------|
| [CLAUDE.md](../CLAUDE.md) | Entry point Claude Code |
| [GEMINI.md](../GEMINI.md) | Entry point Gemini |
| [workflow.md](../.agent/governance/workflow.md) | Workflow de Desenvolvimento |
| [01-architecture.md](../.agent/rules/01-architecture.md) | Padroes de Arquitetura |

---

## Regras de Ouro

1. **Terminologia**: Defina termos no `05-dictionary.md` e use-os consistentemente em todos os docs.
2. **SSoT**: Cada conceito tem um unico lugar canonico. Outros arquivos devem apenas referenciar.
3. **Atualizacao**: Mantenha os docs sincronizados com o codigo. Documentacao desatualizada e pior que nenhuma.

---

## Quick Links

<!-- Adicione links relevantes do seu projeto -->

| Recurso | Link |
|---------|------|
| Repositorio | `[URL_DO_REPO]` |
| Board (Jira/Linear/ClickUp) | `[URL_DO_BOARD]` |
| Design (Figma) | `[URL_DO_FIGMA]` |
| Staging | `[URL_STAGING]` |
| Production | `[URL_PRODUCAO]` |

---

> **Ultima atualizacao**: [DATA]
