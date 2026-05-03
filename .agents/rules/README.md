# Rules de Codigo

Regras de codigo que todos os agentes devem seguir ao trabalhar neste projeto. Cada arquivo cobre **um topico** e e numerado para ordem de leitura determinista.

## Convencao

```
NN-topico.md
```

- `NN` — prefixo numerico (01, 02, 03...) para leitura ordenada
- `topico` — kebab-case, curto e descritivo

Exemplos:
- `01-architecture.md` — padroes de arquitetura (camadas, SoC, SRP)
- `02-testing.md` — estrategia de testes (quando, como, coverage)
- `03-typescript.md` — convencoes especificas de TS
- `04-security.md` — secrets, input validation, etc.

## Quando criar uma nova rule

- Existe um padrao que se repete e precisa ser cumprido por todos
- Voce se pegou repetindo a mesma orientacao em reviews
- Uma decisao arquitetural do ADR tem implicacoes de codigo diarias

**Nao crie** rule para: preferencias pessoais, detalhes que o linter ja pega, convencoes de um unico modulo.

## Relacao com ADRs

- **ADR** (`context/adr/`): _por que_ de uma decisao (registro historico)
- **Rule** (`.agent/rules/`): _como aplicar_ no dia a dia (guia pratico)

Uma decisao pode gerar um ADR **e** uma rule: o ADR explica o motivo, a rule o operacionaliza.

## Escopo

Rules aqui sao **cross-provider**. Configuracoes especificas de provider (permissions do Claude, hooks do Gemini) ficam em `.claude/`, `.gemini/`, etc.

---

## Rules Ativas

- [`01-architecture.md`](./01-architecture.md) — padroes de arquitetura
