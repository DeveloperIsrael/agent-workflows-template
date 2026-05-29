# `.specs/` — Pacotes Spec-Driven

`.specs/<slug>/` e a **fonte de verdade tecnica** de uma unidade de trabalho no
workflow Spec-Driven Development (SDD). Cada pacote e auto-suficiente: o
executor e os subagentes trabalham a partir dele, sem reler o tracker nem
`context/` inteiro.

Guia completo do fluxo: [`context/guides/spec-driven-development.md`](../context/guides/spec-driven-development.md).

## Como nomear o pacote

- `slug` em kebab-case, derivado do branch (`feature/<slug>` ou
  `feature/<task-id>-<slug>`) ou de um titulo curto.
- **Com tracker** (ClickUp/Jira/Linear/GitHub Issues): prefixe com o ID —
  `.specs/<task-id>-<slug>/`.
- **Sem tracker**: use apenas `.specs/<slug>/`. O tracker e opcional.

## Arquivos do pacote

| Arquivo | Quando | Papel |
|---|---|---|
| `SPEC.md` | **Sempre** | Problema, escopo, requisitos rastreaveis, aceite, decisoes, riscos. |
| `EXECUTION_PLAN.md` | **Sempre** | Grafo de execucao, **write scope**, **forbidden files**, testes, DoD, stop conditions. |
| `TECHNICAL_DESIGN.md` | Condicional | Decisao arquitetural, DB/auth/storage/security, migracao, risco de dados, refactor transversal, 2+ alternativas. |
| `AGENT_TASKS.md` | Condicional | So quando ha paralelismo real com subagentes independentes + join gate. |
| Outputs gerados | Conforme a task | Ex.: `AUDIT_REPORT.md`, resultados materializados pela execucao. |

Copie [`_template/`](./_template/) para iniciar um pacote novo.

## Lifecycle (approval state em `SPEC.md`)

`Draft` → `Needs Human Decision` → `Approved for Execution` → `In Execution` →
`Needs Integration Review` → `Ready for Close`.

- `/sdd:spec` cria/atualiza o pacote e define o status.
- `/sdd:execute` **so roda** pacote com status `Approved for Execution`, write
  scope concreto e secao de forbidden files. Nunca aprova com Human Gate pendente.
- `/sdd:review` valida a execucao contra o pacote antes de `/sdd:close`.

## Contrato safe-by-default

- O write scope e os forbidden files sao concretos — sem curingas amplos
  (`src/**`, `.`, `as needed`). O executor rejeita qualquer escrita fora do escopo
  aprovado.
- Incerteza vira Human Gate, nao implementacao improvisada.
- Subagentes recebem contexto minimo e sao read-only por padrao.

## Versionamento

O `_template/` e commitado. Se pacotes de tasks concretas devem ser versionados
ou ignorados (`.gitignore`) fica a criterio do projeto que adota o template —
versionar da rastreabilidade; ignorar mantem o repo enxuto.
