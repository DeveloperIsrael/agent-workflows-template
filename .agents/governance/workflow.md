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

**Ordem recomendada** (exemplo para projeto frontend React/TS — adapte a stack do seu projeto):

1. **Types/Interfaces**: Definir tipos primeiro
2. **Services/API**: Camada de dados
3. **State/Store**: Gerenciamento de estado
4. **Components**: Componentes UI
5. **Tests**: Testes unitarios/integracao

> Em backend Python/Java/Go ou CLI, a sequencia se parece mais com `Models/Schemas → Repositorios → Services → Handlers/Controllers → Tests`. Em projeto polyglot, aplique a sequencia por modulo. O principio (definir contornos antes da implementacao + tests no fim) e universal.

**Lembre-se** (ref: `.agents/rules/01-architecture.md`):
- Seguir padroes de codigo do projeto
- Manter arquivos pequenos e focados
- Documentar funcoes publicas

### Fase 5: Verificacao

> Comandos abaixo sao placeholders — cada projeto define os seus em `.agents/rules/04-pre-pr-checks.md` baseado no build system real. Exemplos por stack ao lado.

```bash
# Type-check (se a linguagem tem)
[COMANDO_TYPECHECK]   # ex: npm run type-check, mypy, go vet, ./gradlew check, cargo check

# Linting
[COMANDO_LINT]        # ex: npm run lint, ruff, golangci-lint, ./gradlew spotlessCheck, cargo clippy

# Formatacao
[COMANDO_FORMAT]      # ex: npm run format, ruff format, gofmt, ./gradlew spotlessApply, cargo fmt

# Testes
[COMANDO_TESTS]       # ex: npm test, pytest, go test ./..., ./gradlew test, cargo test

# Build
[COMANDO_BUILD]       # ex: npm run build, python -m build, go build, ./gradlew build, cargo build --release
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

## 8. Skill Defaults (gatilhos operacionais)

Gatilhos canonicos para as skills universais do template. Espelhe esta tabela em `CLAUDE.md` se quiser que agentes a citem como entry point. Skills stack-especificas (ex.: `typescript-best-practices`, `playwright-best-practices`) sao **lazy-triggered** pelo proprio frontmatter — nao entram aqui.

| Gatilho | Skill | Por que |
|---|---|---|
| Inicio de task comportamental (feature, bugfix reproduzivel, refactor com mudanca de comportamento) | `tdd` | Garante Red → Green → Refactor; evita "implementei e depois escrevi teste" |
| Fechamento de task (PR pronto pra review) | `update-docs` | Sincroniza docs em `context/`, ADRs, READMEs com o codigo do mesmo PR |
| Decisao arquitetural relevante | `adr-skill` | Cria/atualiza ADR no formato MADR 4.0 com Socratic prompting |
| Commit | `git-commit` | Conventional Commits (`feat:`, `fix:`, `docs:`, etc.) |
| Auditoria / second opinion antes de merge critico | (skill de audit do seu setup) | Reduz blind spot do agente principal — adapte ao tooling disponivel |

> CSS puro, copy/typo, chore mecanico, comentario: **exceto TDD** (sem teste pra esses) — as outras skills continuam valendo onde aplicavel.

---

## 9. Gates de Validacao

Estrategia de validacao em camadas (pre-push local → CI remoto → branch protection) e o porque de cada camada estao documentados em [`context/guides/ci-and-gates.md`](../../context/guides/ci-and-gates.md). Modelos de implementacao:

- [`.githooks/pre-push.example`](../../.githooks/pre-push.example) — pre-push hook stack-agnostico (copie pra `pre-push`, adapte)
- [`.github/workflows/ci.example.yml`](../../.github/workflows/ci.example.yml) — pipeline CI stack-agnostico (copie pra `ci.yml`, adapte)

---

## Referencias

- [.agents/rules/01-architecture.md](../rules/01-architecture.md) - Padroes de codigo
- [.agents/rules/03-testing.md](../rules/03-testing.md) - Anti-skip + 8 vulnerabilidades obrigatorias
- [.agents/rules/04-pre-pr-checks.md](../rules/04-pre-pr-checks.md) - Protocolo de checks pre-PR
- [context/architecture/engineering.md](../../context/architecture/engineering.md) - Arquitetura do projeto
- [context/adr/README.md](../../context/adr/README.md) - Decisoes arquiteturais
- [context/guides/ci-and-gates.md](../../context/guides/ci-and-gates.md) - Estrategia de gates em camadas
