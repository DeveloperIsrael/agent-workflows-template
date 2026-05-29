# Verificando o Carregamento de Configs e Skills

Este guia te ajuda a confirmar que o provider que voce esta usando esta de fato lendo os arquivos do template — `CLAUDE.md` / `AGENTS.md`, skills em `.agents/skills/`, hooks, settings, etc.

> **Por que verificar?** Cada provider tem sua propria convencao de descoberta. Um arquivo no lugar errado, uma permissao faltando, ou um symlink quebrado fazem o provider parecer "estar funcionando" mas sem ler nada do template. O sintoma e silencioso: o agente trabalha, mas sem usar suas skills/regras.

---

## Claude Code

**Entry point:** `CLAUDE.md` (raiz).
**Skills:** `.claude/skills/` (symlinks → `.agents/skills/`).
**Hooks:** `.claude/hooks/` registrados em `.claude/settings.json`.

### Checklist

1. **CLAUDE.md foi lido?**
   - Mude algo trivial em `CLAUDE.md` (ex: adicione uma linha com "TESTE-LOAD-XYZ" no topo) e abra Claude. Pergunte: "leia o CLAUDE.md e me diga o que voce ve no topo".
   - Se ele citar `TESTE-LOAD-XYZ`, foi lido. Reverta.

2. **Skills aparecem?**
   - Rode `/skills` (slash command). Lista todas as skills disponiveis na sessao.
   - Confira se as skills do `.agents/skills/` estao listadas. Se nao, provavelmente o symlink em `.claude/skills/` esta faltando.
   - Verificar symlinks:
     ```bash
     ls -la .claude/skills/  # deve mostrar lrwxrwxrwx → ../../.agents/skills/<nome>
     ```

3. **Hooks ativos?**
   - Rode `/hooks` (slash command). Lista hooks registrados.
   - Verifique que cada um aponta para um arquivo executavel:
     ```bash
     test -x .claude/hooks/<nome>.sh && echo OK
     ```

4. **Settings carregaram?**
   - Em `.claude/settings.json`, confirme que `hooks`, `permissions`, `env` estao definidos.
   - Validar JSON: `jq . .claude/settings.json` (sem erro = JSON valido).

---

## Codex (OpenAI)

**Entry point:** `AGENTS.md` (raiz).
**Skills:** `.agents/skills/`.
**Config:** `.codex/config.toml`.

### Checklist

1. **AGENTS.md foi lido?**
   - Mesma estrategia do Claude: edite uma linha no topo, abra o Codex, peca confirmacao.

2. **Skills carregaram?**
   - Codex le `.agents/skills/` por convencao. Se voce tem 16 skills no diretorio mas o agente parece nao saber, verifique se o `AGENTS.md` lista as skills explicitamente — alguns providers so usam o que esta listado no entry point.

3. **MCPs?**
   - Verifique `.codex/config.toml` (campo `mcp_servers` ou similar). Rode `codex --version` para garantir que esta na versao que suporta MCPs.

---

## Gemini

**Entry point:** `AGENTS.md` (raiz).
**Skills:** `.agents/skills/`.
**Config:** `.gemini/settings.json` (inclui `mcpServers`).

### Checklist

1. **AGENTS.md lido?**
   - Mesma estrategia: edite topo, peca confirmacao.

2. **Settings carregam?**
   - `jq . .gemini/settings.json` deve passar.
   - Se voce define `mcpServers`, valide que o JSON inclui `command`, `args`, `env`.

3. **Skills**: igual ao Codex — Gemini le de `.agents/skills/` via convencao.

---

## OpenCode

**Entry point:** `AGENTS.md` (raiz).
**Skills:** `.agents/skills/`.
**Config:** `.opencode/settings.json`.

### Checklist

1. **AGENTS.md lido?**
   - Mesma estrategia.

2. **Config valida?**
   - `jq . .opencode/settings.json`.

3. **Veja `opencode.jsonc.template`** no template raiz se houver — define o schema de MCPs.

---

## GitHub Copilot

**Entry point:** `AGENTS.md` + `.github/copilot-instructions.md`.
**Skills:** `.agents/skills/` (Copilot le AGENTS.md, que pode listar skills).

### Checklist

1. **`copilot-instructions.md` esta sendo aplicado?**
   - Em uma sessao do Copilot Chat, peca: "Quais sao as instrucoes especificas deste repo?". Se ele citar conteudo do `copilot-instructions.md`, foi carregado.

2. **AGENTS.md universal:** Copilot Chat (em VS Code) recente respeita `AGENTS.md`. Confirme com pergunta similar.

3. **Skills**: Copilot tradicionalmente nao tem suporte direto a skills externos. As regras em `AGENTS.md` ainda guiam o comportamento.

---

## Cursor

**Entry point:** `.cursor/rules/*.mdc` (formato MDC) + `.cursorrules` (legacy, na raiz).
**Skills:** modelo proprio — Cursor nao consome `.agents/skills/` diretamente. Voce pode replicar o conteudo das skills como `.cursor/rules/<nome>.mdc` se quiser.

### Checklist

1. **Rules estao no formato MDC?**
   - `.cursor/rules/<nome>.mdc` deve ter frontmatter `description`, `globs`, etc. Veja `context/providers/cursor.md`.

2. **Cursor reconhece o repo?**
   - Em "Cursor Settings → Models" verifique que o agente esta vendo as rules. Em "Cursor Settings → Codebase" veja se o repo foi indexado.

3. **`.cursorrules` (legacy)**: se voce tem este arquivo na raiz, o Cursor le. E texto puro, sem frontmatter.

---

## Symlinks de skills (geral)

Symlinks quebrados sao a falha silenciosa mais comum. Verifique:

```bash
# Lista symlinks quebrados em .claude/skills/
find .claude/skills/ -type l -exec test ! -e {} \; -print
```

Se aparecer algo, o destino nao existe. Reapontar:
```bash
ln -sf "../../.agents/skills/<nome>" ".claude/skills/<nome>"
```

---

## Quando o agente "esquece" a regra

Se o agente conhece uma regra (ex: "TDD obrigatorio", anti-skip) mas nao aplica:

1. Confirme que a regra vive como skill em `.agents/skills/` e tem `description` com gatilhos no frontmatter — no Claude e o gatilho que dispara a skill.
2. **Claude-first**: skills auto-carregam no Claude pelo frontmatter; outros providers (Cursor/Gemini/Codex) NAO varrem skills — eles leem o `CLAUDE.md`/`AGENTS.md`, que deve citar a skill e linkar o `SKILL.md` explicitamente.
3. Adicione um exemplo concreto no entry point: "ANTES de mudar codigo, leia a skill `testing-discipline` (`.agents/skills/testing-discipline/SKILL.md`)".

---

## Resumo: ordem de troubleshooting

1. Entry point existe e esta no lugar certo? (`CLAUDE.md` ou `AGENTS.md` na raiz)
2. Entry point e citado pelo provider em uma pergunta de teste?
3. Symlinks de skills estao validos? (`find -type l ! -e`)
4. Settings JSON sao validos? (`jq .`)
5. Hooks sao executaveis? (`test -x`)
6. Rules listadas no entry point estao referenciadas explicitamente?
