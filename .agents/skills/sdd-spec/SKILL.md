---
name: sdd-spec
description: >
  Planejamento spec-driven: cria ou atualiza um pacote versionado em
  `.specs/<slug>/` a partir de uma task do tracker (se houver), do branch atual,
  de um briefing solto ou de um follow-up. Use quando o usuario chamar
  `/sdd:spec`, pedir spec, execution plan, design doc tecnico, planejamento para
  subagentes, ou quando uma task precisar virar pacote auto-suficiente antes de
  implementar. Safe-by-default: pode ler tracker/context/codebase, mas nao muta
  tracker, branch, commit, push, PR ou estado externo.
license: MIT
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
model: opus
effort: high
---

# SDD Spec — Planejamento Seguro

Crie um pacote tecnico versionado e auto-suficiente para execucao da task. O
orquestrador pode gastar tokens lendo o tracker (se houver), `context/` e
codebase; subagentes recebem apenas o recorte compilado.

> ⚠️ **TRACKER E OPCIONAL.** Esta skill funciona com ou sem gerenciador de tasks
> (ClickUp/Jira/Linear/GitHub Issues). **Se o projeto nao tem tracker**, a unidade
> de trabalho e o branch/briefing — derive o slug dele e siga sem pedir task ID.
> **IA/agente: nao invente um tracker.**

## Principios

- O tracker e registro corporativo e input do orquestrador, nao fonte viva para
  todos os agentes.
- `.specs/<slug>/` e a fonte de verdade tecnica para execucao.
- `/sdd:execute` consome somente pacote aprovado; se o plano nao for
  auto-suficiente, o executor deve voltar para esta skill.
- Subagentes nao chamam o tracker, nao releem `context/` inteiro e nao inventam
  escopo.
- Incerteza vira gate humano, nao implementacao improvisada.
- Escopo e sagrado: se nao esta no pacote aprovado, nao entra no execute.
- Nao chame `TECHNICAL_DESIGN.md` de "TDD" — evita confusao com Test-Driven
  Development.

## Limites De Mutacao

Permitido:

- Ler task do tracker existente, se houver tracker.
- Ler branch/status apenas para inferir slug e (opcional) task ID.
- Ler `context/`, `CLAUDE.md`, skills canonicas e codebase conforme necessario.
- Criar/editar apenas arquivos dentro de `.specs/<slug>/`.

Proibido:

- Criar/editar task, comment, status ou timer em tracker.
- Criar/trocar/deletar branch.
- Commit, push, PR, merge, rebase.
- Rodar formatters no repo.
- Alterar codigo de produto, migrations, env ou config global.

Se o input contiver `--dry-run`, `teste seco`, `dry run`, `diagnostico` ou
`check`, nao edite arquivos; produza somente um relatorio/plano em chat.

## Slug e nomeacao do pacote

- `.specs/<slug>/` — `slug` em kebab-case derivado do branch (`feature/<slug>` ou
  `feature/<task-id>-<slug>`) ou de um titulo curto do briefing.
- **Com tracker:** prefixe o slug com o ID (`<task-id>-<slug>`) para rastrear de
  volta a task. **Sem tracker:** use apenas `<slug>`.
- A branch base (main/develop/outra) e definida pelo projeto, nao por esta skill.

## Modos De Entrada

1. `task id existente` *(so com tracker)*: ler a task uma vez e compilar o pacote
   local.
2. `branch atual`: inferir slug (e task ID, se houver) de `feature/<...>`; se
   ambiguo, pedir confirmacao.
3. `descricao solta`: gerar intake em chat; criar pacote com slug derivado do
   titulo. Com tracker, recomende registrar a task antes; sem tracker, siga.
4. `follow-up`: criar/atualizar spec vinculada a origem, citando-a.
5. `refresh`: reler fontes e atualizar pacote existente preservando decisoes
   aprovadas.
6. `dry-run`: diagnosticar o que seria criado/alterado sem escrever.

## Fluxo Obrigatorio

