---
name: task-flow
description: >
  Orquestra o FECHAMENTO de uma task em fases via Skill tool: (1) `Skill(git-commit)`,
  (2) `Skill(update-docs)`, (3) `Skill(pre-pr-checks)` + `Skill(codex-review)` se
  gatilhos casam, (4) status do tracker -> in_review [OPCIONAL], (5) comentario-
  resumo [OPCIONAL]. Carrega ao finalizar qualquer fix/feature/refactor — "close
  task", "fechar task", "finish", "wrap up", "terminei", "implementei", "codigo
  pronto", "pronto para review", "acabei". NAO substitui as sub-skills — ORQUESTRA.
license: MIT
allowed-tools: Bash, Skill
---

# Task Flow — Fechamento Orquestrado

Ritual de fechamento de qualquer task. Esta skill **invoca outras skills** via
`Skill` tool — nao refaca o trabalho delas inline.

> ⚠️ **TRACKER E OPCIONAL.** As Fases 4 e 5 dependem de um gerenciador de tasks.
> **Se o projeto nao tem tracker, pule-as** — o fechamento termina no PR (Fase 1-3).
> **IA/agente: nao invente status nem comentario de task onde nao ha tracker.**

---

## Pre-condicoes

- Codigo testado (TDD/repro), nao so escrito.
- Task existe no tracker *(se houver tracker — senao, basta o branch)*.
- Se a task passou por `/sdd:spec` ou `/sdd:execute`, `/sdd:review` retornou
  `PASS` ou o user aceitou pular review explicitamente.
- User confirma que a entrega esta pronta.

Se faltar qualquer um, pare e resolva antes — nao comece o fechamento.

---

## Fase 1 — Commit

```
Skill(skill: "git-commit")
```

- Nao faca `git add`/`git commit -m` manual — a skill detecta escopo, gera
  mensagem Conventional Commits e valida arquivos sensiveis.
- Mostre a lista final de arquivos ao user antes de commitar.

---

## Fase 2 — Sincronizar docs

```
Skill(skill: "update-docs")
```

- Nao faca grep/Read ad-hoc — a skill descobre os docs canonicos (le o perfil em
  [`.agents/update-docs.profile.yaml`](../../update-docs.profile.yaml) se existir)
  e pergunta antes de criar novos.

---

## Fase 3 — Checks pre-PR + segunda opiniao

```
Skill(skill: "pre-pr-checks")
```

- Roda lint / type-check / test / build. Falhou? Pare, corrija, re-rode. Nao abra PR vermelho.

Quando os gatilhos casarem (mudanca de DB/migrations, testes/cobertura incerta,
fix security-critical, refactor grande), invoque tambem:

```
Skill(skill: "codex-review")
```

---

## Fase 4 — Status do tracker -> in_review  *(OPCIONAL)*

> **Pule se o projeto nao usa tracker.**

Atualize o status para o equivalente a `in_review` (ver `workflow-governance` §2).
Nao marque como `done`/`finalizado` sem confirmacao — `in_review` = aguardando QA/review.

---

## Fase 5 — Comentario-resumo  *(OPCIONAL)*

> **Pule se o projeto nao usa tracker.** Sem tracker, este resumo vai no **PR body**.

Poste um resumo tecnico com:
- **Entrega**: arquivos alterados (arquivo — o que mudou) + commits (sha — subject).
- **Docs**: o que foi atualizado.
- **Como testar**: passos numerados + resultado esperado.
- **Notas**: edge cases / follow-ups, ou "nenhum".

---

## Regra dura

Fases 1-3 invocam **sub-skills** via `Skill` tool (nao chame as ferramentas
internas delas direto). Se pular uma fase, justifique (ex.: "sem tracker, Fases 4-5
viram resumo no PR"). Inicio da task: skill `task-start`.

---

## Anti-patterns

| ❌ | ✅ |
|---|---|
| Parafrasear "delego para a skill X" e fazer manual | Chamar literalmente `Skill(skill: "X")` — esta skill ORQUESTRA, nao substitui as filhas |
| `grep`/`find`/`Read` ad-hoc na Fase 2 "pra ver se docs mudaram" | Invocar `Skill(skill: "update-docs")` — confiar no discovery+profile |
| `git add -A` / commit dump-everything | Invocar `Skill(skill: "git-commit")` — lista os arquivos da task, mostra ao user, commita so esses |
| Pular checks pre-PR "pra ir mais rapido" | Invocar `Skill(skill: "pre-pr-checks")` e nao abrir PR vermelho |
| Status `done`/`finalizado` sem QA aprovar | `in_review` no fechamento agent-side |
| Fechar task spec-driven sem review | Rodar `/sdd:review` (→ `PASS`) antes de `/sdd:close`, salvo skip explicito |

---

## Verification Checklist (final)

Para cada item, responda explicitamente "sim, invoquei" ou "nao, pulei e o motivo e X":

- [ ] **Fase 1:** `Skill(skill: "git-commit")` (nao fiz `git commit -m` ad-hoc).
- [ ] **Fase 2:** `Skill(skill: "update-docs")` (nao fiz `grep`/`Read` manual em substituicao).
- [ ] **Fase 3:** `Skill(skill: "pre-pr-checks")`; + `Skill(skill: "codex-review")` se os gatilhos casaram.
- [ ] **Pre-close (condicional):** se houve `/sdd:spec` ou `/sdd:execute`, `/sdd:review` retornou `PASS` ou user aceitou skip.
- [ ] **Fases 4-5 (se houver tracker):** status `in_review` + comentario-resumo; sem tracker, resumo no PR body.

> **Hard rule:** "nao, pulei" exige motivo tecnico explicito (ex.: "Fase 2 N/A —
> nenhum doc canonico afetado, confirmado pelo `update-docs`"). "Achei
> desnecessario" nao vale — invoque a sub-skill.
