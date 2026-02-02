# Dicionario de Termos & Entidades - [NOME_DO_PROJETO]

> Este documento define a terminologia oficial do projeto. Use estes termos consistentemente em codigo, documentacao e comunicacao.

---

## Hierarquia de Entidades

```mermaid
graph TD
    [ENTIDADE_RAIZ] --> [ENTIDADE_FILHA_1]
    [ENTIDADE_RAIZ] --> [ENTIDADE_FILHA_2]
    [ENTIDADE_FILHA_1] --> [ENTIDADE_NETA_1]
```

---

## Glossario de Entidades

### 1. [ENTIDADE_1]

**Definicao:** [DEFINICAO_CLARA_E_CONCISA]

**Responsabilidade:** [O_QUE_ESTA_ENTIDADE_FAZ]

**Propriedades Chave:**
- `[propriedade_1]`: [descricao]
- `[propriedade_2]`: [descricao]

**Relacionamentos:**
- Possui N `[ENTIDADE_RELACIONADA]`
- Pertence a `[ENTIDADE_PAI]`

**Sinonimos NAO usar:**
- ~~[termo_errado_1]~~
- ~~[termo_errado_2]~~

---

### 2. [ENTIDADE_2]

**Definicao:** [DEFINICAO_CLARA_E_CONCISA]

**Responsabilidade:** [O_QUE_ESTA_ENTIDADE_FAZ]

**Propriedades Chave:**
- `[propriedade_1]`: [descricao]
- `[propriedade_2]`: [descricao]

---

### 3. [ENTIDADE_3]

**Definicao:** [DEFINICAO_CLARA_E_CONCISA]

**Responsabilidade:** [O_QUE_ESTA_ENTIDADE_FAZ]

---

## Glossario de Termos de Negocio

| Termo | Definicao | Exemplo |
|-------|-----------|---------|
| [TERMO_1] | [DEFINICAO] | [EXEMPLO] |
| [TERMO_2] | [DEFINICAO] | [EXEMPLO] |
| [TERMO_3] | [DEFINICAO] | [EXEMPLO] |

---

## Termos Tecnicos

| Termo | Definicao | Contexto |
|-------|-----------|----------|
| [TERMO_1] | [DEFINICAO] | [ONDE_E_USADO] |
| [TERMO_2] | [DEFINICAO] | [ONDE_E_USADO] |

---

## Abreviacoes

| Sigla | Significado |
|-------|-------------|
| [SIGLA_1] | [SIGNIFICADO] |
| [SIGLA_2] | [SIGNIFICADO] |

---

## Padroes de Nomenclatura

### Nomes de Entidades/Eventos

- **Padrao:** `snake_case`
- **Estrutura:** `verbo_objeto`
- **Exemplos:**
  - `user_created`
  - `order_completed`
  - `payment_failed`

### Nomes de Campos

- **Padrao:** `snake_case`
- **Regras:**
  - Sem abreviacoes
  - Nomes descritivos
  - Prefixo por contexto quando necessario
- **Exemplos:**
  - `user_email` (correto)
  - `usrEmail` (incorreto)
  - `transaction_id` (correto)
  - `txn_id` (incorreto)

---

## Anti-Patterns de Nomenclatura

| NAO usar | Usar | Razao |
|----------|------|-------|
| [termo_errado] | [termo_correto] | [razao] |
| [termo_errado] | [termo_correto] | [razao] |

---

## Referencias

- [03-data-model.md](./03-data-model.md) - Definicao tecnica das entidades
- [02-business-rules.md](./02-business-rules.md) - Regras que governam as entidades
