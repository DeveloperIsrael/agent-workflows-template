---
name: root-cause-debugging
description: >
  Hypothesis-first debugging: reproduzir o bug, declarar hipótese de causa
  raiz, verificar end-to-end (DB → API → state → render) e só então propor
  fix. Para se o primeiro fix não resolver — não chuta segunda vez.
  Use quando user diz "bug", "broken", "investigate", "doesn't work",
  "regression", "por que isso", "o que tá errado", "não funciona", "tá quebrado".
allowed-tools: Read, Grep, Glob, Bash, Edit
model: sonnet
---

# Root-Cause Debugging

Metodologia hipótese-first para investigar bugs já manifestados. Diferente do `tdd` (preventivo, test-first), aqui o bug já existe e o objetivo é entender **por que** antes de tocar código.

---

## Princípio

**No guessing.** Instrumenta, traça o fluxo, valida hipótese. Fixes sucessivos sem entender causa raiz são red flag.

---

## Workflow

### 1. Reproduce & Instrument

- Escreva um teste/repro que **falha** antes de investigar. Sem repro, qualquer "fix" é palpite.
- Para bug visual/comportamental: rastreie o fluxo real **DB → API → state → render**. Não assuma onde tá o problema.
- Se o comportamento não é observável externamente, instrumente `console.debug` (ou `logger.debug`) temporário em pontos críticos do fluxo. Remova depois do fix.

### 2. Hypothesis-First

Antes de tocar código:

1. **Declare a hipótese por escrito** — "Acho que X acontece porque Y."
2. **Explique a expectativa** — "Se Y for verdade, eu esperaria ver Z em [lugar]."
3. **Liste premissas** que precisariam ser verdadeiras pra hipótese se sustentar.

### 3. Verify End-to-End

Confirme a hipótese antes de assumir que é verdade:

- Leia o código do caminho suspeito (não só o local do sintoma).
- Rode query no banco se a hipótese envolve dados.
- Cheque logs / debug output.
- Compare o que observou com o que esperava no passo 2.

Se a observação **diverge** da hipótese, a hipótese tá errada — volta pro passo 2, não tenta forçar o fix.

### 4. Fix Only After Verification

- Aplique o fix mínimo baseado na causa raiz verificada.
- **Se o primeiro fix não resolve: PARE.** Não chute uma segunda vez. Reexamine premissas — a hipótese tava errada ou incompleta.
- Remova instrumentação temporária (console.debug, logs extra) antes de commitar.

---

## Anti-patterns

| ❌ | ✅ |
|---|---|
| Aplicar fix sem repro confirmado | Repro primeiro, depois investiga |
| Chutar segundo fix quando o primeiro falha | Voltar à hipótese e reexaminar premissas |
| Assumir causa pelo sintoma | Traçar fluxo DB → API → state → render |
| Editar arquivo do sintoma sem ler o caminho | Ler o caminho inteiro do fluxo suspeito |
| Deixar console.debug temporário commitado | Remover antes de commit |
| Múltiplos fixes sequenciais "tentando" | Red flag — para e reanalisa |

---

## Quando NÃO usar

- Fix de typo, copy, CSS puro sem mudança de comportamento.
- Tarefa onde a causa raiz já é óbvia e single-step (ex: variável null check faltando que crasha visível no stack trace).
- Refactor preventivo — use `tdd`.

---

## Relação com `tdd`

`tdd` é **preventivo** (test-first ao construir feature). Este skill é **reativo** (root-cause em código já quebrado). Princípio compartilhado: "verifique antes de fixar." Princípios distintos: TDD desenha testes, este desenha hipóteses.
