# Cursor - Configuracao

> Documentacao de configuracao para Cursor IDE.
> **Docs oficiais**: [docs.cursor.com/context/rules-for-ai](https://docs.cursor.com/context/rules-for-ai)

---

## Estrutura de Arquivos

```
projeto/
├── .cursor/
│   ├── rules/           # Rules no formato .mdc (NOVO!)
│   │   ├── project.mdc  # Regras gerais do projeto
│   │   └── *.mdc        # Regras especificas
│   ├── settings.json    # Configuracoes do Cursor
│   └── skills/          # Symlinks para .agents/skills/
│
├── .cursorrules         # DEPRECATED! Use .cursor/rules/*.mdc
│
└── .cursorignore        # Arquivos a ignorar (opcional)
```

> **IMPORTANTE**: O `.cursorrules` esta deprecated! Migre para `.cursor/rules/*.mdc`

---

## .cursor/rules/*.mdc (Formato Novo)

O Cursor agora usa arquivos `.mdc` (Markdown with Config) na pasta `.cursor/rules/`.

### Estrutura do arquivo .mdc

```markdown
---
description: Descricao da regra (quando aplicar)
globs: **/*.ts, **/*.tsx    # Arquivos onde aplicar
alwaysApply: true           # Aplicar sempre ou sob demanda
---

# Titulo da Regra

## Stack
- React 18 + TypeScript
- Tailwind CSS
- Zustand for state

## Code Style
- Use functional components
- Prefer composition over inheritance
- No `any` types

## File Structure
- Components in `src/components/`
- Hooks in `src/hooks/`
- Types in `src/types/`

## Conventions
- Use PascalCase for components
- Use camelCase for functions
- Use snake_case for file names

## DO NOT
- Use class components
- Use inline styles
- Commit console.log
```

---

## .cursor/settings.json

Configuracoes locais do projeto.

```json
{
  "cursor.cpp.disabledLanguages": [],
  "cursor.general.enableShadowWorkspace": true,
  "cursor.chat.showSuggestedFiles": true,
  "cursor.composer.enabled": true,

  "files.exclude": {
    "node_modules": true,
    ".git": true
  }
}
```

---

## .cursorignore

Similar ao .gitignore, define o que o Cursor deve ignorar.

```
# Dependencies
node_modules/
.pnpm-store/

# Build
dist/
build/
.next/

# Secrets
.env
.env.*
secrets/

# Large files
*.zip
*.tar.gz
```

---

## Composer (Multi-file editing)

O Cursor Composer permite editar multiplos arquivos. Configure no settings:

```json
{
  "cursor.composer.enabled": true,
  "cursor.composer.autoSave": true
}
```

---

## Atalhos Uteis

| Atalho | Acao |
|--------|------|
| `Cmd/Ctrl + K` | Abrir chat inline |
| `Cmd/Ctrl + L` | Abrir chat lateral |
| `Cmd/Ctrl + I` | Abrir Composer |
| `Cmd/Ctrl + Shift + K` | Editar selecao com AI |

---

## Integracao com MCPs

Cursor pode usar MCPs via extensoes ou configuracao avancada.

```json
{
  "cursor.mcp.servers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"]
    }
  }
}
```

---

## Dicas

1. **Use `.cursor/rules/*.mdc`** para definir contexto do projeto
2. **Seja especifico** nas regras - o Cursor segue literalmente
3. **Inclua exemplos** de codigo quando possivel
4. **Atualize regularmente** conforme o projeto evolui

---

## Referencias

- [Cursor Docs](https://cursor.sh/docs)
- [Cursor Rules Examples](https://cursor.directory/)
