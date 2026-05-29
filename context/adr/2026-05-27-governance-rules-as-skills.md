---
title: "Governanca e Regras como Skills Lazy-Triggered (substitui pastas .agents/governance + .agents/rules)"
date: 2026-05-27
status: accepted
supersedes: null
superseded_by: null
tags: [template, agents, skills, governance, rules]
---

# Governanca e Regras como Skills Lazy-Triggered

## Contexto

Ate aqui o template guardava governanca e regras como **pastas de doc sempre-lidas**:
`.agents/governance/workflow.md` + `.agents/rules/{README,01-architecture,02-pdi,03-testing,04-pre-pr-checks}.md`.
A "Leitura Obrigatoria" do `CLAUDE.md` mandava o agente ler tudo no inicio de toda task,
gastando contexto mesmo quando a task nao tocava aquele dominio (ex.: ler a rule de testing
numa mudanca de copy).

O projeto-laboratorio que alimenta este template (onde os padroes amadurecem antes de
voltar pra ca) ja tinha evoluido: as pastas viraram **skills lazy-triggered**, carregadas
sob demanda pelo gatilho do `description` no frontmatter. O ADR `2026-05-01-template-multi-stack-strategy`
ja estabelecia skills lazy-triggered como mecanismo de primeira classe — faltava aplicar o
mesmo principio a governanca e regras.

## Decisao

Migramos governanca e regras de pastas de doc para **skills** em `.agents/skills/`,
removendo `.agents/governance/` e `.agents/rules/`. Sao criadas 7 skills genericas e
stack-agnosticas:

- `workflow-governance` — golden rules, status, Conventional Commits, protocolo de PR
- `task-start` — ritual de inicio (tracker opcional → branch → analise)
- `task-flow` — ritual de fechamento (commit → docs → checks → tracker opcional)
- `architecture-rules` — SoC/SRP, estado, erros, performance, tamanho, anti-patterns
- `testing-discipline` — anti-skip + 8 classes de vulnerabilidade
- `pre-pr-checks` — lint/type-check/test/build antes do PR
- `codex-review` — segunda opiniao externa em DB/security/refactor grande

Dois principios de design acompanham a decisao:

1. **Tracker/task e OPCIONAL.** Nem todo projeto que adota o template usa gerenciador de
   tasks (ClickUp/Jira/Linear/GitHub Issues). `workflow-governance`, `task-start` e
   `task-flow` marcam explicitamente os passos de tracker como condicionais e instruem a
   IA/agente a **nao inventar tracker nem bloquear** quando nao houver — a unidade de
   trabalho vira o branch + PR.
2. **Claude-first no carregamento.** Skills auto-carregam no Claude pelo frontmatter. Os
   demais providers (Cursor/Gemini/Codex/OpenCode/Copilot) nao varrem skills — leem o
   `CLAUDE.md`/`AGENTS.md`, que cita as skills e linka os `SKILL.md` (markdown legivel).
   O conteudo continua acessivel a qualquer agente; o auto-trigger e bonus do Claude.

A regra `02-pdi.md` (mentoria/PDI) e **descontinuada** — nao vira skill no template.

## Consequencias

### Positivas
- Contexto sob demanda: o agente carrega a regra de testing so ao tocar testes, etc.
- Coerencia com o ADR multi-stack: governanca/regras seguem o mesmo modelo lazy das skills de stack.
- Orquestracao explicita: `task-start`/`task-flow` codificam o ritual de inicio/fechamento e invocam sub-skills via `Skill` tool.
- SSoT unico: `.agents/skills/` concentra governanca + regras + stack, exposto via symlink.

### Negativas
- **Breaking change** pra repos ja clonados do template: caminhos `.agents/rules/*` e `.agents/governance/*` deixam de existir; refs precisam migrar pras skills (bump 2.1.0 → 3.0.0).
- Providers nao-Claude dependem do `CLAUDE.md` citar as skills explicitamente — se o entry point nao linkar, a regra "some" pra eles.
- PDI sai do template; projetos que querem mentoria estruturada precisam reintroduzi-la.

### Neutras
- Skills de governanca dependem da disciplina do `description` (gatilhos). Skill mal-descrita nao dispara — exige revisao na promocao (mesmo trade-off ja aceito no ADR multi-stack).

## Alternativas Consideradas

### Alternativa A: Manter as pastas e adicionar skills por cima
Duplicaria conteudo (pasta + skill) e criaria ambiguidade de fonte de verdade. Descartado.

### Alternativa B: Stubs de redirect nas pastas antigas
Arquivos finos `.agents/rules/*` apontando pra skill. Reduz atrito de migracao, mas deixa
lixo permanente e contradiz o "remover de vez". Descartado em favor do corte limpo + este ADR.

### Alternativa C: Adapters por provider (gerar `.cursor/rules/*.mdc` das skills)
Multi-provider real, porem custo de manutencao alto (gerador + sync). Descartado por ora a
favor de Claude-first; pode ser revisitado num ADR futuro se a demanda multi-provider crescer.

## Referencias

- ADR relacionado: [`2026-05-01-template-multi-stack-strategy.md`](./2026-05-01-template-multi-stack-strategy.md) — skills lazy-triggered como mecanismo
- Skills criadas: `.agents/skills/{workflow-governance,task-start,task-flow,architecture-rules,testing-discipline,pre-pr-checks,codex-review}/SKILL.md`
- Entry point: [`../../CLAUDE.md`](../../CLAUDE.md) — Leitura Obrigatoria + Skills Disponiveis
