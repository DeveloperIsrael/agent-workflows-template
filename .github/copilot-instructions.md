# Copilot Instructions - [NOME_DO_PROJETO]

> Instrucoes para GitHub Copilot neste repositorio.

## Project Overview

[Descricao do projeto em 2-3 frases]

## Tech Stack

- [FRAMEWORK]
- [LINGUAGEM]
- [STYLING]
- [STATE_MANAGEMENT]

## Code Conventions

### TypeScript
- Use strict mode
- No `any` - prefer `unknown` when needed
- Define interfaces for all data structures

### Components
- Functional components only
- Props interface above component
- Destructure props in parameters

### Styling
- Use Tailwind CSS classes
- No inline styles
- Mobile-first responsive design

## File Structure

```
src/
├── components/   # React components
├── hooks/        # Custom hooks
├── services/     # API calls
├── stores/       # State management
├── utils/        # Utility functions
└── types/        # TypeScript types
```

## Naming

| Type | Convention | Example |
|------|------------|---------|
| Components | PascalCase | `UserProfile.tsx` |
| Hooks | camelCase + use | `useAuth.ts` |
| Utils | camelCase | `formatDate.ts` |
| Types | PascalCase | `User`, `ApiResponse` |
| Constants | UPPER_SNAKE | `MAX_RETRIES` |

## DO NOT

- Use `any` type
- Use class components
- Commit console.log
- Create files > 500 lines
- Use inline styles
- Skip error handling

## Examples

### Good Component

```tsx
interface UserCardProps {
  user: User;
  onSelect: (id: string) => void;
}

export function UserCard({ user, onSelect }: UserCardProps) {
  return (
    <div
      className="p-4 border rounded-lg hover:shadow-md cursor-pointer"
      onClick={() => onSelect(user.id)}
    >
      <h3 className="font-semibold">{user.name}</h3>
      <p className="text-gray-600">{user.email}</p>
    </div>
  );
}
```

### Good Hook

```tsx
export function useUser(id: string) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    setLoading(true);
    fetchUser(id)
      .then(setUser)
      .catch(setError)
      .finally(() => setLoading(false));
  }, [id]);

  return { user, loading, error };
}
```

## References

- `context/00-overview.md` - Project overview
- `.agent/rules/01-architecture.md` - Architecture rules
- `context/05-dictionary.md` - Terminology
