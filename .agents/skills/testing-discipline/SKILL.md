---
name: testing-discipline
description: >
  Testes de verdade (anti-skip) + 8 classes de vulnerabilidade obrigatorias
  (IDOR, Authorization Bypass, Race Condition, Auth Bypass, Secrets in Code,
  SSRF, Limite de Input, Bypass de Validacao). Carrega ao tocar arquivos de teste
  (`*.spec.*`, `*.test.*`, `tests/`) ou quando o user menciona "test", "spec",
  "skip", "coverage", "cobertura", "E2E", "IDOR", "RLS", "race condition",
  "auth bypass", "secrets", "SSRF", "input limit", "validation bypass",
  "regression spec", "vulnerabilidade". Complementa a skill `tdd`.
license: MIT
allowed-tools: Bash, Grep
---

# Testes de Verdade (Anti-Skip)

> Obrigatoria sempre que tocar arquivos de teste. Complementa o ciclo TDD
> (skill `tdd`: Red → Green → Refactor).

## Principio

**Teste verde sem ter executado nada e PIOR que teste vermelho.**

Skip silencioso gera falsa confianca — o pipeline fica verde, o bug vai pra
producao, o usuario sofre. Um bug encontrado numa varredura e cinco vezes mais
barato que o mesmo bug em producao.

> Exemplos usam **pseudo-codigo**. Substitua pela sintaxe do seu runner (Vitest,
> Jest, Mocha, Pytest, RSpec, Go test, JUnit). Os principios valem em qualquer stack.

---

## 8 Vulnerabilidades obrigatorias

Todo spec novo em area com dado de usuario real deve considerar estas 8 classes:

| Classe | Como cobrir |
|---|---|
| **IDOR** (Insecure Direct Object Reference) | Spec com 2 usuarios — usuario A tenta acessar recurso do usuario B via ID/URL direto |
| **Authorization Bypass** (RLS / RBAC) | Request direto a API/DB burlando UI; valida que a policy bloqueia |
| **Race Condition** | 2 contextos simultaneos editando o mesmo recurso; valida lock/idempotencia |
| **Auth Bypass** | Endpoint sem sessao valida retorna 401/403 — nao 200 com payload vazio |
| **Secrets in Code** | grep do bundle/imagem por keys, tokens, URLs internas conhecidas |
| **SSRF** (Server-Side Request Forgery) | Endpoints que aceitam URL/host — bloquear redes internas (169.254, 10.*, etc.) |
| **Limite de Input** | maxlength, file size, paginacao sem limite, regex catastrofica |
| **Bypass de Validacao** | request direto a API ignorando validacao client-side; servidor valida tudo |

---

## Regras

### 1. PROIBIDO `skip` por falta de fixture

Skip condicional silencioso **mascara** problema de fixture como teste passando.
Quando a fixture falha, o teste deveria ficar vermelho — nao verde silencioso.

**Errado** (passa verde sem rodar nada):
```
test('select node', () => {
    skip_if(!ready, 'Canvas did not load')
})
```
**Certo** (falha visivel se fixture quebrou):
```
test('select node', () => {
    assert(ready, 'Canvas fixture must load')
})
```
**Melhor** — seedar fixture deterministicamente em setup/`beforeEach`.

### 2. `skip` permanente so com justificativa rastreavel

Skip sem condicao so e aceito com **trio rastreavel**:
```
// SKIP-REASON: <ID/link da task> — fixture seed bloqueada por migracao pendente
// OWNER: @<nome>
// DEADLINE: YYYY-MM-DD
skip('renaming bulk causes race', () => { ... })
```
Sem o trio (issue/owner/deadline) = bloqueia code review.

### 3. Spec atrelado a bug

Todo bug urgent/high precisa de spec de regressao com o ID do bug no `describe`:
```
describe('<Area> failure resilience (<BUG-ID>)', () => {
    test('<comportamento esperado apos fix>', () => { /* red sem fix → green com fix */ })
})
```
**Criterio de fechamento:** o spec falha SEM o fix e passa COM o fix.

### 4. Cobertura minima por area antes de "validada"

| Tipo de cenario | Minimo |
|---|---|
| Happy path | 1 |
| Negative (erro esperado) | 2 |
| Edge case | 1 |
| Multi-context (concorrencia) | obrigatorio onde houver edicao paralela |
| Stress (20+ items) | obrigatorio onde houver bulk/batch |

### 5. Auditoria continua

- **CI deve quebrar build** se a contagem de skips aumentar entre branches.
- Rode periodicamente uma auditoria de skips (adapte ao runner):
  ```sh
  grep -rE 'test\.skip|it\.skip|describe\.skip' tests/ src/   # JS
  grep -rE '@pytest\.mark\.skip|pytest\.skip' tests/          # Pytest
  ```
- PR template deve perguntar: "Quantos skips adicionei? Por que?"

---

## Anti-patterns

- **"Spec teatro"**: arquivo com 7 testes ativos vs 17 skips — escrito mas nunca rodou.
- **"Spec orfao do bug"**: unico teste do spec, criado pra um bug urgent, esta `skip`.
- **"Falsa cobertura"**: 1 teste, happy path apenas, sem edge case nem negative.
- **"Mock = nao pega bug de integracao"**: so unit (mocks), zero E2E. O mock concorda com o codigo, nao com o sistema.

---

## Skills relacionadas

- `tdd` — ciclo Red → Green → Refactor (carregar SEMPRE no inicio da task comportamental)
- `playwright-best-practices` — POM, fixtures, anti-flakiness (E2E), se a stack usar Playwright
- `codex-review` — segunda opiniao sobre cobertura de seguranca dos testes
