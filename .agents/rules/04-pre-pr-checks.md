---
trigger: always_on
---

# 04 — Pre-PR Checks

> Regra obrigatoria sempre que o agente for abrir um PR (`gh pr create`, `gh pr edit --add-label ready-for-review`, ou equivalente).
> Complementa a checklist visual de [`.github/PULL_REQUEST_TEMPLATE.md`](../../.github/PULL_REQUEST_TEMPLATE.md) — esta rule e prescritiva, o template e declarativo.

---

## Principio

**Reviewer humano nao deve ser o primeiro a descobrir que o PR nao compila.**

Checklist em PR template e visual: alguem marca `[x]` ainda que nao tenha rodado nada. Esta rule torna explicito que o agente roda os comandos como parte do fluxo de criacao do PR — antes de `gh pr create`, nao depois.

---

## Comandos obrigatorios (cada projeto define os seus)

Este e o template canonico. Cada projeto que estende o template substitui os comandos abaixo no proprio `04-pre-pr-checks.md`, com base no `package.json` (ou equivalente) real:

```bash
pnpm lint              # linter (Biome / ESLint / outro)
pnpm <type-check>      # `tsc --noEmit` ou `pnpm exec tsc --noEmit`
pnpm <test>            # vitest run / jest / playwright (suite que roda em CI)
pnpm build             # production build
```

> Repos sem stack runtime (docs-only / template) substituem por checks aplicaveis: validar parsing de ADRs, privacy guard regex, link checker.

---

## Protocolo

1. **Rodar todos os comandos aplicaveis em sequencia.** Cada um precisa terminar com exit code 0.
2. **Se algum falhar:**
   - **NAO abrir o PR.**
   - Reportar a saida do erro (primeiras ~15 linhas) ao user.
   - Corrigir antes de prosseguir.
3. **Se um passo for legitimamente inaplicavel** (ex: PR puramente em `.agents/`/`context/` sem mudanca de codigo, projeto sem suite de teste para a area tocada): documentar no PR body em "Test plan" qual passo foi pulado e por que.
4. **Se o user pedir "abre o PR mesmo" com check vermelho:** documentar no PR body qual check falhou, log curto do erro, e qual o plano de fix. Nunca silenciar.

---

## Quando pular cada check

| Check | Pula quando | Documentar onde |
|---|---|---|
| `lint` | Nunca | — |
| `type-check` | Nunca | — |
| `test` | Mudanca puramente em `.agents/`/`context/`/`.github/`/README | "Test plan" do PR |
| `build` | Mudanca puramente em `.agents/`/`context/`/`.github/`/README | "Test plan" do PR |

> Texto em `.tsx` / `.ts` (mesmo string literal) **pode quebrar tipos** — `type-check` nunca vira "puramente texto".

---

## Anti-patterns

- Abrir PR e descobrir erro de TS / lint no review humano (ou pior: na CI).
- Marcar `[x]` no checklist do PR template sem ter rodado os comandos.
- Skipar `test` silenciosamente quando o teste existe e ainda falha.
- Pular `type-check` porque "so mudei copy" — strings em TSX/TS sao tipadas.
- Rodar so `lint --changed` quando ha refator que toca tipos transversalmente.

---

## Por que rule, nao hook

Hook (`.claude/settings.json` com `PreToolUse` em `Bash:gh pr create`) bloqueia de fato — mas e config por-maquina/repo, quebra se o user rodar `gh pr create` no terminal direto, e duplica disciplina entre projetos. Rule prescritiva e SSoT versionada que escala — combina com PR template (segundo guard visual) e com hooks opcionais por projeto se o time quiser enforcement extra.

---

## Referencia rapida

- Template: este arquivo
- PR template: [`.github/PULL_REQUEST_TEMPLATE.md`](../../.github/PULL_REQUEST_TEMPLATE.md)
- Workflow: [`../governance/workflow.md`](../governance/workflow.md)
- Testing: [`./03-testing.md`](./03-testing.md) (anti-skip + 8-class checklist)
