# Providers - Configuracao por Ferramenta

> Este diretorio contem a documentacao de configuracao para cada AI Coding Agent.

---

## Visao Geral

Cada ferramenta tem sua propria estrutura de configuracao:

| Ferramenta | Pasta | Config Principal | MCPs |
|------------|-------|------------------|------|
| Claude Code | `.claude/` | `settings.json` | `.mcp.json` (raiz) |
| Gemini | `.gemini/` | `settings.json` | Dentro do settings |
| Cursor | `.cursor/` | `settings.json` + `rules/*.mdc` | Via settings.json |
| Codex (OpenAI) | `.codex/` | `config.toml` | Via config |
| OpenCode | `.opencode/` | `settings.json` | Via config |
| GitHub Copilot | `.github/` | `copilot-instructions.md` | N/A |

---

## Estrutura de Pastas

```
projeto/
├── .claude/
│   ├── settings.json      # Permissoes e env vars
│   └── skills/            # Skills instalados (symlinks)
│
├── .mcp.json              # MCPs do Claude (na raiz!)
│
├── .gemini/
│   ├── settings.json      # Config + MCPs integrados
│   └── skills/
│
├── .cursor/
│   ├── settings.json      # Configuracoes
│   └── skills/
│
├── .cursorrules           # Rules do Cursor (na raiz)
│
├── .codex/
│   ├── config.toml       # TOML, nao JSON!
│   └── skills/
│
├── .opencode/
│   ├── settings.json
│   └── skills/
│
├── .github/
│   ├── copilot-instructions.md  # Instrucoes Copilot
│   └── skills/
│
├── CLAUDE.md              # Entry point Claude
└── GEMINI.md              # Entry point Gemini
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

---

## Skills Compartilhados

Todos os skills ficam em `.agents/skills/` e sao linkados para cada ferramenta:

```
.agents/skills/           # Fonte (arquivos reais)
├── clean-code-principles/
├── coding-standards/
└── typescript-best-practices/

.claude/skills/           # Symlinks
├── clean-code-principles -> ../../.agents/skills/clean-code-principles
└── ...
```

Isso permite que um skill funcione em todas as ferramentas.
