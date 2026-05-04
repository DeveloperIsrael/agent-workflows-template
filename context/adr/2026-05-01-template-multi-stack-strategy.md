---
title: "Template Multi-Stack Strategy: Skills Lazy-Triggered, Hooks Opt-In, Rules Stack-Agnosticas"
date: 2026-05-01
status: accepted
supersedes: null
superseded_by: null
tags: [template, agents, skills, hooks, rules]
---

# Template Multi-Stack Strategy: Skills Lazy-Triggered, Hooks Opt-In, Rules Stack-Agnosticas

## Contexto

Este template e adotado em projetos com stacks heterogeneas — TypeScript + React, Next.js + Python (Flask/FastAPI), JavaScript puro, NestJS, Go, etc. Forcar uma stack especifica no template (via hooks ativos, rules com runner hardcoded, ou skills sempre-ativas) cria friccao em projetos que nao usam essa stack:

- Hook `tsc --noEmit` quebra em projeto Python
- Rule de testing que cita `Vitest` confunde quem usa `Pytest`
- Skill `playwright-best-practices` sempre carregada poluiria contexto em projeto sem frontend

Por outro lado, **nao oferecer nada** torna o template um esqueleto vazio que cada projeto reconstroi do zero — o oposto do objetivo (DRY, padrao reutilizavel).

A pergunta: como entregar **ferramentas concretas** sem amarrar a stack?

## Decisao

O template adota tres principios para artefatos especificos de stack:

1. **Skills lazy-triggered**: skills com afinidade de stack (TS, Python, React, Playwright) entram no template porque o frontmatter `description`/`triggers` faz com que o agente so as carregue quando a stack as invoca. Skill stack-especifica nao poluida em projeto que nao a usa.

2. **Hooks como `examples/` opt-in**: hooks de quality gate (Biome, tsc, ESLint, Ruff, MyPy) **nao vao ativos** em `.claude/settings.json`. Vivem em `.claude/hooks/examples/` com README explicando como copiar e ativar para a stack do projeto. Inclui variantes JS (Biome, ESLint+Prettier) e Python (Ruff, MyPy).

3. **Rules em principios, nao tooling**: `.agents/rules/03-testing.md` (anti-skip, 8 vulnerability classes, fixture deterministico) usa pseudo-codigo. Nao cita Vitest/Jest/Pytest/RSpec por nome. O leitor adapta a sintaxe ao runner da sua stack.

## Consequencias

### Positivas

- Template adotavel em projeto Python, TypeScript, JavaScript ou polyglot sem ajuste estrutural
- Skills uteis (TypeScript best practices, Playwright) ficam disponiveis sem custo em projetos que as ativam
- Hooks documentam **como fazer**, sem assumir stack — copia o exemplo, adapta o registro em `settings.json`, reinicia
- Rules permanecem relevantes na medida que tooling muda (Biome → Oxc → futuro X)

### Negativas

- Adocao por projeto exige passo manual: copiar exemplos de hook + registrar em `settings.json`. Onboarding tem 1 etapa extra
- Sem CI integrado por padrao no template — projetos precisam decidir o que ativar
- README.md de hooks fica verboso (instrucoes por stack)

### Neutras

- Skills lazy-triggered dependem da disciplina do `description` no frontmatter. Skills mal-descritas (sem trigger) violam o principio — exigem revisao no momento da promocao

## Alternativas Consideradas

### Alternativa A: Hooks ativos por padrao (com detect-stack)

Hook generico `quality-precommit.sh` que detecta `package.json` vs `pyproject.toml` e dispatcha para Biome ou Ruff. Mais codigo, mais frageis a edge cases (monorepo polyglot, projeto sem manifest), e o usuario nao sabe o que esta rodando. Descartado: complexidade > beneficio.

### Alternativa B: Variantes do template por stack (template-ts, template-python)

Repos separados por stack. Resolve o problema mas multiplica trabalho de manutencao — toda decisao estrutural precisa ser replicada em N repos. Descartado: explode complexidade no longo prazo.

### Alternativa C: So skills 100% genericas no template

Excluir TypeScript/Playwright/etc do template, deixar so skills que rodam em qualquer stack. Funciona mas perde valor: 50% das skills uteis ficam de fora. Descartado: lazy-triggering ja resolve o problema sem o custo.

## Referencias

- `[NOME_DO_PROJETO]/.claude/hooks/README.md` — convencao opt-in dos hooks
- `[NOME_DO_PROJETO]/.agents/skills/` — skills instaladas (lazy-triggered)
- `[NOME_DO_PROJETO]/.agents/rules/03-testing.md` — exemplo de rule stack-agnostica
