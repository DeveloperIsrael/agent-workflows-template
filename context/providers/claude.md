# Claude Code - Configuracao

> Documentacao de configuracao para Claude Code (Anthropic).

> **Aviso multi-stack**: o exemplo de `settings.json` abaixo (`Bash(npm run *)` em allow, `NODE_ENV` em env) e para projetos **Node/TS**. Em outras stacks, troque o padrao Bash pelo runner real do projeto (`Bash(pytest *)`, `Bash(go *)`, `Bash(./gradlew *)`, `Bash(cargo *)`, etc.) e ajuste env vars (`PYTHONPATH`, `GOFLAGS`, `JAVA_HOME`, etc.). O resto do exemplo (`Read(**)`, `Write(**)`, denies para `.env`/`secrets/`/`*.key`) e stack-agnostico.

---

## Estrutura de Arquivos

```
projeto/
├── .claude/
│   ├── settings.json       # Permissoes e variaveis de ambiente
│   ├── settings.local.json # Override local (gitignore)
│   └── skills/             # Symlinks para .agents/skills/
│
├── .mcp.json               # Configuracao de MCPs (NA RAIZ!)
│
└── CLAUDE.md               # Entry point (instrucoes para o agente)
```

---

## .claude/settings.json

Define permissoes de comandos e variaveis de ambiente.

```json
{
    "permissions": {
        "allow": [
            "Bash(npm run *)",
            "Bash(git *)",
            "Bash(gh *)",
            "Read(**)",
            "Edit(**)",
            "Write(**)"
        ],
        "deny": [
            "Read(.env)",
            "Read(.env.*)",
            "Read(secrets/**)",
            "Read(**/*.key)",
            "Bash(rm -rf *)",
            "Bash(curl *)"
        ]
    },
    "env": {
        "NODE_ENV": "development"
    }
}
```

### Padroes de Permissao

| Padrao | Exemplo | Descricao |
|--------|---------|-----------|
| `Bash(cmd *)` | `Bash(npm run *)` | Permite comando com qualquer argumento |
| `Read(**)` | `Read(**)` | Permite ler qualquer arquivo |
| `Read(path/*)` | `Read(src/*)` | Permite ler arquivos em pasta especifica |
| `Write(**)` | `Write(**)` | Permite escrever qualquer arquivo |

---

## .mcp.json (MCPs)

**IMPORTANTE**: Este arquivo fica na **raiz do projeto**, nao dentro de `.claude/`.

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/allowed/dir"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
```

### MCPs Populares

| MCP | Comando | Proposito |
|-----|---------|-----------|
| GitHub | `@modelcontextprotocol/server-github` | PRs, Issues, Repos |
| Filesystem | `@modelcontextprotocol/server-filesystem` | Acesso a arquivos |
| Sequential Thinking | `@modelcontextprotocol/server-sequential-thinking` | Raciocinio complexo |
| Postgres | `@modelcontextprotocol/server-postgres` | Banco de dados |
| Brave Search | `@anthropics/mcp-server-brave-search` | Busca web |

---

## .claude/settings.local.json

Override local que NAO vai para o git (adicione ao .gitignore).

```json
{
    "env": {
        "MY_API_KEY": "secret-local-only"
    }
}
```

---

## CLAUDE.md

Entry point para o agente. Deve conter:
- Links para documentacao relevante
- Regras criticas (TL;DR)
- Estrutura do projeto
- Comandos uteis

Veja o template em [CLAUDE.md](../../CLAUDE.md).

---

## Comandos Uteis

```bash
# Verificar configuracao
claude config list

# Instalar skill
npx skills add owner/repo@skill-name

# Listar skills
ls .claude/skills/
```

---

## Referencias

- [Claude Code Docs](https://docs.anthropic.com/claude-code)
- [MCP Protocol](https://modelcontextprotocol.io/)
