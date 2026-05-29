# Agent Tasks — [TASK-ID | —] [Nome curto]

> **Opcional.** Crie este arquivo apenas quando houver **paralelismo real**:
> recortes independentes, varios subagentes, join gate claro. Para trabalho
> sequencial, deixe o `EXECUTION_PLAN.md` conduzir e delete este arquivo.

Paralelismo: [N] subagentes independentes ([A1]-[An]) com recortes sem
sobreposicao, seguidos de [1] validador/integrador ([V]).

## Regras globais (todos os subagentes)

- READ-ONLY por padrao. So o integrador/validador escreve, e apenas no write
  scope do `EXECUTION_PLAN.md`.
- Nao chamar o tracker; nao mutar timer/branch/commit/PR.
- Nao reler `context/` inteiro — ler apenas os paths do proprio recorte.
- Evidencia: `path:line` sempre que possivel.
- Retorno estruturado: `Complete | Blocked | Partial`, achados (com evidencia),
  areas sem evidencia, deviations.

---

## A1 — [titulo do recorte]

- **Objetivo:** [o que esta subtask resolve]
- **Contexto minimo:** [so o necessario — invariantes, contratos]
- **Arquivos permitidos:** [paths que pode ler/escrever]
- **Arquivos proibidos:** [paths fora do recorte]
- **Dependencies:** [nenhuma | A2, …]
- **Done when:** [condicao verificavel]
- **Tests/gates:** [check da subtask]
- **Retorno esperado:** `Complete | Blocked | Partial` + files changed + gate result + deviations

## A2 — [titulo do recorte]

- **Objetivo:** …
- **Dependencies:** nenhuma (paralelo a A1)
- [demais campos como acima]

---

## V — Integrador / validador

- **Objetivo:** consolidar A1-An, resolver conflitos, validar contra `SPEC.md`/DoD.
- **Join gate:** so inicia apos TODOS os retornos exigidos de A1-An.
- **Arquivos permitidos:** write scope do `EXECUTION_PLAN.md`.
- **Done when:** DoD atingido; deviations documentadas.
- **Retorno esperado:** resumo de integracao + recomendacao (`/sdd:review` ou voltar a `/sdd:spec`).
