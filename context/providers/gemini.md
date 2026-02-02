# Gemini CLI - Configuracao

> Documentacao de configuracao para Gemini CLI (Google).

---

## Estrutura de Arquivos

```
projeto/
├── .gemini/
│   ├── settings.json    # Config + MCPs (tudo junto)
│   └── skills/          # Symlinks para .agents/skills/
│
└── GEMINI.md            # Entry point (instrucoes para o agente)
```

---

## .gemini/settings.json

No Gemini, configuracoes e MCPs ficam no mesmo arquivo.

```json
{
  "model": "gemini-2.0-flash",
  "temperature": 0.7,
  "maxOutputTokens": 8192,

  "systemInstruction": "Voce e um assistente de desenvolvimento. Leia GEMINI.md para instrucoes.",

  "tools": [
    {
      "functionDeclarations": []
    }
  ],

  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-filesystem", "."]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  },

  "safetySettings": [
    {
      "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
      "threshold": "BLOCK_NONE"
    }
  ]
}
```

---

## Configuracoes Principais

| Campo | Tipo | Descricao |
|-------|------|-----------|
| `model` | string | Modelo a usar (gemini-2.0-flash, gemini-pro, etc) |
| `temperature` | number | Criatividade (0-1) |
| `maxOutputTokens` | number | Limite de tokens na resposta |
| `systemInstruction` | string | Instrucao de sistema |
| `mcpServers` | object | Servidores MCP |
| `safetySettings` | array | Filtros de seguranca |

---

## MCPs no Gemini

Os MCPs usam o mesmo protocolo do Claude, mas a config fica dentro do `settings.json`.

```json
{
  "mcpServers": {
    "nome-do-mcp": {
      "command": "comando",
      "args": ["arg1", "arg2"],
      "env": {
        "VAR": "valor"
      }
    }
  }
}
```

---

## GEMINI.md

Entry point para o agente. Estrutura similar ao CLAUDE.md.

Veja o template em [GEMINI.md](../../GEMINI.md).

---

## Variaveis de Ambiente

```bash
# API Key (obrigatorio)
export GOOGLE_API_KEY="your-api-key"

# Ou via arquivo
echo "your-api-key" > ~/.gemini/api_key
```

---

## Comandos Uteis

```bash
# Iniciar Gemini CLI
gemini

# Com arquivo de config especifico
gemini --config .gemini/settings.json

# Instalar skill
npx skills add owner/repo@skill-name
```

---

## Referencias

- [Gemini API Docs](https://ai.google.dev/docs)
- [Gemini CLI GitHub](https://github.com/google-gemini/gemini-cli)
