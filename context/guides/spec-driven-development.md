# Spec-Driven Development (SDD)

O SDD e o workflow de planejamento, execucao e review do template. A ideia: para
trabalho com risco ou ambiguidade, **escreva um pacote tecnico antes de codar** e
deixe a execucao consumir esse pacote, sem reabrir decisao no meio.

> **Tracker-opcional.** Todo o fluxo funciona com ou sem gerenciador de tasks. Os
> passos de tracker so valem se o projeto usa um (ClickUp/Jira/Linear/GitHub
> Issues). Sem tracker, a unidade de trabalho e o branch.

## Linha de producao

```
/sdd:doctor  →  /sdd:start  →  /sdd:spec  →  /sdd:execute  →  /sdd:review  →  /sdd:close
 (diagnostico)   (branch +     (cria pacote   (executa o      (valida vs      (commit, docs,
                  tracker?)     .specs/<slug>)  plano aprovado)  o pacote)       checks, tracker?)
```

| Comando | Skill | Faz |
|---|---|---|
| `/sdd:doctor` | (inline) | Diagnostico read-only do wiring (branch, skills, hooks path, tracker). Nunca muta. |
| `/sdd:start` | `task-start` | Ritual de inicio: cria branch; sync/cria task + timer **se houver tracker**. |
| `/sdd:spec` | `sdd-spec` | Cria/atualiza o pacote `.specs/<slug>/`. So escreve dentro do pacote. |
| `/sdd:execute` | `sdd-execute` | Executa pacote `Approved for Execution`, respeitando write scope/forbidden files. |
| `/sdd:review` | `sdd-review` | Revisao read-only contra o pacote/diff/PR. Retorna `PASS`/`FIX`/`SPEC GAP`. |
| `/sdd:close` | `task-flow` | Commit → docs → checks → tracker (opcional). |

## Quando usar cada caminho

- **Fluxo rapido (sem spec):** mudanca pequena, localizada, sem decisao nova (CSS,
  copy, chore, bug de 1 arquivo). `/sdd:start` → implementa → `/sdd:close`.
- **Spec-driven (`/sdd:spec`):** task arriscada, ambigua, multi-arquivo ou
  arquitetural; ou qualquer gatilho de `TECHNICAL_DESIGN.md` (DB/auth/storage/
  security, migracao, risco de dados, refactor transversal, 2+ alternativas).
- **Spike/auditoria:** quando o objetivo e investigar, nao entregar codigo — gere
  o pacote com o relatorio como output (`SPEC.md` + output gerado), sem
  `EXECUTION_PLAN` de codigo.

## O pacote `.specs/<slug>/`

Fonte de verdade tecnica e auto-suficiente da unidade de trabalho. Contrato
completo e skeletons copiaveis em [`.specs/README.md`](../../.specs/README.md) e
[`.specs/_template/`](../../.specs/_template/).

- `SPEC.md` *(sempre)* — problema, escopo, requisitos rastreaveis, aceite,
  decisoes, gray areas, riscos.
- `EXECUTION_PLAN.md` *(sempre)* — grafo de execucao, **write scope** e
  **forbidden files** concretos, testes, DoD, stop conditions.
- `TECHNICAL_DESIGN.md` *(condicional)* — quando ha decisao arquitetural ou risco.
- `AGENT_TASKS.md` *(condicional)* — so com paralelismo real + join gate.

## Approval states

`Draft` → `Needs Human Decision` → `Approved for Execution` → `In Execution` →
`Needs Integration Review` → `Ready for Close`.

`/sdd:execute` so roda pacote `Approved for Execution`. Nunca se aprova um pacote
com Human Gate pendente.

## Safe-by-default

- Cada comando declara seus limites de mutacao. `spec` so escreve em
  `.specs/<slug>/`; `execute` so escreve no write scope aprovado; `review` e
  `doctor` sao read-only.
- Write scope e forbidden files sao **concretos** — sem `src/**`, `.`, `as
  needed`. O executor rejeita escrita fora do escopo.
- Incerteza vira Human Gate, nao implementacao improvisada.
- Subagentes recebem contexto minimo e nao releem `context/` inteiro.

## `--dry-run`

`spec`, `execute` e `review` aceitam `--dry-run` (ou `teste seco`, `diagnostico`,
`check`): rodam descoberta/preflight e produzem um relatorio de prontidao **sem
escrever nada nem disparar subagentes**. Para checagem de wiring, use
`/sdd:doctor`.

## Comandos sao finos

Os arquivos em `.claude/commands/sdd/` sao apenas pontos de entrada — a semantica
vive nas skills (`.agents/skills/sdd-*`, `task-start`, `task-flow`). **Para mudar
comportamento, edite a skill**, nao o comando; a mudanca propaga para todos os
providers. Decisao registrada no ADR
[`2026-05-28-adopt-sdd-remove-gsd.md`](../adr/2026-05-28-adopt-sdd-remove-gsd.md).
