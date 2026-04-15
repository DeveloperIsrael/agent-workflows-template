# Architecture Decision Records (ADRs)

> Registro de decisões arquiteturais relevantes do projeto **[NOME_DO_PROJETO]**.

## O que e um ADR

Documento curto que captura uma decisao tecnica significativa: o **contexto**, a **decisao tomada** e as **consequencias**. Nao e documentacao viva do codigo — e o registro de **porque** a arquitetura esta como esta.

## Quando criar um ADR

Crie um ADR quando a decisao:

- Afeta boundaries entre modulos/servicos
- Define uma politica que times devem seguir (ex.: autenticacao, RLS, estrategia de cache)
- Troca uma stack ou framework relevante
- Introduz um trade-off que voce quer que futuros mantenedores entendam

**Nao crie** ADR para: refatoracoes locais, escolhas reversiveis triviais, convencoes de formatacao.

## Convencao de Nomes

```
YYYY-MM-DD-titulo-em-kebab-case.md
```

Exemplos:
- `2026-01-15-adotar-repository-pattern.md`
- `2026-02-03-migrar-para-postgres.md`

## Estados

| Status | Significado |
|--------|-------------|
| `proposed` | Rascunho em discussao |
| `accepted` | Decisao em vigor — seguir |
| `superseded` | Substituida por outro ADR (referenciar no YAML) |
| `deprecated` | Nao aplicar mais, mas mantida para historico |

## Como criar

1. Copie [`_template.md`](./_template.md) com o novo nome.
2. Preencha as secoes.
3. Adicione uma linha na tabela abaixo.
4. Abra PR com o ADR como arquivo separado.

## Indice

| Data | Titulo | Status |
|------|--------|--------|
| _Nenhum ADR registrado ainda_ | | |

---

> **Leitura obrigatoria para agentes**: antes de alterar areas governadas por um ADR `accepted`, leia o registro e referencie-o em comentario no ponto de entrada da mudanca.
