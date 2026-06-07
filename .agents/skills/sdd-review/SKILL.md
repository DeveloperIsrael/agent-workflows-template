---
name: sdd-review
description: >
  Revisao final read-only apos `/sdd:execute` e antes de `/sdd:close`. Use quando
  o usuario chamar `/sdd:review`, pedir review de uma spec executada, branch, diff
  ou PR, ou quando o orquestrador precisar validar as implementacoes de uma spec.
  Safe-by-default: nao edita arquivos, nao muta tracker, nao aprova PR, nao
  commita, nao faz push e nao altera estado externo.
license: MIT
allowed-tools: Read, Grep, Glob, Bash, Task, Skill
model: opus
effort: high
---

# SDD Review — Revisao Final Antes Do Fechamento

Revise o trabalho executado contra a spec, o plano, as tasks e o diff real. Esta
skill e o fiscal da obra entre `/sdd:execute` e `/sdd:close`.

O orquestrador chama esta skill quando a execucao termina o escopo definido. Se o
alvo for amplo, use subagentes de review para manter o contexto limpo; o
orquestrador fica responsavel por documentar, commitar, abrir PR e atualizar o
tracker depois, via `/sdd:close`.

## Principios

- Review nao implementa. Se encontrar problema, reporte achado e recomende voltar
  para `/sdd:execute` ou `/sdd:spec`.
- Review nao fecha task. `/sdd:close` cuida de commit, docs finais, tracker e PR.
- Especulacao nao vira finding. Reporte apenas achados com evidencia e alta
  confianca.
- Cada finding deve explicar impacto, evidencia e recomendacao.
- Diga tambem o que ficou bom. Review util nao e so cacar defeito.
- Evite repostar ou duplicar comentarios existentes quando revisando PR.

## Limites De Mutacao

Permitido:

- Ler specs, planos, reports, diffs, codigo, docs e testes.
- Rodar comandos read-only (`git diff`, `git status`, `git show`; leitura de
  PR/MR via a CLI do host de VCS quando explicitamente segura; `rg`/`grep`).
- Invocar subagentes read-only via `Task` quando o escopo justificar.
- Invocar `codex-review` como segunda opiniao quando os triggers required
  casarem.

Proibido:

- Editar arquivos.
- Criar, editar, comentar, mover status ou chamar tracker.
- Criar, trocar, deletar ou sincronizar branch.
- Commit, push, PR, merge, rebase ou deploy.
- Aprovar PR/MR, request changes, postar review/comment no host de VCS sem pedido
  explicito do usuario.
- Ler `.env` ou secrets.

Se o input contiver `--dry-run`, `teste seco`, `dry run`, `diagnostico` ou
`check`, nao dispare subagentes, nao rode comandos caros e nao poste nada;
produza somente diagnostico de prontidao.

## Modos De Entrada

1. `spec package`: aceite `.specs/<slug>` ou task id que resolva para um unico
   pacote `.specs/<task-id>-*`.
2. `branch`: revise diff local contra a base definida pelo projeto (main/develop)
   ou contra o upstream quando existir.
3. `PR/MR`: aceite numero ou URL; leia metadata/diff pela CLI do host de VCS, mas
   nao poste comentarios sem flag/pedido explicito.
4. `auto`: se nao houver alvo, tente resolver nesta ordem: spec package pelo
   branch atual, PR/MR do branch atual, diff local.

Se houver mais de um alvo plausivel, pare e peca decisao humana.

## Preflight Obrigatorio

Antes da revisao:

1. Resolver o alvo de forma unica.
2. Capturar snapshot de `git status --short --branch`.
3. Identificar base de comparacao:
   - spec package: `SPEC.md`, `EXECUTION_PLAN.md`, `AGENT_TASKS.md` se existir,
     outputs gerados e diff local relevante;
   - branch: diff contra a base do projeto ou base informada;
   - PR/MR: metadata + diff via CLI do host.
4. Ler contrato da spec quando houver pacote: requisitos; criterios de aceite;
   write scope; forbidden files; DoD; deviations/reports gerados.
5. Identificar dimensoes aplicaveis de review.
6. Em `--dry-run`, terminar aqui com readiness report.

## Dimensoes De Review

Use todas as dimensoes aplicaveis. Quando o diff for amplo, invoque subagentes
read-only por dimensao; quando for pequeno, pode revisar inline seguindo a mesma
matriz.

### 1. Spec Compliance

