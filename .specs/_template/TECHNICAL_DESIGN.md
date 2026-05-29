# Technical Design — [TASK-ID | —] [Nome curto]

> **Condicional.** Crie este arquivo apenas quando: decisao arquitetural;
> DB/migration/politica de acesso (RLS/ACL)/auth/storage/security; PII/permissao/
> ownership/share/dados sensiveis; risco de perda/corrupcao de dados; mudanca de
> API request/response ou schema; refactor transversal (>3 camadas); candidato a
> ADR; necessidade de rollback/migracao; ou 2+ solucoes plausiveis com tradeoffs
> reais. Senao, delete este arquivo do pacote.
>
> Mantenha alto nivel. Codigo de implementacao detalhado pertence ao executor.

- **Status:** Draft

## Contexto tecnico

[O estado atual relevante e as forcas em jogo.]

## Alternativas consideradas

### Alternativa A: [nome]
[Descricao. Pros. Contras.]

### Alternativa B: [nome]
[Descricao. Pros. Contras.]

## Decisao escolhida

[Qual alternativa e por que. Tradeoff aceito.]

## Arquitetura / fluxo proposto

[Diagrama ASCII ou descricao do fluxo. Componentes e responsabilidades.]

## Contratos (quando aplicavel)

- **Dados:** [schema, tipos, invariantes]
- **API:** [request/response, status codes, erros]
- **Estado:** [shape, ownership, transicoes]

## Seguranca, rollback e observabilidade (quando aplicavel)

- **Seguranca:** [authz, validacao server-side, dados sensiveis]
- **Rollback:** [como reverter; migracao reversivel?]
- **Observabilidade:** [logs/metricas/alertas relevantes]

## Impacto em testes

[Que testes precisam mudar/nascer; cenarios de regressao.]

## Consequencias e riscos residuais

[O que esta decisao trava ou destrava daqui pra frente.]

## Perguntas em aberto

- [Pergunta nao resolvida — se bloqueia, vira Human Gate no `SPEC.md`.]
