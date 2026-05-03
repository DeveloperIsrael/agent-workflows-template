# Providers - Configuracao por Ferramenta

> Este diretorio contem a documentacao de configuracao para cada AI Coding Agent.

---

## Convencao: dois entry points, skills centralizados

Este template segue duas convencoes de descoberta para skills/regras:

1. **Claude Code** le `CLAUDE.md` (raiz) + `.claude/` (skills, hooks, settings).
2. **Codex, Gemini, OpenCode, GitHub Copilot** seguem a convencao "agents.md universal": leem `AGENTS.md` (raiz) + `.agents/` (skills).

Skills ficam centralizados em **dois lugares**:

- `.agents/skills/` — Source of Truth (arquivos reais)
- `.claude/skills/` — symlinks apontando para `.agents/skills/` (necessario porque o Claude Code carrega skills daqui)

**Cursor** tem seu proprio modelo (`.cursor/rules/*.mdc` na raiz), gerenciado separadamente.

> Antes da v2.x este template tinha mirrors `.gemini/skills/`, `.codex/skills/`, etc. Foram removidos: providers que respeitam o padrao `AGENTS.md`/`.agents/` carregam direto do SSoT.

---

## Visao Geral

| Ferramenta | Entry point | Config | Onde le skills | MCPs |
|------------|-------------|--------|----------------|------|
| Claude Code | `CLAUDE.md` | `.claude/settings.json` | `.claude/skills/` (symlinks → `.agents/skills/`) | `.mcp.json` (raiz) |
| Codex (OpenAI) | `AGENTS.md` | `.codex/config.toml` | `.agents/skills/` | Via config |
| Gemini | `AGENTS.md` | `.gemini/settings.json` | `.agents/skills/` | Dentro do settings |
| OpenCode | `AGENTS.md` | `.opencode/settings.json` | `.agents/skills/` | Via config |
| GitHub Copilot | `AGENTS.md` + `.github/copilot-instructions.md` | `.github/copilot-instructions.md` | `.agents/skills/` | N/A |
| Cursor | `.cursor/rules/*.mdc` | `.cursor/settings.json` + `.cursorrules` (raiz) | (proprio) | Via settings |

---

## Estrutura de Pastas

```
projeto/
├── CLAUDE.md                       # Entry point Claude
├── AGENTS.md                       # Entry point para Codex/Gemini/OpenCode/Copilot
│
├── .agents/                        # SSoT
│   └── skills/                     # Skills reais (todos os providers leem daqui via AGENTS.md)
│
├── .claude/
│   ├── settings.json               # Permissoes, env vars, hooks
│   ├── skills/                     # Symlinks → ../../.agents/skills/
│   ├── hooks/                      # Hooks ativos + examples/ opt-in
│   └── commands/, agents/, ...     # GSD framework
│
├── .agents/                         # Governance + rules (cross-provider)
│   ├── governance/workflow.md
│   └── rules/                      # 01-architecture.md, 02-pdi.md, 03-testing.md
│
├── .mcp.json                       # MCPs do Claude (na raiz)
│
├── .gemini/                        # Config Gemini (sem skills/ — le de .agents/)
├── .codex/                         # Config Codex
├── .opencode/                      # Config OpenCode
├── .cursor/                        # Config Cursor (modelo proprio)
└── .github/
    └── copilot-instructions.md     # Instrucoes Copilot
```

---

## Guias por Ferramenta

| Ferramenta | Guia |
|------------|------|
| Claude Code | [claude.md](./claude.md) |
| Gemini | [gemini.md](./gemini.md) |
| Cursor | [cursor.md](./cursor.md) |
| Codex | [codex.md](./codex.md) |
| OpenCode | [opencode.md](./opencode.md) |
| GitHub Copilot | [github-copilot.md](./github-copilot.md) |
| **Verificando o carregamento** | [verifying-load.md](./verifying-load.md) |

---

## Skills Compartilhados

Skills sao a forma como o agente recebe contexto procedural (como fazer X, quando aplicar Y). Eles ficam em **um unico lugar** — `.agents/skills/` — e sao expostos para o Claude via symlinks em `.claude/skills/`. Outros providers leem direto de `.agents/skills/` via convencao `AGENTS.md`.

```
.agents/skills/                     # SSoT (arquivos reais)
├── clean-architecture/
├── typescript-best-practices/
├── playwright-best-practices/
└── ...

.claude/skills/                     # Symlinks (Claude Code-only)
├── clean-architecture -> ../../.agents/skills/clean-architecture
└── ...
```

Para adicionar uma skill nova: instale em `.agents/skills/` (manual ou via `npx skills add`) e crie symlink em `.claude/skills/`. Nao replique em outros providers.
