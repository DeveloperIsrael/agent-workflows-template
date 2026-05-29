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
- User confirma que a entrega esta pronta.

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
