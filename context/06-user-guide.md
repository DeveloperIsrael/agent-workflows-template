# Guia de Usuario & Fluxos de UI - [NOME_DO_PROJETO]

---

## Jornada Principal do Usuario

```mermaid
flowchart LR
    A[Passo 1] --> B[Passo 2]
    B --> C[Passo 3]
    C --> D[Passo 4]
    D --> E[Conclusao]
```

---

## Fluxo 1: [NOME_DO_FLUXO]

### Visao Geral

**Objetivo:** [O_QUE_O_USUARIO_QUER_ALCANÇAR]

**Pre-requisitos:**
- [PREREQ_1]
- [PREREQ_2]

### Passo a Passo

#### Passo 1: [ACAO]

**Acoes:**
- [ACAO_1]
- [ACAO_2]

**Resultado esperado:**
- [RESULTADO]

#### Passo 2: [ACAO]

**Acoes:**
- [ACAO_1]
- [ACAO_2]

**Resultado esperado:**
- [RESULTADO]

---

## Fluxo 2: [NOME_DO_FLUXO]

### Visao Geral

**Objetivo:** [O_QUE_O_USUARIO_QUER_ALCANÇAR]

### Passo a Passo

#### Passo 1: [ACAO]

**Acoes:**
- [ACAO_1]
- [ACAO_2]

---

## Estrutura da Interface

```
┌─────────────────────────────────────┐
│  [HEADER / NAVBAR]                  │
├──────────┬──────────────────────────┤
│          │                          │
│ [SIDEBAR]│     [AREA_PRINCIPAL]     │
│          │                          │
├──────────┴──────────────────────────┤
│  [FOOTER / STATUS BAR]              │
└─────────────────────────────────────┘
```

### Componentes Principais

| Componente | Localizacao | Funcao |
|------------|-------------|--------|
| [COMPONENTE_1] | [LOCALIZACAO] | [FUNCAO] |
| [COMPONENTE_2] | [LOCALIZACAO] | [FUNCAO] |
| [COMPONENTE_3] | [LOCALIZACAO] | [FUNCAO] |

---

## Estados da Interface

### Estados de Loading

| Situacao | Indicador | Comportamento |
|----------|-----------|---------------|
| [SITUACAO_1] | [INDICADOR] | [COMPORTAMENTO] |
| [SITUACAO_2] | [INDICADOR] | [COMPORTAMENTO] |

### Estados de Erro

| Erro | Mensagem | Acao do Usuario |
|------|----------|-----------------|
| [ERRO_1] | [MENSAGEM] | [ACAO] |
| [ERRO_2] | [MENSAGEM] | [ACAO] |

### Estados Vazios

| Tela | Mensagem | CTA |
|------|----------|-----|
| [TELA_1] | [MENSAGEM] | [BOTAO_ACAO] |
| [TELA_2] | [MENSAGEM] | [BOTAO_ACAO] |

---

## Atalhos de Teclado

| Atalho | Acao |
|--------|------|
| `Ctrl + [KEY]` | [ACAO] |
| `Ctrl + Shift + [KEY]` | [ACAO] |

---

## Formatos Aceitos

### Upload de Arquivos

| Tipo | Extensoes | Tamanho Max |
|------|-----------|-------------|
| [TIPO_1] | [EXTENSOES] | [TAMANHO] |
| [TIPO_2] | [EXTENSOES] | [TAMANHO] |

### Exportacao

| Formato | Conteudo |
|---------|----------|
| [FORMATO_1] | [CONTEUDO] |
| [FORMATO_2] | [CONTEUDO] |

---

## Referencias

- [01-product-prd.md](./01-product-prd.md) - Requisitos do produto
- [02-business-rules.md](./02-business-rules.md) - Regras que afetam a UI
