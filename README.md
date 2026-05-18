# Agent Workflows Template

> ⚠️ **ESTE É UM TEMPLATE — VOCÊ PRECISA ADAPTAR.**
> Cada arquivo aqui é um **ponto de partida**, não o estado final do seu projeto. Antes de fazer qualquer coisa, leia a seção [**Como Adaptar Este Template**](#como-adaptar-este-template) abaixo (5 minutos). Existem coisas que você **não deve mudar** (princípios), e coisas que você **tem que preencher** (placeholders e configs).

Template de estrutura de documentação e configuração para projetos que utilizam **AI Coding Agents** (Claude Code, Gemini, Cursor, OpenCode, Codex, Copilot).

> **Agentes** (Claude/Gemini/Codex/Copilot/Cursor/OpenCode): leiam [`CLAUDE.md`](./CLAUDE.md) — entry point canônico em runtime. Este README é para humanos (setup, adaptação, contribuição).

---

## Propósito

Este template fornece uma estrutura padronizada para:

1. **Documentação de Contexto** (`context/`) — arquivos que os agentes leem para entender o projeto
2. **Regras e Governança** (`.agents/`) — padrões de código e workflows de desenvolvimento
3. **Configurações de Agentes** (`.claude/`, `.gemini/`, `.cursor/`, etc.) — settings específicos por ferramenta

**É stack-agnóstico**: feito pra ser herdado por projetos em React+NestJS, Next.js+Python, Go, Rust, Java, etc. As recomendações são princípios; comandos concretos (lint, type-check, test) ficam como **placeholders** que você preenche.

---

## Como Adaptar Este Template

### O modelo mental

O template é dividido em **três camadas**:

| Camada | O que é | O que você faz |
|---|---|---|
| **Princípios** (não mude) | Workflow de governança, ADR como formato de decisão, anti-skip em testes, hierarquia de autoridade, pre-PR checks como conceito, conventional commits, task-first | **Herde** sem editar. Foram destilados de projetos reais e funcionam em qualquer stack. |
| **Estrutura** (renomeie/preencha) | Pastas `context/`, `.agents/`, `.claude/`, ADR template, README skeleton | **Mantenha** a estrutura, **preencha** os placeholders. Cada arquivo tem `[PLACEHOLDER]` ou `<placeholder>` indicando o que trocar. |
| **Comandos e Tooling** (substitua pelos seus) | `[COMANDO_LINT]`, `[COMANDO_TYPECHECK]`, `[COMANDO_TESTS]`, hooks de exemplo, workflows de CI | **Substitua** pelos comandos da sua stack. O template usa placeholders justamente porque não sabe se você está em pnpm, pytest, cargo, etc. |

### O que NÃO mudar (princípios)

Estes são padrões maduros — não os remova achando que é redundância:

- **Hierarquia de autoridade** em [`context/README.md`](./context/README.md) — define quem ganha quando dois docs discordam.
- **Workflow task-first** em [`.agents/governance/workflow.md`](./.agents/governance/workflow.md) — task criada **antes** de tocar código.
- **Anti-skip + 8 vulnerabilidades obrigatórias** em [`.agents/rules/03-testing.md`](./.agents/rules/03-testing.md) — vale pra qualquer runner.
- **Pre-PR checks** em [`.agents/rules/04-pre-pr-checks.md`](./.agents/rules/04-pre-pr-checks.md) — reviewer humano não descobre PR quebrado.
- **ADR como formato de decisão** em [`context/adr/`](./context/adr/) — MADR 4.0 com frontmatter.
- **Convencional commits** em [`.agents/governance/workflow.md`](./.agents/governance/workflow.md) — `feat:`, `fix:`, `docs:`, etc.
- **Skills universais** em [`CLAUDE.md`](./CLAUDE.md) — `clean-architecture`, `clean-code`, `update-docs`, `git-commit`, `adr-skill`, etc.

> Se um princípio aqui não faz sentido pro seu projeto, abra um ADR no seu repo registrando a divergência. Não delete silenciosamente.

### O que VOCÊ DEVE adaptar (checklist 30 minutos)

Marque conforme for completando. Cada linha aponta pro arquivo que você abre:

```
[ ] 1. Trocar nome e descrição
       - README.md (este arquivo) — substituir "Agent Workflows Template" pelo nome do seu projeto
       - CLAUDE.md — substituir [NOME_DO_PROJETO] e demais [PLACEHOLDER]
       - context/README.md — substituir [NOME_DO_PROJETO]

[ ] 2. Preencher contexto do produto
       - context/product/prd.md — visão, problema, escopo
       - context/product/business-rules.md — regras de negócio
       - context/domain/glossary.md — termos do domínio
       - context/domain/data-model.md — entidades, relações

[ ] 3. Declarar a stack
       - context/architecture/engineering.md — substituir TODOS os [TECH_*] e [FRAMEWORK_*]
                                                (linguagem, framework, runtime, build tool, deploy target, observability)
       - context/architecture/technical-specs.md — contratos técnicos específicos

[ ] 4. Adaptar pre-PR checks ao seu build system
       - .agents/rules/04-pre-pr-checks.md — substituir [COMANDO_LINT], [COMANDO_TYPECHECK],
                                              [COMANDO_TESTS], [COMANDO_BUILD] pelos comandos reais
       - .agents/governance/workflow.md — mesmos placeholders na Fase 5

[ ] 5. Configurar tracker e workflow
       - .agents/governance/workflow.md — escolher ferramenta (ClickUp/Linear/Jira/GitHub Projects)
                                          e ajustar a tabela de status

[ ] 6. Configurar MCPs (se usar)
       - cp .mcp.json.example .mcp.json
       - Editar com os MCPs que seu projeto realmente usa
       - Atualizar a tabela de MCPs em CLAUDE.md

[ ] 7. Configurar settings por ferramenta
       - .claude/settings.json — permissions (allowlist por comando, denylist de secrets)
       - .cursor/settings.json, .gemini/settings.json, etc. — só se você usa cada ferramenta

[ ] 8. Configurar gates locais (opcional mas recomendado)
       - cp .githooks/pre-push.example .githooks/pre-push
       - Editar comandos (lint/type-check/test) pra sua stack
       - chmod +x .githooks/pre-push
       - git config core.hooksPath .githooks

[ ] 9. Configurar CI remoto (opcional)
       - cp .github/workflows/ci.example.yml .github/workflows/ci.yml
       - Editar matrix da stack (Node? Python? Java? Multi-version?)
       - Substituir [COMANDO_*] pelos comandos reais

[ ] 10. Registrar a decisão de stack
        - Criar primeiro ADR: context/adr/YYYY-MM-DD-stack-decision.md (use _template.md)
        - Status `accepted`, registrar runtime + framework + deploy target
        - Vai ser a primeira coisa que agentes vão consultar
```

> **Dica:** depois de completar 1–3, rode um agente e peça "leia `CLAUDE.md` + `context/` e me diga 3 coisas sobre meu projeto". Se a resposta for genérica ou tiver `[PLACEHOLDER]`, faltou preencher algo.

### Detectando "stack-leak" (auditoria pós-adaptação)

Antes de considerar a adaptação concluída, rode este grep pra garantir que nenhum exemplo do template "vazou" como se fosse regra do seu projeto:

```bash
grep -rInIE "pnpm|biome|vitest|tsc --noEmit|tailwind|nestjs|supabase|playwright" \
  .agents/ context/ CLAUDE.md README.md
```

Resultado esperado: **só hits em blocos explicitamente marcados como `> Exemplo:` ou em arquivos `*.example`**. Qualquer hit em regra/instrução é stack-leak — generalize com placeholder ou substitua pela ferramenta da sua stack.

### Convenção visual de marcadores

Quando ler arquivos do template, esses padrões indicam o que adaptar:

| Marcador | Significado |
|---|---|
| `[NOME_DO_PROJETO]`, `[TEXTO]`, `[URL]` | **Placeholder obrigatório** — substitua antes de usar |
| `[TECH_*]`, `[FRAMEWORK_*]`, `[COMANDO_*]` | **Placeholder stack-específico** — preencha com a tecnologia escolhida |
| `<placeholder>` | **Trecho de código a substituir** — geralmente em scripts shell ou YAML |
| `> Exemplo:` ou bloco com "ex:" | **Ilustrativo** — não é prescrição, mostra como ficaria em uma stack específica |
| Sufixo `.example` (ex: `pre-push.example`) | **Arquivo modelo** — copie para nome sem sufixo e edite |
| `<!-- ADAPT: ... -->` | **Instrução inline** — explica o que preencher naquela linha |

---

## Estrutura de Pastas

```
.
├── CLAUDE.md                   # Entry point CANONICO para agentes
├── GEMINI.md                   # Stub -> CLAUDE.md
├── AGENTS.md                   # Stub -> CLAUDE.md (Codex/OpenCode)
├── README.md                   # Este arquivo (para humanos)
│
├── context/                    # Documentação de contexto (semântica por pasta)
│   ├── README.md               # Índice, guia de leitura, hierarquia de autoridade
│   ├── product/                # PRD, regras de negócio
│   │   ├── prd.md
│   │   └── business-rules.md
│   ├── architecture/           # Stack, engenharia, specs técnicas
│   │   ├── engineering.md
│   │   └── technical-specs.md
│   ├── domain/                 # Modelo de dados e glossário
│   │   ├── data-model.md
│   │   └── glossary.md
│   ├── guides/                 # Guias de uso, onboarding, gates
│   │   ├── user-guide.md
│   │   └── ci-and-gates.md     # Conceito de camadas de validação
│   ├── adr/                    # Architecture Decision Records (MADR 4.0)
│   │   ├── README.md           # Convenção + índice
│   │   └── _template.md        # Template de ADR
│   ├── quality/                # Métricas, cobertura (slot vazio)
│   ├── history/                # Roadmaps e análises passadas
│   ├── archive/                # Docs substituídos
│   └── providers/              # Guias por provedor de AI
│
├── .agents/                    # SSoT: governança + regras + skills (cross-provider)
│   ├── governance/workflow.md
│   ├── rules/
│   │   ├── README.md           # Convenção de rules
│   │   ├── 01-architecture.md  # Padrões de arquitetura (princípios)
│   │   ├── 02-pdi.md           # PDI, naming, error handling
│   │   ├── 03-testing.md       # Anti-skip + 8 vulnerabilidades
│   │   └── 04-pre-pr-checks.md # Lint/type-check/test antes do PR
│   └── skills/                 # Skills instaladas (SSoT, exposta via symlink)
│
├── .githooks/                  # Git hooks opt-in
│   └── pre-push.example        # Modelo de pre-push (renomear para 'pre-push' e adaptar)
│
├── .github/                    # Configurações GitHub
│   ├── workflows/
│   │   └── ci.example.yml      # Modelo de CI (renomear para 'ci.yml' e adaptar)
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── copilot-instructions.md
│
├── .claude/                    # Configurações Claude Code
├── .gemini/                    # Configurações Gemini
├── .cursor/                    # Configurações Cursor
├── .codex/                     # Configurações Codex (OpenAI)
├── .opencode/                  # Configurações OpenCode
│
└── .mcp.json.example           # Template de MCPs (copiar para .mcp.json)
```

---

## Guia de Leitura por Perfil

| Perfil | Caminho de Leitura | Objetivo |
|--------|-------------------|----------|
| **Adotando o template pela 1ª vez** | Este README (seção [Como Adaptar](#como-adaptar-este-template)) → checklist 10 itens | Configurar projeto novo |
| **Novo dev no projeto adaptado** | `context/README` → `product/prd` → `architecture/engineering` | Entender visão e arquitetura |
| **Desenvolvedor ativo** | `domain/data-model` → `domain/glossary` → `product/business-rules` → `adr/` | Implementar features |
| **LLM/Agente** | [`CLAUDE.md`](./CLAUDE.md) (entry point canônico — define a própria leitura obrigatória) | Executar tarefas |

---

## Regras de Ouro

1. **Single Source of Truth (SSoT)**: cada conceito tem **um** lugar canônico. Outros arquivos apenas referenciam.
2. **Terminologia Consistente**: defina termos em `context/domain/glossary.md` e use-os consistentemente.
3. **Documentação Viva**: atualize os docs **junto** com o código (mesmo PR, não depois).
4. **ADRs para decisões**: registre decisões arquiteturais em `context/adr/` antes de implementar.
5. **Agentes como Primeira Classe**: escreva docs pensando que um LLM vai ler — por isso `CLAUDE.md` é canônico e outros entry points são stubs.
6. **Stack-leak proibido**: nenhuma regra deve assumir stack específica. Exemplos ficam em blocos `> Exemplo:` ou arquivos `*.example`.

---

## Configuração por Ferramenta

Cada ferramenta tem sua estrutura de configuração. Veja detalhes em `context/providers/`.

| Ferramenta | Entry Point | Config | MCPs |
|------------|-------------|--------|------|
| Claude Code | `CLAUDE.md` (canônico) | `.claude/settings.json` | `.mcp.json` (raiz) |
| Gemini | `GEMINI.md` (stub) | `.gemini/settings.json` | Dentro do settings |
| Cursor | `.cursor/rules/*.mdc` | `.cursor/settings.json` | Via settings |
| Codex (OpenAI) | `AGENTS.md` (stub) | `.codex/config.toml` | Via config |
| OpenCode | `AGENTS.md` (stub) | `.opencode/settings.json` | Via config |
| GitHub Copilot | `.github/copilot-instructions.md` | VS Code settings | N/A |

> **Nota**: consulte `context/providers/` para guias detalhados de cada ferramenta.
>
> **Skills, MCPs e comandos ativos** vivem em [`CLAUDE.md`](./CLAUDE.md) — não duplique aqui.

---

## Contribuindo (para o próprio template)

Mudanças aqui afetam **todos os projetos futuros** que clonarem este template. Critérios:

- ✅ Padrão maduro em pelo menos 1 projeto real, com evidência (link pro repo ou ADR).
- ✅ Genérico o suficiente pra não amarrar a stack específica.
- ❌ Configuração que serve só pra um projeto (ex: comando `pnpm tsc` em rule).
- ❌ Skill stack-específica como default (lazy-trigger só, via frontmatter).

Workflow:

1. Fork este repositório
2. Crie uma branch (`git checkout -b feature/<descricao>`)
3. Commit suas mudanças (`git commit -m 'feat: adiciona X'`)
4. Push para a branch (`git push origin feature/<descricao>`)
5. Abra um Pull Request explicando: (a) o problema que resolve, (b) onde está maduro, (c) por que é multi-stack.

---

## Licença

CC BY 4.0 — veja [LICENSE](LICENSE) para detalhes.

---

**Versão do template**: 2.1.0 — filosofia DRY + clareza pedagógica de adaptação.