- trabalho executado cumpre `SPEC.md`, `EXECUTION_PLAN.md` e `AGENT_TASKS.md`;
- DoD foi atingido;
- Human Gates nao foram reabertos silenciosamente;
- write scope e forbidden files foram respeitados;
- outputs prometidos existem;
- deviations foram documentadas.

### 2. Security & Data

Use quando houver auth, politica de acesso, storage, DB, API, PII, share,
ownership, XSS, uploads, permissions ou dados sensiveis.

- bypass de autorizacao;
- vazamento de PII/secrets;
- politica de acesso (RLS/row-level/ACL) ou storage inconsistente;
- permissao/share/ownership regressiva;
- XSS/HTML injection;
- logs sensiveis;
- validacao server-side ausente.

Se triggers required de `codex-review` casarem, invoque a segunda opiniao antes
de concluir.

### 3. Architecture & Patterns

Use `architecture-rules` como referencia.

- separacao de responsabilidades (SoC/SRP);
- gerenciamento de estado consistente com o padrao do projeto;
- tratamento de erros adequado;
- arquivos grandes / refactor transversal alem do limite do projeto;
- contratos entre camadas respeitados.

### 4. Tests & Quality

Use `testing-discipline` quando houver testes.

- testes prometidos foram adicionados/rodados;
- nenhum teste foi deletado, enfraquecido ou pulado para passar;
- bugs high/urgent tem regression test;
- cobertura considera as classes de vulnerabilidade aplicaveis.

### 5. Regression & Hallucination

- mudancas fora do escopo;
- import/simbolo fantasma;
- chamada com assinatura errada;
- duplicacao de logica existente;
- TODO em producao;
- type assertion escondendo erro;
- erro engolido silenciosamente;
- comportamento antigo removido sem justificativa.

### 6. Docs & Governance

- `context/`/ADR atualizado quando area governada mudou;
- `.specs/` registra outputs/deviations relevantes;
- `update-docs` sera necessario no close;
- tracker/PR readiness tem dados suficientes para `/sdd:close`;
- docs temporais nao foram promovidos como canonicos sem decisao.

### 7. Performance

Use quando houver loops, queries, renders, workers, uploads ou IO. Reporte
somente problemas visiveis:

- N+1;
- await sequencial independente;
- render/processamento em loop;
- selecao/consulta ampla demais;
- operacao sem limite/paginacao;
- trabalho pesado no caminho critico.

## Subagentes De Review

Ao usar subagentes, envie contexto minimo: alvo e base de comparacao; trechos
relevantes de `SPEC.md`/`EXECUTION_PLAN.md`; diff ou paths permitidos para aquela
dimensao; regras da dimensao; formato de retorno.

Subagentes devem: ser read-only; nao chamar o tracker; nao editar arquivos;
reportar `Complete | Partial | Blocked`; listar findings com severidade,
evidencia e recomendacao; listar arquivos/hunks revisados sem finding.

## Severidades

- `BLOCKER`: impede close; precisa voltar para execute/spec.
- `SECURITY`: risco de auth, dados, XSS, politica de acesso, storage, PII ou
  secrets.
- `REGRESSION`: comportamento existente quebrado ou escopo vazado.
- `QUALITY`: manutenibilidade, testes, docs ou arquitetura sem bloqueio direto.
- `SUGGESTION`: melhoria opcional.

## Formato De Finding

```markdown
### [SEVERITY] Titulo curto
- Evidencia: `path:line` ou hunk/arquivo.
- Impacto: por que importa.
- Recomendacao: fix especifico ou voltar para `/sdd:spec`/`/sdd:execute`.
- Confianca: alta | media.
```

Nao reporte findings de baixa confianca. Marque incertezas separadamente.

## Saida Final

Retorne: alvo revisado; modo usado (`spec`, `branch`, `pr`); subagentes/dimensoes
usados; arquivos/hunks cobertos; highlights; findings por severidade; incertezas
ou areas nao cobertas; recomendacao final:

- `PASS -> seguir para /sdd:close`;
- `FIX REQUIRED -> voltar para /sdd:execute`;
- `SPEC GAP -> voltar para /sdd:spec`;
- `NEEDS HUMAN DECISION`.

## Quando Nao Rodar

- Antes de `/sdd:execute`, salvo review de plano/spec.
- Em mudanca trivial sem spec/diff relevante, a menos que o usuario peca.
- Quando o usuario pedir explicitamente para pular review.
