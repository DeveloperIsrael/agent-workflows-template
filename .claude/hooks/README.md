# Claude Code Hooks

Hooks rodam automaticamente ao redor de tool calls do Claude (Bash, Edit, Write, etc.) e permitem injetar quality gates, validacoes e contexto na sessao. Ver docs: https://docs.claude.com/en/docs/claude-code/hooks

Este template e **stack-agnostico**. Hooks que dependem de uma toolchain especifica (Biome, tsc, ESLint, Ruff, MyPy) **nao vao ativos por padrao** — voce escolhe os exemplos que casam com a sua stack e ativa.

---

## Hooks ativos por padrao

Os hooks listados em [`../settings.json`](../settings.json) rodam quando voce abre Claude Code neste projeto. Atualmente:

- `gsd-check-update.js` — verifica updates do GSD (SessionStart)
- `gsd-context-monitor.js` — monitora context window (PostToolUse)
- `gsd-statusline.js` — gera a status line do GSD

Esses sao do framework GSD e funcionam em qualquer stack.

---

## Exemplos disponiveis

Em [`./examples/`](./examples/) voce encontra hooks pre-prontos para stacks comuns. **Eles nao rodam ate voce ativar.**

### TypeScript / JavaScript

| Hook | Quando | O que faz |
|------|--------|-----------|
| `biome-precommit.sh` | PreToolUse — Bash com `git commit` | Roda `biome check` em arquivos staged. Bloqueia commit se Biome falhar. |
| `tsc-check-changed.sh` | PostToolUse — Edit/Write/MultiEdit | Roda `tsc --noEmit` apos edicoes. Reporta erros (nao bloqueia). |
| `eslint-prettier-precommit.sh` | PreToolUse — Bash com `git commit` | Alternativa ao Biome: roda ESLint + Prettier em arquivos staged. |

### Python

| Hook | Quando | O que faz |
|------|--------|-----------|
| `ruff-check.sh` | PostToolUse — Edit/Write/MultiEdit | Roda `ruff check` apos edicoes. Reporta lint issues. |
| `mypy-check.sh` | PostToolUse — Edit/Write/MultiEdit | Roda `mypy` apos edicoes. Reporta erros de tipo. |

---

## Como ativar um hook

1. **Copie ou symlinke** o exemplo para `.claude/hooks/`:
   ```bash
   # Opcao 1: copiar (independente)
   cp .claude/hooks/examples/biome-precommit.sh .claude/hooks/biome-precommit.sh

   # Opcao 2: symlink (mantem sincronizado com o exemplo)
   ln -s examples/biome-precommit.sh .claude/hooks/biome-precommit.sh
   ```

2. **Garanta que esta executavel**:
   ```bash
   chmod +x .claude/hooks/biome-precommit.sh
   ```

3. **Registre no `.claude/settings.json`** sob `hooks`. Exemplo:
   ```jsonc
   {
     "hooks": {
       "PreToolUse": [
         {
           "matcher": "Bash",
           "hooks": [
             { "type": "command", "command": ".claude/hooks/biome-precommit.sh" }
           ]
         }
       ],
       "PostToolUse": [
         {
           "matcher": "Edit|Write|MultiEdit",
           "hooks": [
             { "type": "command", "command": ".claude/hooks/tsc-check-changed.sh" }
           ]
         }
       ]
     }
   }
   ```

4. **Reinicie a sessao Claude** — hooks sao lidos no start.

---

## Verificando que o hook esta carregando

Apos ativar e reiniciar:

- **Forma 1 — comando explicito**: rode `/hooks` no Claude Code. Lista os hooks registrados na sessao atual.
- **Forma 2 — provocar o trigger**: faca a acao que ativa o hook (ex: rodar `git commit` num branch limpo). Se o hook nao executou, ele nao foi carregado.
- **Forma 3 — log do hook**: hooks que querem deixar rastro podem escrever em `/tmp/hook-debug.log`. Util para hooks silenciosos (PostToolUse com `exit 0` quando OK).

Se o hook nao roda:
1. `chmod +x .claude/hooks/<nome>.sh` esta aplicado?
2. Path no `settings.json` esta correto (relativo ao repo root)?
3. `matcher` casa com a tool que voce esperava? (ex: "Bash", "Edit|Write")
4. JSON do `settings.json` e valido? Rode `jq . .claude/settings.json` para validar.

---

## Convencoes

- **PreToolUse**: pode bloquear (`exit 2`). Use para gates obrigatorios (lint, typecheck pre-commit).
- **PostToolUse**: nunca bloqueia (`exit 0` sempre). Use para feedback informativo (typecheck pos-edit, monitoring).
- **Silent quando OK**: nao polua o output do Claude com mensagens "tudo OK". Imprima so quando ha algo que o agente precisa saber.
- **Cap de tempo**: use `timeout 20` (ou similar) para nao travar a sessao se a ferramenta hangar.
- **Detectar stack antes**: hooks devem checar se a toolchain existe (`command -v tsc`) e se ha sinais do projeto (`tsconfig.json`, `pyproject.toml`) antes de agir. Veja `tsc-check-changed.sh` como referencia.

---

## Outros providers (Codex, Gemini, OpenCode, Cursor)

Cada provider tem sua propria forma de rodar hooks/comandos automaticos. Estes scripts em `examples/` sao especificos do **Claude Code**. Para outros providers, veja a documentacao deles. Todos os providers leem skills de `.agents/skills/` (via `AGENTS.md`) — apenas hooks sao especificos por provider.
