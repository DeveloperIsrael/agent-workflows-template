---
name: codex-review
description: >
  Protocolo de segunda opiniao com ferramenta externa de review em momentos
  criticos: mudancas de DB/migrations/RLS, testes ou cobertura incerta, fix
  security-critical (auth/storage/permissoes), refactor grande. Invoca um revisor
  externo (Codex via `Skill(codex)` como default — adaptavel ao tooling do
  projeto). Carrega quando o user diz "second opinion", "segunda opiniao",
  "audit", "review", "codex", "DB migration review", "RLS review", "refactor
  review", ou ao fechar uma task que casa com os triggers required.
license: MIT
allowed-tools: Read, Bash, Skill
---

# Codex Review — Segunda Opiniao

Quando os triggers required casarem, **invoque um revisor externo**. Default:

```
Skill(skill: "codex")
```

> Adapte ao tooling do projeto: se nao houver `codex`, use o revisor externo
> disponivel (outro modelo/CLI de review). O ponto e **segunda opiniao externa**.

⚠️ **NAO pule "porque a mudanca parece pequena"** e **NAO substitua por raciocinio
inline proprio** — o valor e a opiniao externa. Ofereca proativamente.

---

## Required Triggers

| Contexto | Quando invocar | Prompt sugerido |
|---|---|---|
| Mudanca de DB / migrations / policy de autorizacao (RLS/RBAC) | Antes de abrir PR, apos escrever a migration | "Audit this authorization/migration change for privilege escalation, bypass vectors, and recursion risks." |
| Testes ou cobertura incerta | Apos escrever os testes da task | "Review these tests for the 8 vulnerability classes (IDOR, Authorization Bypass, Race Condition, Auth Bypass, Secrets, SSRF, Input Limit, Validation Bypass)." |
| Fix security-critical (auth, storage, permissoes) | Antes do commit | "Verify this fix doesn't introduce a regression in the auth/authorization or storage paths." |
| Refactor grande (arquivo extenso / muitos arquivos) | Apos terminar o refactor | "Review this refactor for correctness, unintended behavior changes, and type-safety compliance." |

## Optional Triggers (ofereca ao user)

- Feature tocando mais de 3 arquivos.
- Qualquer mudanca que o agente considere alto risco.

---

## Configuracao recomendada

| Caso | Effort | Sandbox |
|---|---|---|
| Security audit (auth, authz, storage, migrations) | `high` | `read-only` |
| Test review | `medium` | `read-only` |
| Refactor review | `medium` | `read-only` |

> Use o modelo mais capaz disponivel para security audit; um menor/mais barato
> para test/refactor review. Sempre `read-only` — o revisor nao edita codigo.

---

## Protocolo de Discordancia

Se o revisor contradiz o agente principal:
1. Nao aceite silenciosamente — pese a evidencia.
2. Revisor tem razao: aplique o fix e informe o user.
3. Agente principal tem razao: resuma identificando-se e apresente a evidencia.
4. Ambiguo: apresente as duas posicoes e deixe o user decidir.

---

## Quando NAO invocar

- CSS puro, copy, chores, docs.
- Hotfixes triviais (< 5 linhas, sem business logic).
- Quando o user explicitamente nao quiser.
- Task ja revisada na mesma sessao (evita loops).

---

## Skills relacionadas

- `codex` — executa a invocacao ao revisor externo (gerencia model/effort/sandbox).
- `testing-discipline` — define as 8 vulnerabilidades referenciadas no prompt de test review.
- `architecture-rules` — pontos tipicos de audit em refactor review (tipagem, tamanho, SoC).
- `task-flow` — fechamento; o review encaixa na Fase 3 (apos checks, antes do status).
