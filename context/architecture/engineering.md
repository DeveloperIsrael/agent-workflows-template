# Arquitetura Tecnica - [NOME_DO_PROJETO]

---

## Stack Overview

```mermaid
graph TB
    subgraph Frontend
        [FRAMEWORK_1]
        [FRAMEWORK_2]
        [FRAMEWORK_3]
    end

    subgraph Backend
        [TECH_1]
        [TECH_2]
    end

    subgraph Infrastructure
        [INFRA_1]
        [INFRA_2]
    end

    Frontend --> Backend
    Backend --> Infrastructure
```

---

## Stack Tecnologico

### Frontend

| Tecnologia | Proposito | Versao |
|------------|-----------|--------|
| [TECH_1] | [PROPOSITO] | [VERSAO] |
| [TECH_2] | [PROPOSITO] | [VERSAO] |
| [TECH_3] | [PROPOSITO] | [VERSAO] |

### Backend

| Tecnologia | Proposito | Versao |
|------------|-----------|--------|
| [TECH_1] | [PROPOSITO] | [VERSAO] |
| [TECH_2] | [PROPOSITO] | [VERSAO] |

### Infrastructure

| Servico | Proposito |
|---------|-----------|
| [SERVICO_1] | [PROPOSITO] |
| [SERVICO_2] | [PROPOSITO] |

---

## Dependencias Principais

```json
{
  "[dependencia_1]": "^[versao]",
  "[dependencia_2]": "^[versao]",
  "[dependencia_3]": "^[versao]"
}
```

---

## Estrutura de Pastas

> Os blocos abaixo sao **exemplos por stack**. Apague os que nao se aplicam e mantenha apenas a estrutura real do seu projeto. Em template recem-clonado (greenfield), preencha conforme a stack escolhida.

### Exemplo — Frontend React/Next

```
src/
├── components/       # Componentes UI
│   ├── common/       # Componentes compartilhados
│   └── features/     # Componentes por feature
├── pages/            # Paginas/rotas
├── hooks/            # Custom hooks
├── services/         # Chamadas de API
├── stores/           # Gerenciamento de estado
├── utils/            # Funcoes utilitarias
├── types/            # Tipos TypeScript
└── assets/           # Arquivos estaticos
```

### Exemplo — Backend Python (FastAPI / Flask)

```
app/
├── api/              # Routers / endpoints
├── services/         # Logica de dominio
├── repositories/     # Acesso a dados
├── models/           # Pydantic / SQLAlchemy models
├── schemas/          # DTOs de entrada/saida
├── core/             # Config, security, dependencies
└── tests/
```

### Exemplo — Backend Go

```
.
├── cmd/<binario>/    # Entry points (main.go por binario)
├── internal/         # Codigo nao-exportavel (handlers, services, repos)
├── pkg/              # Codigo reutilizavel (se intencionalmente publico)
├── api/              # OpenAPI / proto / schemas
└── deploy/           # Manifests, Dockerfile, IaC
```

### Exemplo — Backend Java (Spring Boot)

```
src/
├── main/
│   ├── java/com/<org>/<projeto>/
│   │   ├── controller/
│   │   ├── service/
│   │   ├── repository/
│   │   ├── domain/        # Entities / value objects
│   │   └── config/
│   └── resources/         # application.yml, migrations
└── test/
```

---

## Architecture Decision Records (ADRs)

### ADR-001: [TITULO_DA_DECISAO]

**Status:** Aceito

**Contexto:** [CONTEXTO_DO_PROBLEMA]

**Decisao:** [DECISAO_TOMADA]

**Justificativa:**
- [RAZAO_1]
- [RAZAO_2]
- [RAZAO_3]

**Consequencias:**
- [CONSEQUENCIA_1]
- [CONSEQUENCIA_2]

---

### ADR-002: [TITULO_DA_DECISAO]

**Status:** Aceito

**Contexto:** [CONTEXTO_DO_PROBLEMA]

**Decisao:** [DECISAO_TOMADA]

**Justificativa:**
- [RAZAO_1]
- [RAZAO_2]

**Consequencias:**
- [CONSEQUENCIA_1]
- [CONSEQUENCIA_2]

---

## Build & Deploy

```bash
# Development
[COMANDO_DEV]

# Production build
[COMANDO_BUILD]

# Deploy
[COMANDO_DEPLOY]

# Tests
[COMANDO_TESTS]
```

---

## Ambientes

| Ambiente | URL | Branch |
|----------|-----|--------|
| Development | [URL] | `develop` |
| Staging | [URL] | `staging` |
| Production | [URL] | `main` |

---

## Padroes de Desenvolvimento

> Para regras detalhadas de codigo, consulte [`.agents/rules/01-architecture.md`](../.agents/rules/01-architecture.md).

### Convencoes de Codigo

- **Linguagem:** [LINGUAGEM] com [STRICT_MODE]
- **Estilo:** [GUIA_DE_ESTILO]
- **Linting:** [FERRAMENTA_LINT]
- **Formatacao:** [FERRAMENTA_FORMAT]

### Git Workflow

```
feat(scope): descricao da feature
fix(scope): descricao do fix
docs(scope): atualizacao de documentacao
refactor(scope): refatoracao sem mudanca de comportamento
test(scope): adicao ou correcao de testes
```

---

## Monitoramento & Observabilidade

| Ferramenta | Proposito |
|------------|-----------|
| [FERRAMENTA_1] | [PROPOSITO] |
| [FERRAMENTA_2] | [PROPOSITO] |

---

## Referencias

- [03-data-model.md](./03-data-model.md) - Modelo de dados
- [.agents/rules/](../.agents/rules/) - Regras de codigo