1. Intake
   - Identifique slug, branch, objetivo, status atual e (opcional) task ID.
   - Se vier do tracker, leia a task apenas no orquestrador.
   - Sem tracker, derive a unidade de trabalho do branch/briefing — nao bloqueie
     por falta de task ID.

2. Sizing
   - Classifique como quick, small, medium, large ou complex.
   - Use design/plano proporcional ao risco, nao cerimonia fixa.

3. Research
   - Obrigatorio para area governada, seguranca, dados/permissao/ownership, API,
     UX ambigua, risco de dados, refactor transversal ou complexidade
     large/complex.
   - Ordem de verificacao: codebase -> `context/`/ADRs -> docs oficiais/MCP se
     disponivel -> fonte oficial na web -> marcar incerteza.
   - Nao fabrique APIs, contratos ou comportamento.

4. Gray Areas
   - Liste decisoes ambigues como Human Gates.
   - Se uma decisao bloqueia arquitetura ou execucao, marque
     `Needs Human Decision` e nao aprove o plano.

5. SPEC
   - Crie/atualize `SPEC.md` com problema, escopo, fora de escopo, requisitos
     rastreaveis, aceite, decisoes, riscos, follow-ups e compiled context
     snapshot.

6. TECHNICAL_DESIGN condicional
   - Crie `TECHNICAL_DESIGN.md` quando os gatilhos abaixo casarem.
   - Documente alternativas, decisao escolhida, consequencias, rollback/mitigacao
     e impacto em testes.

7. EXECUTION_PLAN
   - Crie/atualize `EXECUTION_PLAN.md` depois de SPEC e design.
   - Inclua grafo de execucao, tarefas sequenciais, tarefas paralelizaveis, join
     gates, human gates, arquivos provaveis, arquivos proibidos, testes e stop
     conditions.
   - Declare write scope e forbidden files concretos o suficiente para
     `/sdd:execute` rejeitar qualquer escrita fora do pacote aprovado.

8. AGENT_TASKS condicional
   - Crie `AGENT_TASKS.md` apenas se houver paralelismo real, muitos subagentes
     ou necessidade de pacotes independentes.
   - Cada subtask deve ter contexto minimo, arquivos permitidos/proibidos,
     dependencies, done when, tests, gate e retorno esperado.

9. Approval State
   - Status possiveis: `Draft`, `Needs Human Decision`, `Approved for Execution`,
     `In Execution`, `Needs Integration Review`, `Ready for Close`.
   - Nunca marque `Approved for Execution` com Human Gate pendente.

## Gatilhos De TECHNICAL_DESIGN.md

Crie o design doc se qualquer item for verdadeiro:

- muda contrato entre camadas;
- toca DB, migration, politica de acesso (RLS/row-level/ACL), auth, storage ou
  security;
- envolve PII, permissao, ownership, compartilhamento ou dados sensiveis;
- pode causar perda/corrupcao de dados;
- muda API request/response ou schema persistido;
- refactor transversal ou >3 camadas;
- decisao candidata a ADR;
- exige rollback/migracao;
- existem duas ou mais solucoes tecnicas plausiveis com tradeoffs reais.

Nao crie para copy, CSS puro, bug localizado, chore simples ou ajuste mecanico
sem decisao.

## Contrato Dos Artefatos

> Skeletons copiaveis em [`.specs/_template/`](../../../.specs/_template/). Contrato
> completo em [`.specs/README.md`](../../../.specs/README.md).

### `SPEC.md`

Inclua: titulo (com task ID se houver e nome); status e data; link/ID do tracker
*(opcional)*, branch esperada e origem do input; resumo executivo; problema e
objetivo; escopo e fora de escopo; requisitos com IDs; criterios de aceite;
decisoes ja tomadas; gray areas e Human Gates; compiled context snapshot; riscos
e mitigacoes; follow-ups fora de escopo.

### `TECHNICAL_DESIGN.md`

