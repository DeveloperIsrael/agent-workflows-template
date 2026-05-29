---
name: task-start
description: >
  Orquestra o INICIO de uma task de codigo em fases: (1) sync/criar task no
  tracker [OPCIONAL], (2) criar branch, (3) marcar status in_progress [OPCIONAL],
  (4) analise profunda para tasks complexas. Carrega ao receber qualquer
  requisicao de codigo nova — "implementar", "criar", "nova task", "iniciar",
  "comecar", "build", "fix", "refactor", "feature", "bug", "adicionar",
  "corrigir". Roda ANTES de tocar qualquer arquivo de codigo. Apos init, consulte
  `workflow-governance` e `architecture-rules`.
license: MIT
allowed-tools: Bash, Skill
---

# Task Start — Inicio Orquestrado

Ritual de inicio de qualquer task de codigo. Rode **antes** de editar arquivos.

> ⚠️ **TRACKER E OPCIONAL.** As Fases 1 e 3 dependem de um gerenciador de tasks
> (ClickUp, Jira, Linear, GitHub Issues). **Se o projeto nao tem tracker**
> (nenhum MCP de issues, nada citado em `CLAUDE.md`/`context/`), **pule as Fases
> 1 e 3 sem ceremonia** — nao pergunte por task ID, nao bloqueie. A unidade de
> trabalho vira o branch (Fase 2). **IA/agente: nao invente um tracker.**

---

## Pre-check (gates)

Antes de orquestrar, verifique o que ja existe — se a task ja esta em andamento
(branch criado + status correto), pule direto pra implementacao:

- [ ] Existe task no tracker? *(so se houver tracker)*
- [ ] Branch da task ja criado e em uso?
- [ ] Status ja em `in_progress`? *(so se houver tracker)*

Se **todos** os gates aplicaveis estao YES (task retomada mid-session), o
workflow ja esta completo — **nao re-execute as fases**, prossiga direto para a
implementacao. Mesmo em retomada, cheque os gates antes de assumir.

---

## Fase 1 — Tracker: sync + criar/verificar task  *(OPCIONAL)*

> **Pule se o projeto nao usa tracker.**

1. Sincronize o estado do tracker (liste tasks abertas via o MCP/CLI do tracker).
2. Se a task ainda nao existe, crie-a **antes** de codar (Task First):
   - Titulo com prefixo de tipo se o projeto usa convencao (ex.: `[FEATURE]`, `[FIX]`).
   - Atribua o responsavel; defina datas se o tracker exigir.

---

## Fase 2 — Branch (+ timer opcional)

```bash
# A partir da base (main/develop, conforme o projeto)
git checkout -b feature/[TASK-ID]-[nome-kebab]
# sem tracker: git checkout -b feature/[nome-kebab-descritivo]
```

- Formato: `feature/...` ou `fix/...`. Um branch = uma unidade de trabalho.
- Se o tracker tem timer de tempo, inicie-o aqui *(opcional)*.

---

## Fase 3 — Status in_progress + nota inicial  *(OPCIONAL)*

> **Pule se o projeto nao usa tracker.**

1. Atualize o status da task para o equivalente a `in_progress` (ver tabela em
   `workflow-governance` §2 — use o slug real do seu tracker).
2. Poste um comentario inicial descrevendo o que sera feito.

---

## Fase 4 — Analise profunda (tasks complexas)

**Criterios de complexidade (pelo menos 1):**
- toca 3+ arquivos de camadas diferentes (estado + logica + UI/IO);
- envolve mudanca de contrato de API ou schema persistido;
- requer decisao arquitetural (candidato a ADR);
- estimativa alta (> ~2h de implementacao).

Se algum criterio casa, **planeje antes de codar**:

- Se houver um MCP de raciocinio (ex.: `sequential-thinking`), use-o para mapear
  arquivos impactados, dependencias e edge cases — nao substitua por "vou pensar
  passo a passo" inline; o MCP grava os passos de forma rastreavel.
- Sem MCP: faca um planejamento estruturado por escrito (tasks/TODO) antes de editar.

Para tasks simples (CSS, copy, chore, doc unico), pule esta fase e va direto para
a implementacao.

Apos planejar, consulte:
- `Skill(workflow-governance)` — golden rules, status, commits, PR.
- `Skill(architecture-rules)` — SoC/SRP, error handling, limites de tamanho.

### Quando virar spec-driven (`/sdd:spec`)

Se a task for **arriscada, ambigua, multi-arquivo ou arquitetural** — ou casar
com os gatilhos de `TECHNICAL_DESIGN.md` (DB/auth/storage/security, migracao,
risco de dados, refactor transversal, 2+ alternativas) — nao improvise: rode
`/sdd:spec` para gerar um pacote `.specs/<slug>/` antes de implementar. O
fechamento correspondente passa por `/sdd:review` antes de `/sdd:close`.

---

## Regra dura

Esta skill **orquestra** — invoque as sub-skills via `Skill` tool, nao as
substitua por raciocinio inline. Se pular uma fase, justifique (ex.: "sem tracker,
Fases 1 e 3 N/A"). Fechamento da task: skill `task-flow`.

---

## Verification Checklist (pos-inicio, pre-codigo)

Para cada item, responda explicitamente "sim, fiz" ou "nao, pulei e o motivo e X":

- [ ] **Fase 1 (se houver tracker):** sincronizei o tracker e confirmei/criei a task.
- [ ] **Fase 2:** criei o branch da unidade de trabalho e estou nele.
- [ ] **Fase 3 (se houver tracker):** status em `in_progress` + nota inicial.
- [ ] **Fase 4 (condicional):** se a task e complexa, planejei antes de codar (MCP de raciocinio ou plano escrito); avaliei se deve virar `/sdd:spec`.
- [ ] Consultei `architecture-rules` e `workflow-governance` apos o init.

> **Hard rule:** "nao, pulei" exige motivo tecnico explicito (ex.: "Fases 1 e 3
> N/A — projeto sem tracker"; "Fase 4 pulada — mudanca de 3 linhas em CSS").
> "Achei desnecessario" nao vale.
