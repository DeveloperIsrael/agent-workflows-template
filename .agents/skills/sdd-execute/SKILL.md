---
name: sdd-execute
description: >
  Execucao segura de um pacote aprovado em `.specs/<slug>/`. Use quando o usuario
  chamar `/sdd:execute` ou pedir para executar uma spec ja aprovada.
  Safe-by-default: valida o pacote, respeita write scope e stop conditions,
  orquestra subagentes apenas quando `AGENT_TASKS.md` existir, e nunca muta
  tracker, timer, branch, commit, push ou PR.
license: MIT
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, Task
model: sonnet
effort: high
---

# SDD Execute — Execucao De Plano Aprovado

Execute um pacote tecnico ja aprovado sem reabrir planejamento. Esta skill e a
ponte entre `/sdd:spec` e `/sdd:review`: implementa o plano aprovado, respeita
limites de escrita, coordena subagentes quando existir paralelismo real e para
quando descobrir que a spec ainda nao e executavel.

## Principios

- Execute nao e planner. Se faltar decisao, contexto, arquitetura ou escopo,
  pare e volte para `/sdd:spec`.
- Execute uma unidade atomica por vez. Cada unidade precisa ser verificavel de
  forma independente antes de seguir.
- `.specs/<slug>/SPEC.md` e a fonte de verdade tecnica.
- `EXECUTION_PLAN.md` define ordem, write scope, forbidden files, gates, testes,
  DoD e stop conditions.
- `AGENT_TASKS.md` e opcional e so habilita subagentes quando houver recortes
  independentes e join gate claro.
- Subagentes recebem contexto minimo. Eles nao chamam o tracker e nao releem
  `context/` inteiro.
- Nenhuma mutacao pode sair do write scope aprovado.

## Limites De Mutacao

Permitido:

- Ler `SPEC.md`, `EXECUTION_PLAN.md` e, se existir, `AGENT_TASKS.md`.
- Ler arquivos do repo necessarios para executar as tarefas aprovadas.
- Escrever somente em paths cobertos pelo write scope do `EXECUTION_PLAN.md`.
- Rodar testes/checks escopados previstos no plano.

Proibido:

- Criar, editar, comentar, mover status ou chamar tracker durante a execucao.
- Criar, trocar, deletar ou sincronizar branch.
- Commit, push, PR, merge, rebase ou deploy.
- Editar arquivos fora do write scope ou dentro de forbidden files.
- Rodar formatters/checks globais que possam sujar arquivos fora do escopo.
- Ler `.env` ou secrets.
- Transformar lacuna de planejamento em decisao improvisada.

Se o input contiver `--dry-run`, `teste seco`, `dry run`, `diagnostico` ou
`check`, nao edite arquivos, nao dispare subagentes e nao rode comandos
mutantes. Produza somente diagnostico de prontidao.

## Modos De Entrada

1. `path da spec`: aceite `.specs/<slug>` ou `.specs/<slug>/`.
2. `task id` *(so com tracker)*: resolva para `.specs/<task-id>-*`; se houver zero
   ou mais de um match, pare e peca decisao humana.
3. `branch atual`: se nao houver argumento alvo, leia `git branch --show-current`
   e infira o slug. Use a inferencia somente se encontrar um unico pacote
   correspondente.
4. `--dry-run`: aplique todos os checks de descoberta e pre-condicao, mas nao
   execute tarefas nem escreva.

Nunca crie pacote novo. Se nao existe pacote aprovado, o proximo passo e
`/sdd:spec`.

## Preflight Obrigatorio

Antes de qualquer escrita:

1. Resolver o pacote alvo de forma unica.
2. Ler `SPEC.md` e `EXECUTION_PLAN.md`; ambos sao obrigatorios.
3. Verificar que o status do pacote contem exatamente `Approved for Execution`.
4. Confirmar que nao ha Human Gate pendente. Qualquer `Needs Human Decision`,
   `Pending`, `TBD`, pergunta bloqueante ou gate sem decisao = stop.
5. Extrair write scope do `EXECUTION_PLAN.md`.
6. Rejeitar write scope ambiguo, amplo demais ou aberto — por exemplo: repo root,
   `.`, globs sem recorte (`src/**`, `context/**` sem arquivos especificos),
   `etc.`, `as needed`, `TBD`, ou linguagem equivalente.
7. Extrair forbidden files. Se nao houver secao de forbidden files, pare.
8. Confirmar que stop conditions estao declaradas.
9. Se `AGENT_TASKS.md` existir, confirmar que ha join gate claro antes de
   validador/integrador e que cada subtask declara allowed files, forbidden
   files, dependencies, done when, tests/gates e retorno esperado.
