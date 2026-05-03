# 03 — Testes de Verdade (Anti-Skip)

> Regra obrigatoria sempre que voce tocar arquivos de teste (`*.spec.*`, `*.test.*`, `tests/`, etc.).
> Complementa o ciclo TDD definido em [`CLAUDE.md`](../../CLAUDE.md).

---

## Principio

**Teste verde sem ter executado nada e PIOR que teste vermelho.**

Skip silencioso gera falsa confianca — o pipeline fica verde, o bug vai pra producao, o usuario sofre. Um bug encontrado numa varredura e cinco vezes mais barato que o mesmo bug em producao.

---

## Vulnerabilidades obrigatorias (Beta-ready)

Todo spec novo em area com dado de usuario real deve considerar estas **8 classes**:

| Classe | Como cobrir |
|---|---|
| **IDOR** (Insecure Direct Object Reference) | Spec com 2 usuarios — usuario A tenta acessar recurso do usuario B via ID/URL direto |
| **Authorization Bypass** (RLS / RBAC / etc.) | Request direto a API/DB burlando UI; valida que policy de autorizacao bloqueia |
| **Race Condition** | 2 contextos simultaneos editando o mesmo recurso; valida lock/idempotencia |
| **Auth Bypass** | Endpoint sem sessao valida deve retornar 401/403 — nao 200 com payload vazio |
| **Secrets in Code** | grep do bundle/imagem por keys, tokens, URLs internas conhecidas |
| **SSRF** (Server-Side Request Forgery) | Endpoints que aceitam URL/host como input — bloquear redes internas (169.254, 10.*, etc.) |
| **Limite de Input** | maxlength, file size, paginacao sem limite, regex catastrofica |
| **Bypass de Validacao** | request direto a API ignorando validacao client-side; servidor deve validar tudo |

---

## Regras

### 1. PROIBIDO `skip` por falta de fixture

Skip condicional silencioso (`skip(condition, ...)`) **mascara** problema de fixture como teste passando. Quando a fixture falha, o teste deveria ficar vermelho — nao verde silencioso.

**Errado** (passa verde mesmo sem rodar nada):
```
test('select node', () => {
    skip_if(!ready, 'Canvas did not load')
    // ...
})
```

**Certo** (falha visivel se fixture quebrou):
```
test('select node', () => {
    assert(ready, 'Canvas fixture must load')
    // ...
})
```

**Melhor ainda** — seedar fixture deterministicamente em setup/`beforeEach`:
```
beforeEach(() => {
    seedDeterministic()  // garante estado, sem skip
})
```

> Substitua a sintaxe pelo runner da sua stack (Vitest, Jest, Pytest, RSpec, Go test, etc.). O principio e o mesmo.

### 2. `skip` permanente so com justificativa rastreavel

Skip sem condicao (skip permanente) so e aceito com **trio rastreavel**:

```
// SKIP-REASON: <ID-da-task> — fixture seed bloqueada por migracao pendente
// OWNER: @<nome>
// DEADLINE: YYYY-MM-DD
skip('renaming bulk causes race', () => { ... })
```

Sem o trio (issue + owner + deadline) = bloqueia code review.

### 3. Spec atrelado a bug

Todo bug **urgent/high** precisa de spec de regressao com o ID do bug no `describe`/contexto:

```
describe('<Area> failure resilience (<BUG-ID>)', () => {
    test('<comportamento esperado apos fix>', () => {
        // red sem fix → green com fix
    })
})
```

**Criterio de fechamento:** o spec falha SEM o fix e passa COM o fix. Sem essa prova, o bug nao muda para "em validacao".

### 4. Cobertura minima por area antes de "validada"

| Tipo de cenario | Minimo |
|---|---|
| Happy path | 1 |
| Negative (erro esperado) | 2 |
| Edge case | 1 |
| Multi-context (concorrencia) | obrigatorio onde houver edicao paralela |
| Stress (20+ items) | obrigatorio onde houver bulk/batch |

### 5. Auditoria continua

- **CI deve quebrar build** se contagem de skips aumentar entre branches.
- Rode periodicamente um comando de auditoria local que conte skips no projeto. Exemplo (adapte ao seu runner):
  ```sh
  # Playwright/Vitest/Jest
  grep -rE 'test\.skip|it\.skip|describe\.skip' tests/ src/

  # Pytest
  grep -rE '@pytest\.mark\.skip|pytest\.skip' tests/
  ```
- PR template deve perguntar: "Quantos skips adicionei? Por que?"

---

## Anti-patterns

Use como exemplos do que NAO repetir:

- **"Spec teatro"**: arquivo com 7 testes ativos vs 17 skips. Foi escrito mas nunca rodou — e o pior tipo de cobertura, porque mascara como verde.
- **"Spec orfao do bug"**: um unico teste no spec, criado especificamente para um bug `urgent`, esta `skip`. Bug volta pra producao.
- **"Falsa cobertura"**: 1 teste em 19 linhas — happy path apenas, sem edge case nem negative.
- **"Mock = nao pega bug de integracao"**: area com unit tests so (mocks) e zero E2E/integracao. O mock concorda com o codigo, nao com o sistema.

---

## Skills relacionadas

- `tdd` / `xp:tdd` — ciclo Red → Green → Refactor (carregar SEMPRE no inicio da task)
- `playwright-best-practices` — POM, fixtures, mocking, anti-flakiness (E2E)
- `js-testing` — Vitest/Jest, RTL, mocking patterns

> Os exemplos neste documento usam **pseudo-codigo**. Substitua pela sintaxe do seu runner: Vitest, Jest, Mocha, Playwright, Pytest, RSpec, Go test, JUnit. Os principios (anti-skip, fixture deterministico, regressao por bug ID, auditoria de skips) valem em qualquer stack.
