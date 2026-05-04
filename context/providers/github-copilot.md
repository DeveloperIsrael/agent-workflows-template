# GitHub Copilot - Configuracao

> Documentacao de configuracao para GitHub Copilot.

> **Aviso multi-stack**: o exemplo de `.github/copilot-instructions.md` abaixo (TypeScript strict mode, React functional components, Tailwind, Jest + React Testing Library, PascalCase em `.tsx`, `src/components/`/`hooks/`/`services/`) e para stack **React/TypeScript**. Substitua tudo pelos equivalentes da stack real do seu projeto antes de copiar — o conteudo do `copilot-instructions.md` deve descrever **o seu** projeto, nao replicar o exemplo. Para Python: tipo `mypy --strict`, FastAPI/Django, pytest, snake_case em `app/api/`. Para Go: golangci-lint, `cmd/`+`internal/`, `go test`. Para Java: Spring Boot, JUnit 5, `src/main/java/`. Etc.

---

## Estrutura de Arquivos

```
projeto/
├── .github/
│   ├── copilot-instructions.md  # Instrucoes para Copilot
│   └── skills/                   # Symlinks para .agents/skills/
│
└── .copilotignore               # Arquivos a ignorar (opcional)
```

---

## .github/copilot-instructions.md

Instrucoes personalizadas para o Copilot no repositorio.

```markdown
# Copilot Instructions

## Project Overview
Este e um projeto [descricao] usando [stack].

## Code Style
- Use TypeScript strict mode
- Prefer functional components
- Use Tailwind CSS for styling
- Follow SOLID principles

## Naming Conventions
- Components: PascalCase (e.g., `UserProfile.tsx`)
- Hooks: camelCase with `use` prefix (e.g., `useAuth.ts`)
- Utils: camelCase (e.g., `formatDate.ts`)
- Types: PascalCase with `I` or `T` prefix (e.g., `IUser`, `TConfig`)

## Project Structure
```
src/
├── components/   # React components
├── hooks/        # Custom hooks
├── services/     # API calls
├── utils/        # Utility functions
└── types/        # TypeScript types
```

## Testing
- Use Jest for unit tests
- Use React Testing Library for component tests
- Test files: `*.test.ts` or `*.test.tsx`

## DO NOT
- Use `any` type
- Use class components
- Commit console.log statements
- Use inline styles

## Examples

### Good Component
```tsx
interface Props {
  name: string;
  onClick: () => void;
}

export function Button({ name, onClick }: Props) {
  return (
    <button
      className="px-4 py-2 bg-blue-500 text-white rounded"
      onClick={onClick}
    >
      {name}
    </button>
  );
}
```

### Good Hook
```tsx
export function useUser(id: string) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchUser(id).then(setUser).finally(() => setLoading(false));
  }, [id]);

  return { user, loading };
}
```
```

---

## .copilotignore

Similar ao .gitignore, define arquivos que o Copilot deve ignorar.

```
# Secrets
.env
.env.*
secrets/
*.key
*.pem

# Dependencies
node_modules/
.pnpm-store/

# Build output
dist/
build/
.next/

# Large files
*.zip
*.tar.gz
*.sql

# Generated
coverage/
*.generated.ts
```

---

## Configuracoes do VS Code

```json
{
  "github.copilot.enable": {
    "*": true,
    "plaintext": false,
    "markdown": true,
    "yaml": true
  },
  "github.copilot.advanced": {
    "inlineSuggestCount": 3
  }
}
```

---

## Atalhos Uteis

| Atalho | Acao |
|--------|------|
| `Tab` | Aceitar sugestao |
| `Esc` | Rejeitar sugestao |
| `Alt + ]` | Proxima sugestao |
| `Alt + [` | Sugestao anterior |
| `Ctrl + Enter` | Abrir Copilot Chat |

---

## Copilot Chat

No VS Code, use o Copilot Chat para:

```
# Explicar codigo
/explain

# Gerar testes
/tests

# Corrigir codigo
/fix

# Documentar
/doc
```

---

## Workspace Instructions

Alem do arquivo `.github/copilot-instructions.md`, voce pode usar:

```json
// .vscode/settings.json
{
  "github.copilot.chat.codeGeneration.instructions": [
    {
      "text": "Always use TypeScript",
      "role": "system"
    },
    {
      "text": "Follow clean code principles",
      "role": "system"
    }
  ]
}
```

---

## Referencias

- [GitHub Copilot Docs](https://docs.github.com/en/copilot)
- [Copilot Chat](https://docs.github.com/en/copilot/github-copilot-chat)
- [Custom Instructions](https://docs.github.com/en/copilot/customizing-copilot)
