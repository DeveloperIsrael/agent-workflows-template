# Workflow de Desenvolvimento & Governanca

> **Arquivo Canonico**: Este documento define o workflow de desenvolvimento e governanca do projeto.

---

## 1. Regras de Ouro (Governanca)

1. **Task First**: A task DEVE ser criada ANTES de qualquer modificacao no codigo.
2. **Documentacao Viva**: Mantenha a documentacao sincronizada com o codigo.
3. **Code Review**: Todo codigo deve passar por review antes de merge.
4. **Testes**: Features novas devem incluir testes quando aplicavel.
5. **Commits Atomicos**: Cada commit deve representar uma unica mudanca logica.

---

## 2. Mapeamento de Status

> Adapte conforme sua ferramenta de gestao (Jira, Linear, ClickUp, GitHub Projects).

| Acao | Status |
|------|--------|
| Ideia / Backlog | `backlog` |
| Pronto para Iniciar | `todo` |
| Em Desenvolvimento | `in_progress` |
| Em Review | `in_review` |
| Finalizado | `done` |

---

## 3. Workflow: Nova Feature

### Fase 1: Planejamento

1. **Criar Task** no board com descricao detalhada
2. **Definir criterios de aceite**
3. **Estimar complexidade**
4. **Atribuir responsavel**

### Fase 2: Branch

```bash
# Criar branch a partir da main/develop
git checkout -b feature/[TASK-ID]-[nome-kebab]
```

### Fase 3: Analise (Tasks Complexas)

Para tasks complexas, documente a abordagem antes de codar:
- Identifique arquivos impactados
- Liste dependencias
- Considere edge cases

### Fase 4: Implementacao

**Ordem recomendada**:
1. **Types/Interfaces**: Definir tipos primeiro
2. **Services/API**: Camada de dados
3. **State/Store**: Gerenciamento de estado
4. **Components**: Componentes UI
5. **Tests**: Testes unitarios/integracao

**Lembre-se** (ref: `.agents/rules/01-architecture.md`):
- Seguir padroes de codigo do projeto
- Manter arquivos pequenos e focados
- Documentar funcoes publicas

### Fase 5: Verificacao

```bash
# TypeScript (se aplicavel)
npm run type-check

# Linting
npm run lint

# Formatacao
npm run format

# Testes
npm run test

# Build
npm run build
```

### Fase 6: Pull Request

```bash
# Push da branch
git push -u origin feature/[TASK-ID]-[nome]

# Criar PR
gh pr create --base main --title "[TASK-ID] Nome da Feature"
```

**Checklist do PR:**
- [ ] Descricao clara do que foi feito
- [ ] Screenshots (se mudanca visual)
- [ ] Testes passando
- [ ] Codigo revisado (self-review)

---

## 4. Workflow: Bugfix

1. **Reproduzir o bug** e documentar passos
2. **Identificar causa raiz** no codebase
3. **Criar branch**: `fix/[TASK-ID]-[descricao]`
4. **Implementar correcao**
5. **Adicionar teste** que previne regressao
6. **Criar PR** com steps para validar

---

## 5. Checklist Pre-PR

### Codigo
- [ ] Passa em todos os linters/formatters
- [ ] Sem warnings do compilador
- [ ] Testes passando

### Arquitetura
- [ ] Segue padroes do projeto (`.agents/rules/`)
- [ ] Nenhum arquivo muito grande (>500 linhas)
- [ ] Funcoes complexas documentadas

### Qualidade
- [ ] Self-review completo
- [ ] Removido codigo comentado/debug
- [ ] Nomes descritivos (variaveis, funcoes)

---

## 6. Convencoes de Commit

```
type(scope): descricao curta

[corpo opcional]

[footer opcional]
```

### Tipos

| Tipo | Uso |
|------|-----|
| `feat` | Nova funcionalidade |
| `fix` | Correcao de bug |
| `docs` | Documentacao |
| `style` | Formatacao (sem mudanca de codigo) |
| `refactor` | Refatoracao |
| `test` | Adicao/correcao de testes |
| `chore` | Tarefas de manutencao |

### Exemplos

```
feat(auth): implementa login com Google
fix(cart): corrige calculo de desconto
docs(readme): adiciona instrucoes de setup
refactor(api): extrai logica de validacao
```

---

## 7. Ferramentas Recomendadas

| Categoria | Opcoes |
|-----------|--------|
| Gestao de Tasks | Jira, Linear, ClickUp, GitHub Projects |
| CI/CD | GitHub Actions, GitLab CI, CircleCI |
| Code Review | GitHub PRs, GitLab MRs |
| Documentacao | Notion, Confluence, Markdown |

---

## Referencias

- [.agents/rules/01-architecture.md](../rules/01-architecture.md) - Padroes de codigo
- [context/architecture/engineering.md](../../context/architecture/engineering.md) - Arquitetura do projeto
- [context/adr/README.md](../../context/adr/README.md) - Decisoes arquiteturais
