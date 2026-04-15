# Context Documentation - [NOME_DO_PROJETO]

> Documentacao de dominio do projeto **[NOME_DO_PROJETO]**. Unica fonte de verdade para o **o que** e **porque** do produto e da arquitetura.
>
> **Como preencher**: substitua placeholders `[TEXTO]` com informacoes do projeto. Apague secoes que nao se aplicam.

---

## Estrutura

```
context/
├── README.md              # Este arquivo (indice)
├── product/               # O que o produto faz e as regras de negocio
├── architecture/          # Como o sistema e construido
├── domain/                # Linguagem e modelo de dados
├── guides/                # Onboarding, tutoriais, guias de uso
├── adr/                   # Decisoes arquiteturais (registros)
├── quality/               # Cobertura de testes, metricas
├── history/               # Roadmaps passados, contexto historico
├── archive/               # Docs substituidos (manter por rastreabilidade)
└── providers/             # Configuracao por provedor de AI
```

## Guia de Leitura

| Perfil | Caminho sugerido |
|--------|------------------|
| **Novo no projeto** | [`product/prd.md`](./product/prd.md) -> [`architecture/engineering.md`](./architecture/engineering.md) -> [`domain/glossary.md`](./domain/glossary.md) |
| **Desenvolvedor ativo** | [`domain/data-model.md`](./domain/data-model.md) -> [`product/business-rules.md`](./product/business-rules.md) -> [`adr/README.md`](./adr/README.md) |
| **Agente LLM** | [`../CLAUDE.md`](../CLAUDE.md) (entry point canonico) |

---

## Indice

### Produto & Negocio
- [`product/prd.md`](./product/prd.md) — PRD: visao, escopo, user stories
- [`product/business-rules.md`](./product/business-rules.md) — Regras de negocio e validacoes

### Arquitetura & Engenharia
- [`architecture/engineering.md`](./architecture/engineering.md) — Stack tecnico, estrutura de pastas
- [`architecture/technical-specs.md`](./architecture/technical-specs.md) — Especificacoes tecnicas
- [`adr/README.md`](./adr/README.md) — **Decisoes arquiteturais** (ler antes de alterar areas governadas)

### Dominio
- [`domain/data-model.md`](./domain/data-model.md) — Entidades, schemas, relacionamentos
- [`domain/glossary.md`](./domain/glossary.md) — Dicionario de termos do dominio

### Guias
- [`guides/user-guide.md`](./guides/user-guide.md) — Guia de uso e fluxos de UI

### Meta
- [`providers/`](./providers/) — Configuracao por provedor (Claude, Gemini, Cursor, Codex, OpenCode, Copilot)
- [`quality/`](./quality/) — Metricas e cobertura
- [`history/`](./history/) — Roadmaps e analises passadas
- [`archive/`](./archive/) — Docs substituidos

---

## Regras de Ouro

1. **SSoT**: cada conceito em **um** arquivo canonico; outros apenas referenciam.
2. **Terminologia**: termos vivem em `domain/glossary.md` — usar consistentemente.
3. **ADRs**: toda decisao arquitetural relevante vira um ADR. Documentacao desatualizada e pior que nenhuma.
4. **Archive, nao delete**: docs substituidos vao para `archive/` com link para o sucessor.

---

## Quick Links

| Recurso | Link |
|---------|------|
| Repositorio | `[URL_DO_REPO]` |
| Board (Jira/Linear/ClickUp) | `[URL_DO_BOARD]` |
| Design (Figma) | `[URL_DO_FIGMA]` |
| Staging | `[URL_STAGING]` |
| Producao | `[URL_PRODUCAO]` |

---

> **Ultima atualizacao**: [DATA]
