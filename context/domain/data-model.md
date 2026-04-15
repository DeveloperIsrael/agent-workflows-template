# Data Model - [NOME_DO_PROJETO]

> **Arquivo Canonico**: Este documento e a fonte unica de verdade para entidades, schemas e relacionamentos.

---

## Visao Geral da Arquitetura

> Descreva a arquitetura de dados do projeto.

```mermaid
erDiagram
    [ENTIDADE_1] ||--o{ [ENTIDADE_2] : "possui"
    [ENTIDADE_2] ||--o{ [ENTIDADE_3] : "contem"
    [ENTIDADE_1] ||--|| [ENTIDADE_4] : "referencia"
```

---

## 1. Entidades Principais

### 1.1. [ENTIDADE_1]

**Descricao:** [DESCRICAO_DA_ENTIDADE]

| Campo | Tipo | Obrigatorio | Descricao |
|-------|------|-------------|-----------|
| `id` | string (UUID) | Sim | Identificador unico |
| `[campo_2]` | [tipo] | [Sim/Nao] | [descricao] |
| `[campo_3]` | [tipo] | [Sim/Nao] | [descricao] |
| `created_at` | datetime | Sim | Data de criacao |
| `updated_at` | datetime | Sim | Data de atualizacao |

**Relacionamentos:**
- Possui N `[ENTIDADE_2]`
- Pertence a 1 `[ENTIDADE_4]`

### 1.2. [ENTIDADE_2]

**Descricao:** [DESCRICAO_DA_ENTIDADE]

| Campo | Tipo | Obrigatorio | Descricao |
|-------|------|-------------|-----------|
| `id` | string (UUID) | Sim | Identificador unico |
| `[campo_2]` | [tipo] | [Sim/Nao] | [descricao] |
| `[campo_3]` | [tipo] | [Sim/Nao] | [descricao] |

---

## 2. Tipos Enumerados (Enums)

### [ENUM_NAME]

| Valor | Descricao |
|-------|-----------|
| `[VALOR_1]` | [descricao] |
| `[VALOR_2]` | [descricao] |
| `[VALOR_3]` | [descricao] |

---

## 3. Schemas / DTOs

### Request: Create[Entidade]

```typescript
interface Create[Entidade]Request {
  [campo_1]: string;
  [campo_2]: number;
  [campo_3]?: string; // opcional
}
```

### Response: [Entidade]Response

```typescript
interface [Entidade]Response {
  id: string;
  [campo_1]: string;
  [campo_2]: number;
  created_at: string; // ISO 8601
}
```

---

## 4. Indices e Constraints

| Tabela | Indice/Constraint | Campos | Tipo |
|--------|-------------------|--------|------|
| [TABELA_1] | `pk_[tabela]` | `id` | Primary Key |
| [TABELA_1] | `idx_[tabela]_[campo]` | `[campo]` | Index |
| [TABELA_1] | `fk_[tabela]_[ref]` | `[campo_fk]` | Foreign Key |

---

## 5. Migracoes

> Liste as migracoes aplicadas ou planejadas.

| Versao | Data | Descricao |
|--------|------|-----------|
| v001 | [DATA] | Criacao inicial das tabelas |
| v002 | [DATA] | [DESCRICAO] |

---

## Referencias

- [05-dictionary.md](./05-dictionary.md) - Definicao de termos
- [04-engineering.md](./04-engineering.md) - Decisoes arquiteturais (ADRs)
