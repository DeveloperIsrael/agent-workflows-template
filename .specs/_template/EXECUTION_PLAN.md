# Execution Plan — [TASK-ID | —] [Nome curto]

## Objetivo

[Em uma frase: o que o executor entrega ao final.]

## Pre-condicoes

- [ ] `SPEC.md` com status `Approved for Execution`.
- [ ] Nenhum Human Gate pendente.
- [ ] `TECHNICAL_DESIGN.md` existe se os gatilhos casaram.

## Execution Graph

```
T1 ──▶ T2 ──▶ T4 (validacao)
   └─▶ T3 ──┘
          ▲
     join gate: T2 e T3 completos antes de T4
```

- **Sequencial:** [T1 → T2 → …]
- **Paralelizavel:** [T2, T3 podem rodar juntas]
- **Join gates:** [antes de qual task todos os retornos precisam chegar]
- **Human gates:** [pontos que exigem decisao humana — idealmente nenhum aqui]

## Ordem obrigatoria

1. [T1 — …]
2. [T2 — …]

## Write scope (concreto — sem curingas)

- `path/exato/arquivo-a.ext`
- `path/exato/arquivo-b.ext`

> Sem `src/**`, `.`, `as needed` ou `TBD`. O executor rejeita escrita fora desta lista.

## Forbidden files

- `path/sensivel/**` — [por que]
- migrations / env / config global — salvo se explicitamente no write scope.

## Subtasks atomicas

| ID | Deliverable | Arquivos | Verificacao |
|----|-------------|----------|-------------|
| T1 | [o que entrega] | [paths] | [como confere] |

## Model routing

- [Perfil/modelo por subtask: mecanico = modelo medio; risco/join/security = modelo forte.]

## Plano de testes

- [Que teste/check rodar por subtask. Comando concreto se a stack ja estiver definida, senao `[COMANDO_TESTS]`.]

## Definition of Done

- [ ] Todos os criterios de aceite do `SPEC.md` satisfeitos.
- [ ] Testes/checks previstos passam.
- [ ] Nenhuma escrita fora do write scope.

## Stop conditions

- Spec/plano divergem ou incompletos → voltar para `/sdd:spec`.
- Necessidade de editar forbidden file ou sair do write scope.
- Risco novo de dados/security/permissao nao previsto.

## Nota para subagentes

[Contexto minimo comum; regra read-only; formato de retorno `Complete | Partial | Blocked`.]
