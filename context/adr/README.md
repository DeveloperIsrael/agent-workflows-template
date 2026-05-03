# Architecture Decision Records (ADRs)

> Registro canonico das decisoes arquiteturais do projeto **[NOME_DO_PROJETO]**.

ADRs tornam decisoes **descobriveis, versionaveis e auditaveis** — permitindo que contribuidores (humanos ou agentes) entendam o *porque* das escolhas sem reabrir discussoes ja resolvidas.

---

## O que e um ADR

Documento curto que captura uma decisao tecnica significativa: o **contexto**, a **decisao tomada** e as **consequencias**. Nao e documentacao viva do codigo — e o registro de **porque** a arquitetura esta como esta.

---

## Quando escrever um ADR

Escreva um ADR quando a decisao:

- **Altera como o sistema e construido ou operado** (nova dependencia, padrao arquitetural, contrato de API, escolha de infra)
- **E dificil de reverter** uma vez que codigo foi escrito em cima dela
- **Afeta outras pessoas ou agentes** que vao mexer no codebase depois
- **Tem alternativas reais** que foram consideradas e rejeitadas

**NAO escreva ADR para:**

- Escolhas rotineiras dentro de um padrao ja estabelecido
- Bug fixes ou correcoes de typo
- Decisoes ja capturadas em ADR existente (atualize-o no lugar)
- Preferencias de estilo ja cobertas por linters

---

## Triggers proativos (para agentes)

Se voce e um agente codificando no repo, **pare e proponha um ADR** antes de continuar quando:

- Estiver prestes a introduzir uma nova dependencia
- Estiver prestes a criar um novo padrao arquitetural (nova camada, nova convencao de API)
- Estiver prestes a escolher entre duas alternativas reais com tradeoffs nao-obvios
- Estiver prestes a mudar algo que contradiz um ADR aceito
- Estiver escrevendo um comentario longo explicando "por que" — esse motivo pertence a um ADR

---

## Convencoes

- **Diretorio:** `context/adr/`
- **Nome do arquivo:** `YYYY-MM-DD-titulo-em-kebab-case.md`
- **Status permitidos:** `proposed`, `accepted`, `rejected`, `deprecated`, `superseded`
- **Frontmatter obrigatorio:**
  ```yaml
  ---
  title: "[TITULO_DA_DECISAO]"
  date: YYYY-MM-DD
  status: proposed  # proposed | accepted | rejected | deprecated | superseded
  supersedes: null  # path/para/outro-adr.md ou null
  superseded_by: null  # preenchido quando outra decisao substitui esta
  tags: []  # ex: [auth, data, ci, security]
  ---
  ```
- **Template padrao:** [`_template.md`](./_template.md)

---

## Estados

| Status | Significado |
|--------|-------------|
| `proposed` | Rascunho em discussao |
| `accepted` | Decisao em vigor — seguir |
| `rejected` | Considerada e descartada (mantida para historico) |
| `superseded` | Substituida por outro ADR (referenciar em `superseded_by`) |
| `deprecated` | Nao aplicar mais, mas mantida para historico |

---

## Workflow

1. **Proposta**: crie o ADR com `status: proposed` (copie `_template.md`)
2. **Discussao**: itere ate alinhamento com decision-makers
3. **Commit**: marque como `accepted` (ou `rejected`) e adicione no indice abaixo
4. **Supersecao**: quando substituido, crie novo ADR e marque o antigo como `superseded` com link bidirecional (`superseded_by` no antigo, `supersedes` no novo)

---

## Consulta (obrigatorio antes de implementar)

Antes de comecar trabalho que toque arquitetura (auth, data layer, API, infra, CI, seguranca), **leia os ADRs `accepted` aplicaveis**. Se encontrar conflito entre codigo e ADR, sinalize antes de mudar.

Ao implementar codigo governado por um ADR, adicione comentario no ponto de entrada (sintaxe varia por linguagem):

```ts
// ADR: context/adr/2026-04-14-rls-defense-in-depth.md
// Motivo: <resumo de uma linha>
```

```python
# ADR: context/adr/2026-04-14-rls-defense-in-depth.md
# Motivo: <resumo de uma linha>
```

---

## Indice

| Data | Titulo | Status |
|------|--------|--------|
| 2026-05-01 | [Template Multi-Stack Strategy](2026-05-01-template-multi-stack-strategy.md) | accepted |
| _Adicione novos ADRs aqui_ | | |

---

## Referencias

- **MADR (Markdown ADR):** https://adr.github.io/madr/
- **Michael Nygard — Documenting Architecture Decisions:** https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions
- **Skill `adr-skill`** (opcional, via plugin Claude Code): assistencia para criar/revisar ADRs