Inclua: status; contexto tecnico; alternativas consideradas; decisao escolhida;
arquitetura/fluxo proposto; contratos de dados/API/state quando aplicavel;
seguranca, rollback e observabilidade quando aplicavel; impacto em testes;
consequencias e riscos residuais; perguntas em aberto.

Mantenha alto nivel. Nao coloque codigo de implementacao detalhado que pertenca
ao executor.

### `EXECUTION_PLAN.md`

Inclua: objetivo; pre-condicoes; Execution Graph com sequencial, paralelizavel,
join gates e human gates; ordem obrigatoria; write scope esperado; arquivos
proibidos; subtasks atomicas; model routing; plano de testes; definition of done;
stop conditions; nota para subagentes. Write scope e forbidden files concretos,
sem curingas amplos ou linguagem do tipo "as needed".

### `AGENT_TASKS.md` (opcional)

Para cada subagente: ID da subtask; objetivo; contexto minimo; arquivos
permitidos; arquivos proibidos; dependencies; done when; tests/gates; retorno
esperado: `Complete | Blocked | Partial`, files changed, gate result, deviations.

## Stop Conditions

Pare e peca decisao do orquestrador/user quando:

- task do tracker e SPEC divergem em escopo;
- Human Gate pendente bloqueia implementacao;
- pesquisa nao confirma um contrato essencial;
- solucao exige alterar area explicitamente fora de escopo;
- risco de dado, seguranca ou permissao nao tem mitigacao clara;
- executor precisaria chamar o tracker ou reler `context/` amplo para entender a
  tarefa.

## Roteamento De Modelo

Use o menor modelo que consiga preservar escopo, evidencias e decisoes sem
inventar arquitetura. Modelo caro nao e premio; e cinto de seguranca.

### Defaults

- Modelo default desta skill: `opus`. Effort default: `high`.
- Spec pequena, clara e sem area governada: pode reduzir o esforco mental para
  `medium`, mas nao reescreva o contrato.
- DB/politica de acesso/auth/storage/security, XSS, PII/permissao/share, perda de
  dados ou migracao: trate como `opus` + `xhigh`.
- Refactor transversal ou arquitetura ambigua sem risco de dados/security: `opus`
  + `high`, escalando para `xhigh` se houver Human Gate critico.

### Perfis Operacionais

| Perfil | Uso | Modelo recomendado |
|---|---|---|
| `clerical` | dry-run, diagnostico, normalizacao de markdown, checklist sem decisao | modelo leve + low |
| `operator` | tracker/branch/status sem arquitetura nova | modelo medio + medium |
| `planner` | SPEC/EXECUTION_PLAN small/medium, pesquisa localizada, consolidacao de contexto | modelo medio + medium/high |
| `architect` | gray areas, tradeoffs reais, DB/auth/storage/security, XSS, perda de dados, multi-camada | modelo forte + high; xhigh para dados/security |
| `auditor` | review independente, security/test/refactor audit, pre-PR de alto risco | modelo forte + high; medio + medium para review mecanica |

### Regras De Escalada

- DB/politica de acesso/auth/storage/security, XSS, risco de perda de dados ou
  PII/permissao/share: perfil `architect`, modelo forte + `xhigh`.
- Se o executor precisaria reler o tracker ou `context/` inteiro para entender a
  tarefa: a spec esta incompleta; volte para `/sdd:spec`.
- Divergencia entre tracker, SPEC e codebase: pare e peca decisao humana antes de
  gastar mais modelo.
- Trabalho mecanico, localizado e sem decisao nova: mantenha `clerical`/`operator`.
- Segunda opiniao rara e explicita: skill `codex-review`.

## Saida Ao Final

Informe: arquivos criados/atualizados; status do pacote; Human Gates pendentes;
se existe `TECHNICAL_DESIGN.md` e por que; se existe paralelismo e se
`AGENT_TASKS.md` foi necessario; proximos passos seguros (aprovar, revisar
decisoes, ou seguir para `/sdd:execute`).
