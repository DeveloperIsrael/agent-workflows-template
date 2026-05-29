---
name: pre-pr-checks
description: >
  Protocolo obrigatorio de checks antes de abrir um PR (`gh pr create` ou
  equivalente): lint / type-check / test / build, cada um com exit code 0.
  Carrega quando o agente vai abrir um PR ou quando o user menciona "pre-PR",
  "before PR", "antes do PR", "checks", "lint", "typecheck", "type-check",
  "build verde". Comandos sao placeholders — cada projeto preenche com a stack real.
license: MIT
allowed-tools: Bash
---

# Pre-PR Checks

> Obrigatoria sempre que for abrir um PR. Prescritiva (o agente roda os comandos);
> complementa o guard visual de [`.github/PULL_REQUEST_TEMPLATE.md`](../../../.github/PULL_REQUEST_TEMPLATE.md).

## Principio

**Reviewer humano nao deve ser o primeiro a descobrir que o PR nao compila.**

Checklist em PR template e visual — alguem marca `[x]` sem ter rodado nada. Esta
skill torna explicito que o agente roda os comandos **antes** de `gh pr create`.

---

## Comandos obrigatorios (cada projeto define os seus)

Substitua pelos comandos da stack real (`package.json`, `pyproject.toml`,
`go.mod`, `Cargo.toml`, `pom.xml`/`build.gradle`, etc.):

```bash
[COMANDO_LINT]         # ex: pnpm lint, ruff check, golangci-lint run, ./gradlew spotlessCheck
[COMANDO_TYPECHECK]    # ex: tsc --noEmit, mypy ., go vet ./..., cargo check
[COMANDO_TESTS]        # ex: pnpm test, pytest, go test ./..., ./gradlew test, cargo test
[COMANDO_BUILD]        # ex: pnpm build, python -m build, go build ./..., ./gradlew build
```

> Linguagens sem type-checker dedicado (Python sem MyPy, JS puro) podem omitir o
> passo — **documente** a omissao, nao silencie.
> Repos sem stack runtime (docs-only/template) substituem por checks aplicaveis:
> validar parsing de ADRs, link checker, privacy guard.

---

## Protocolo

1. **Rodar todos os comandos aplicaveis em sequencia.** Cada um termina com exit code 0.
2. **Se algum falhar:** NAO abra o PR. Reporte ~15 linhas do erro ao user. Corrija antes de prosseguir.
3. **Passo legitimamente inaplicavel** (PR so em `.agents/`/`context/`, area sem suite): documente em "Test plan" do PR qual passo foi pulado e por que.
4. **Se o user pedir "abre mesmo" com check vermelho:** documente no PR body qual check falhou, log curto, e plano de fix. Nunca silencie.

---

## Quando pular cada check

| Check | Pula quando | Documentar onde |
|---|---|---|
| `lint` | Nunca | — |
| `type-check` | Nunca | — |
| `test` | Mudanca puramente em `.agents/`/`context/`/`.github/`/README | "Test plan" do PR |
| `build` | Mudanca puramente em `.agents/`/`context/`/`.github/`/README | "Test plan" do PR |

> Texto em arquivos tipados (`.ts`/`.tsx`, `.py` com type hints, `.go`, `.rs`,
> `.java`/`.kt`, `.cs`) — mesmo string literal — pode quebrar checagem de tipos.
> `type-check` nunca vira "puramente texto" se a area tocada inclui codigo-fonte.

---

## Anti-patterns

- Abrir PR e descobrir erro de tipo/lint no review humano (ou na CI).
- Marcar `[x]` no checklist do PR template sem ter rodado os comandos.
- Skipar `test` silenciosamente quando o teste existe e falha.
- Pular `type-check` porque "so mudei copy" — strings tipadas quebram type-check.

---

## Por que skill/rule, nao hook

Hook bloqueia de fato, mas e config por-maquina/repo, quebra se rodarem
`gh pr create` no terminal direto, e duplica disciplina entre projetos. A skill e
SSoT versionada que escala — combina com o PR template (guard visual) e com hooks
opcionais por projeto (`.githooks/`, `.claude/hooks/examples/`) se o time quiser
enforcement extra.

---

## Referencias

- [`.github/PULL_REQUEST_TEMPLATE.md`](../../../.github/PULL_REQUEST_TEMPLATE.md) — guard visual
- `testing-discipline` — anti-skip + 8 classes de vulnerabilidade
- `workflow-governance` — protocolo de PR e branch
