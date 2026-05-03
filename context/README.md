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

## Authority Hierarchy

> Quando dois documentos discordam, o de maior autoridade vence. Codigo (migrations, schemas, configs) vence prosa. Use esta lista para decidir o que ler primeiro e o que atualizar quando uma decisao muda.

1. [`../CLAUDE.md`](../CLAUDE.md) — governanca, meta-regras, leitura obrigatoria
2. [`../.agents/rules/`](../.agents/rules/) — code standards, testing, regras stack-agnosticas
3. [`adr/`](./adr/) com `status: accepted` — decisoes arquiteturais formais
4. [`product/`](./product/) + [`domain/`](./domain/) — escopo, regras de negocio, modelo de dominio
5. [`architecture/`](./architecture/) — contratos tecnicos (API, DB, plataforma)
6. [`guides/`](./guides/) — guias operacionais (nao canonicos, mas atualizados)
7. [`history/`](./history/) — contexto temporal (nao autoritativo)
8. [`archive/`](./archive/) — obsoleto (ler para entender o passado, nunca citar como atual)

**Regra de codigo > prosa**: arquivos em `src/`, migrations, schemas e configs de runtime sobrescrevem qualquer descricao textual. Se a doc descreve um endpoint diferente do que o handler implementa, o handler vence — atualize a doc, nao o codigo.

---

## Quando READ — qual doc consultar antes de mexer

| Area que voce vai tocar | Leia primeiro |
|---|---|
| Auth, autorizacao, fronteira de seguranca | [`adr/`](./adr/) (filtre por `accepted`) + ADR referenciado em comentario do ponto de entrada |
| Modelo de dados / entidades / schemas | [`domain/data-model.md`](./domain/data-model.md) + [`domain/glossary.md`](./domain/glossary.md) |
| Regra de negocio / escopo do produto | [`product/prd.md`](./product/prd.md) + [`product/business-rules.md`](./product/business-rules.md) |
| Contrato de API (request/response, status codes) | [`architecture/technical-specs.md`](./architecture/technical-specs.md) |
| Schema de banco / migrations | `supabase/migrations/` (ou equivalente) sobrescreve qualquer descricao em `architecture/` |
| Stack / monorepo / toolchain | [`architecture/engineering.md`](./architecture/engineering.md) |
| Onboarding / setup local | [`guides/`](./guides/) |

---

## Quando WRITE — onde documentar o que voce fez

| O que voce mudou | Onde documentar |
|---|---|
| Nova decisao arquitetural | Novo ADR em [`adr/YYYY-MM-DD-<slug>.md`](./adr/) (use [`_template.md`](./adr/_template.md)) |
| Nova stack / dependencia / env var | [`architecture/engineering.md`](./architecture/engineering.md) |
| Novo endpoint / mudanca de contrato | [`architecture/technical-specs.md`](./architecture/technical-specs.md) |
| Nova tabela / migration / RLS policy | Migration em codigo + nota em [`architecture/technical-specs.md`](./architecture/technical-specs.md) ou [`domain/data-model.md`](./domain/data-model.md) |
| Nova regra de negocio | [`product/business-rules.md`](./product/business-rules.md) |
| Nova entidade ou termo de dominio | [`domain/data-model.md`](./domain/data-model.md) + [`domain/glossary.md`](./domain/glossary.md) |
| Nova metrica de qualidade / lane de teste | [`quality/`](./quality/) |
| Doc substituida | Mova para [`archive/`](./archive/) e linke o sucessor; nunca delete |

**Nunca escreva em** [`archive/`](./archive/) (so move para la) ou em diretorios de referencia externa. Se nao souber onde um doc novo vai, abra ADR ou pergunte no PR.

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
