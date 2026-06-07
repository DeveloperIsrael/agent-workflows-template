---
title: "Adotar Spec-Driven Development (/sdd:*) e remover o framework GSD"
date: 2026-05-28
status: accepted
supersedes: null
superseded_by: null
tags: [workflow, agents, sdd, planning]
---

# Adotar Spec-Driven Development (/sdd:*) e remover o framework GSD

## Contexto

O template embarcava o framework **GSD** ("Get Shit Done"): ~32 comandos
`/gsd:*`, 12 subagents, 3 hooks ativos por padrao (`SessionStart`, `PostToolUse`,
statusline) e uma arvore `.claude/get-shit-done/`. O GSD modela planejamento por
**milestone → phase → todo**, com estado proprio e hooks sempre ligados.

Em paralelo, amadureceu um workflow **Spec-Driven Development (SDD)**: um pacote
tecnico versionado em `.specs/<slug>/` (`SPEC.md`, `TECHNICAL_DESIGN.md`
condicional, `EXECUTION_PLAN.md`, `AGENT_TASKS.md` condicional) conduzido por um
pipeline read-mostly e safe-by-default — `spec → execute → review → close`, sobre
os orquestradores `task-start`/`task-flow` (tracker-opcional).

Os dois modelos coexistindo geram atrito:

- **Duplicacao de planejamento** — milestone/phase do GSD vs `.specs/<slug>/` do
  SDD resolvem o mesmo problema de formas incompativeis.
- **Acoplamento** — o GSD liga hooks por padrao e assume um modelo de projeto
  proprio, contra a estrategia multi-stack (ADR
  [`2026-05-01-template-multi-stack-strategy.md`](./2026-05-01-template-multi-stack-strategy.md))
  e a abordagem "governanca como skill" (ADR
  [`2026-05-27-governance-rules-as-skills.md`](./2026-05-27-governance-rules-as-skills.md)).
- **Ambiguidade para o agente** — dois conjuntos de comandos para "planejar e
  executar" tornam a escolha nao-obvia.

## Decisao

Adotamos o **Spec-Driven Development como unico workflow de planejamento,
execucao e review** do template, e **removemos o framework GSD**.

Concretamente:

- Skills `sdd-spec`, `sdd-execute`, `sdd-review` em `.agents/skills/`.
- Comandos finos `/sdd:{spec,execute,review,close,start,doctor}` em
  `.claude/commands/sdd/` — `start` delega a `task-start`, `close` delega a
  `task-flow`.
- Contrato `.specs/` documentado, com `_template/` copiavel.
- Removidos: `.claude/get-shit-done/`, `.claude/commands/gsd/`, `.claude/agents/`
  (so continha agents GSD), os 3 hooks `gsd-*.js`, manifest e `package.json`
  orfaos; `settings.json` deixou de registrar `hooks`/`statusLine` (sem hook ativo
  por padrao — apenas exemplos opt-in em `.claude/hooks/examples/`).

O fluxo e tracker-opcional e stack-agnostico: comandos sao finos (a semantica vive
nas skills), e nada nomeia uma toolchain especifica.

## Consequencias

### Positivas
- Um unico modelo de planejamento coerente com governanca-como-skill.
- Tracker-opcional e stack-agnostico de ponta a ponta.
- Sem hook ativo por padrao — projetos ligam so o que casa com a stack.
- Pacotes `.specs/` dao auditoria, write scope concreto e delegacao segura a
  subagentes.

### Negativas
- Projetos que dependiam do tooling de milestone/phase do GSD perdem esse recurso.
- Adotantes precisam preencher os `[COMANDO_*]` (lint/test/build) via
  `pre-pr-checks` para os checks rodarem.

### Neutras
- `settings.json` passa a conter apenas `permissions` + `env`; quem quiser hooks
  ativa os exemplos opt-in.

## Alternativas Consideradas

### Alternativa A: Manter GSD e SDD lado a lado
Dois caminhos de planejamento sobrepostos — escolha nao-obvia, manutencao dupla,
risco de drift. Descartada.

### Alternativa B: Manter so o GSD
Mantem hooks ativos e modelo de projeto proprio, contra a estrategia multi-stack e
governanca-como-skill. Descartada.

## Referencias

- ADR [`2026-05-01-template-multi-stack-strategy.md`](./2026-05-01-template-multi-stack-strategy.md)
- ADR [`2026-05-27-governance-rules-as-skills.md`](./2026-05-27-governance-rules-as-skills.md)
- Guia [`context/guides/spec-driven-development.md`](../guides/spec-driven-development.md)
- Contrato [`.specs/README.md`](../../.specs/README.md)
