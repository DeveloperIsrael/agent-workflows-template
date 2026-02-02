# OpenCode - Configuracao

> Documentacao de configuracao para OpenCode.

---

## Estrutura de Arquivos

```
projeto/
├── .opencode/
│   ├── settings.json    # Configuracoes
│   ├── config.toml      # Config alternativo (TOML)
│   └── skills/          # Symlinks para .agents/skills/
│
└── OPENCODE.md          # Entry point (opcional)
```

---

## .opencode/settings.json

```json
{
  "provider": "anthropic",
  "model": "claude-sonnet-4-20250514",
  "temperature": 0.7,

  "permissions": {
    "allow": [
      "bash:npm *",
      "bash:git *",
      "read:**",
      "write:**"
    ],
    "deny": [
      "read:.env*",
      "bash:rm -rf *"
    ]
  },

  "context": {
    "maxFiles": 50,
    "maxTokens": 100000,
    "include": ["src/**", "*.json", "*.md"],
    "exclude": ["node_modules/**", "dist/**"]
  },

  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "."]
    }
  }
}
```

---

## .opencode/config.toml (Alternativo)

```toml
[general]
provider = "anthropic"
model = "claude-sonnet-4-20250514"
temperature = 0.7

[permissions]
allow = [
  "bash:npm *",
  "bash:git *",
  "read:**"
]
deny = [
  "read:.env*"
]

[context]
max_files = 50
max_tokens = 100000
include = ["src/**", "*.json"]
exclude = ["node_modules/**"]

[mcp.filesystem]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-filesystem", "."]
```

---

## Providers Suportados

| Provider | Modelos |
|----------|---------|
| `anthropic` | claude-sonnet-4, claude-opus-4 |
| `openai` | gpt-4o, gpt-4-turbo |
| `google` | gemini-2.0-flash, gemini-pro |
| `ollama` | llama3, codellama, mistral |
| `local` | Modelos locais via API |

---

## Configuracao por Provider

### Anthropic
```json
{
  "provider": "anthropic",
  "model": "claude-sonnet-4-20250514",
  "apiKey": "${ANTHROPIC_API_KEY}"
}
```

### OpenAI
```json
{
  "provider": "openai",
  "model": "gpt-4o",
  "apiKey": "${OPENAI_API_KEY}"
}
```

### Ollama (Local)
```json
{
  "provider": "ollama",
  "model": "codellama",
  "baseUrl": "http://localhost:11434"
}
```

---

## Variaveis de Ambiente

```bash
# Anthropic
export ANTHROPIC_API_KEY="sk-ant-..."

# OpenAI
export OPENAI_API_KEY="sk-..."

# Google
export GOOGLE_API_KEY="..."
```

---

## Comandos Uteis

```bash
# Iniciar OpenCode
opencode

# Com provider especifico
opencode --provider openai

# Com modelo especifico
opencode --model gpt-4o

# Modo chat
opencode chat
```

---

## Referencias

- [OpenCode GitHub](https://github.com/opencode-ai/opencode)
- [OpenCode Docs](https://opencode.ai/docs)