10. Fazer um snapshot inicial de `git status --short --branch` para detectar
    arquivos ja alterados. Preserve mudancas existentes; nao reverta nada.

Em `--dry-run`, termine aqui com relatorio de readiness.

## Execucao Com `AGENT_TASKS.md`

Use subagentes apenas quando o pacote declarar paralelismo real.

Fluxo:

1. Divida as subtasks pelos blocos de `AGENT_TASKS.md`.
2. Para cada subagente, envie somente: objetivo da subtask; trechos relevantes de
   `SPEC.md`; bloco da propria subtask em `AGENT_TASKS.md`; write scope global;
   forbidden files globais e locais; stop conditions; formato de retorno esperado.
3. Oriente cada subagente a nao chamar o tracker, nao abrir `context/` inteiro,
   nao editar fora do recorte e retornar `Complete | Partial | Blocked`.
4. Dispare apenas subtasks independentes em paralelo.
5. Aplique join gate: todos os retornos exigidos precisam chegar antes de
   integrador/validador.
6. Se qualquer subagente retornar `Blocked` por lacuna de spec, escopo,
   arquitetura, forbidden file ou divergencia entre SPEC/codebase, pare e reporte
   que o pacote precisa voltar para `/sdd:spec`.
7. Rode validador/integrador somente depois do join gate. Use modelo forte quando
   houver risco, join complexo, seguranca, dados, API ou conflito entre achados.

Subagentes mecanicos/localizados podem usar modelo medio. Validador/auditor usa
modelo forte quando houver join ou risco.

## Execucao Sem `AGENT_TASKS.md`

Execute o `EXECUTION_PLAN.md` sequencialmente, com checkpoints:

0. Se o plano nao listar tarefas atomicas, liste os passos atomicos em chat antes
   de escrever. Cada passo deve ter deliverable, arquivos e verificacao. Se a
   lista revelar mais de 5 passos ou dependencias complexas, pare e volte para
   `/sdd:spec`; o pacote foi aprovado com granularidade insuficiente.
1. Antes de cada task, declare: assumptions (o que assume e qualquer incerteza);
   files to touch (somente arquivos que a task exige); success criteria (como
   sera verificada).
2. Compare cada escrita planejada com write scope e forbidden files.
3. Execute a menor mudanca necessaria.
4. Rode o teste/check escopado declarado para a task quando aplicavel.
5. Confirme que testes nao foram deletados, enfraquecidos ou pulados para passar.
6. Registre deviations ou bloqueios antes de seguir.

Se a ordem do plano estiver ambigua, pare. Execute nao reorganiza arquitetura,
nao cria subtasks novas e nao expande escopo.

## Stop Conditions Fortes

Pare e peca decisao humana quando qualquer item ocorrer:

- `SPEC.md` ou `EXECUTION_PLAN.md` ausente.
- Status diferente de `Approved for Execution`.
- Human Gate pendente ou decisao arquitetural nova necessaria.
- Write scope ausente, ambiguo, amplo demais ou contraditorio.
- Necessidade de editar forbidden file.
- Necessidade de sair do write scope aprovado.
- Divergencia entre referencias do tracker ja registradas no pacote, SPEC e
  codebase que mude escopo ou aceite.
- Executor precisaria reler o tracker ou `context/` inteiro para entender a task.
- Contrato essencial nao confirmado pela codebase.
- Task sem assumptions, files to touch e success criteria claros antes da
  primeira escrita.
- Teste/check previsto e impossivel de rodar sem decisao humana.
- Risco novo de dados, security, auth, storage, politica de acesso, API ou UX
  critica nao previsto na spec.

Nesses casos, recomende voltar para `/sdd:spec` com o motivo exato.

## Roteamento De Modelo

Perfil default desta skill: `executor`.

- Default: modelo medio + `high`. Use modelo forte + `high/xhigh` apenas quando
  houver join complexo, security, DB/politica de acesso/auth/storage, API
  critica, dados sensiveis, perda de dados ou conflito entre fontes.
- Subagentes mecanicos/localizados: modelo medio.
- Validador/auditor: modelo forte quando houver join, risco ou divergencia.

Nao use modelo forte para compensar spec ruim. Se a spec nao fecha o escopo,
pare e volte para `/sdd:spec`.

## Saida Final

Ao finalizar, reporte: pacote executado; tasks/subagentes executados e status de
cada um; arquivos escritos; gates passados/falhados; testes/checks executados;
deviations; stop conditions acionadas, se houver; proximo passo recomendado:
`/sdd:review` ou voltar para `/sdd:spec`.
