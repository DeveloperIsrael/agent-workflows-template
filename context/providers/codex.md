# Codex CLI (OpenAI) - Configuracao

> Documentacao de configuracao para Codex CLI (OpenAI).
> **Docs oficiais**: [developers.openai.com/codex](https://developers.openai.com/codex/config-reference/)

---

## Estrutura de Arquivos

```
projeto/
├── .codex/
│   ├── config.toml      # Configuracoes (TOML, nao JSON!)
│   ├── instructions.md  # Instrucoes para o agente (opcional)
│   └── skills/          # Symlinks para .agents/skills/
│
└── codex.md             # Entry point (opcional)
```

> **IMPORTANTE**: Codex usa `config.toml` (formato TOML), nao JSON!

---

## .codex/config.toml

```toml
# Docs: https://developers.openai.com/codex/config-reference/

# Model to use
model = "gpt-5-codex"

# Approval policy: "on-request", "unless-allow-listed", "never"
approval_policy = "on-request"

# Sandbox mode: "workspace-write", "danger-full-access"
sandbox_mode = "workspace-write"

[sandbox_workspace_write]
network_access = false

# MCP Servers (opcional)
[mcp_servers.github]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-github"]

[mcp_servers.github.env]
GITHUB_TOKEN = "${GITHUB_TOKEN}"
```

---

## Configuracoes Principais

| Campo | Tipo | Descricao |
|-------|------|-----------|
| `model` | string | Modelo (gpt-5-codex, gpt-4o, etc) |
| `approval_policy` | string | `on-request`, `unless-allow-listed`, `never` |
| `sandbox_mode` | string | `workspace-write`, `danger-full-access` |

---

## Approval Policies

| Policy | Comportamento |
|--------|---------------|
| `on-request` | Pede confirmacao para cada acao |
| `unless-allow-listed` | Auto-aprova comandos permitidos |
| `never` | Nunca pede confirmacao (cuidado!) |

---

## Variaveis de Ambiente

```bash
# API Key (obrigatorio)
export OPENAI_API_KEY="sk-..."

# Organizacao (opcional)
export OPENAI_ORG_ID="org-..."
```

---

## Comandos Uteis

```bash
# Iniciar Codex
codex

# Com modo full-auto (cuidado!)
codex --full-auto

# Adicionar diretorio permitido
codex --add-dir /path/to/dir

# Ver configuracao atual
codex config show
```

---

## Referencias

- [Codex Config Reference](https://developers.openai.com/codex/config-reference/)
- [Codex CLI Features](https://developers.openai.com/codex/cli/features/)
- [GitHub Repo](https://github.com/openai/codex)
