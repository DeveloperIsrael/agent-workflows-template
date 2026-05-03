---
trigger: always_on
---

# Padroes de Arquitetura e Codigo

> Regras **stack-agnosticas** que se aplicam a qualquer projeto (frontend, backend, CLI, mobile, qualquer linguagem).
>
> **Stack-specifics** (React, TypeScript, Python, Go, etc.) vivem em rules numeradas adicionais (`02-*.md`, `03-*.md`) — veja [`README.md`](./README.md).

---

## REGRA 1: Principios de Arquitetura

- **Separation of Concerns (SoC)**: logica de negocio, apresentacao e gerenciamento de estado/persistencia desacoplados.
- **Single Responsibility Principle (SRP)**: cada arquivo, funcao ou modulo tem **uma** responsabilidade clara.
- **Dependency Direction**: dependencias apontam para dentro (dominio nao depende de infraestrutura). Ver [`../../context/adr/`](../../context/adr/) quando houver um ADR formal de arquitetura.
- **Logica pesada fora da borda**: camadas de I/O (UI, HTTP handlers, CLI, controllers) nao contem regra de negocio — delegam para servicos/usecases/dominio.

---

## REGRA 2: Qualidade de Codigo

### Tipagem e correcao
- Em linguagens tipadas, habilite o modo mais estrito disponivel.
- Prefira tipos especificos a tipos "escape hatch" (`any`, `unknown`, `interface{}`, `dynamic`, `void*`, etc.) — use apenas em bordas, nunca como solucao para erros de tipo.
- Defina estruturas de dados explicitas (types/structs/classes/records) em vez de mapas genericos.

### Nomenclatura
- Siga a convencao idiomatica da linguagem (camelCase em JS/Java, snake_case em Python/Rust, PascalCase para tipos, UPPER_SNAKE_CASE para constantes, etc.).
- Nomes revelam intencao. Abreviacoes apenas quando convencionais no dominio.

### Documentacao
- Funcoes/APIs publicas tem docstring/JSDoc/godoc no formato da linguagem.
- Documente o **porque**, nao o **o que** — o codigo ja mostra o que faz.
- README com instrucoes de setup, build, test.

---

## REGRA 3: Gerenciamento de Estado

> Aplica-se a qualquer camada de estado: store frontend, sessao, cache, banco de dados, estado em memoria de CLI.

### Onde estado vive
- Mutations acontecem em **um** lugar canonico (store, service, repository).
- Calculos derivados sao **selectors/computed** — nao recalcule em cada consumidor.
- Evite estado duplicado: se dois lugares tem a mesma informacao, defina a fonte de verdade.

### Boas praticas
- Estado minimo: derive o que puder.
- Imutabilidade por padrao; mutacoes explicitas e localizadas.
- Separe estado de dominio (regra de negocio) de estado de UI (loading, modal aberto, etc.).

---

## REGRA 4: Arquitetura de Modulos/Componentes

- Modulos pequenos e focados em um proposito.
- Interface publica minima; internos encapsulados.
- Prefira **composicao** a **heranca**.
- Entradas e saidas tipadas/documentadas.
- Evite acoplamento por caminho (`../../../foo/bar`); use barrels/pacotes/modulos nomeados.

---

## REGRA 5: Camada de Apresentacao (quando aplicavel)

> UI (web, mobile, TUI) ou qualquer camada de output para humanos.

- Apresentacao so renderiza/formata — **nao** contem regra de negocio.
- Layout responsivo/adaptativo por default; evite posicionamento absoluto para layouts.
- Siga o design system do projeto (tokens de cor, espaco, tipografia) e evite valores magicos inline.

---

## REGRA 6: Tratamento de Erros

- Falhe rapido e claro: valide entradas no limite (boundary) do modulo.
- Erros sao **valores** ou **excecoes** — escolha a convencao da linguagem e use consistentemente. Nao misture ad-hoc.
- Nunca silencie erros (`catch` vazio, `except: pass`, `_ =`). Se for intencional, comente o porque.
- Propague com contexto; adicione info (operacao, IDs) ao envolver/relancar.
- Log no limite certo: onde a acao ainda tem contexto; nao no fundo da stack.
- UI/cliente recebe feedback claro — nunca stack traces crus para o usuario final.

---

## REGRA 7: Performance

- **Primeiro mensure, depois otimize.** Nao otimize sem profiler/benchmark.
- Evite complexidades desnecessarias (O(n²) em hot paths, loops aninhados sobre dados grandes).
- Cache calculos caros com invalidacao clara.
- Use pagination/streaming para datasets grandes.
- I/O em paralelo quando independente; sequencial so quando houver dependencia real.

---

## REGRA 8: Testes

### Piramide
- **Unit**: logica pura, utils, dominio — rapidos e numerosos.
- **Integration**: modulos coordenando (DB, APIs internas) — medio volume.
- **E2E / contract / system**: fluxos criticos ponta a ponta — poucos, estaveis.

### Boas praticas
- Teste **comportamento**, nao implementacao — resistencia a refactor.
- Dados de teste deterministicos; fixtures claras.
- Mocks no **limite** do sistema (APIs externas), nao no meio do dominio.
- Testes rapidos e isolados; falhas sao reproduziveis.

---

## REGRA 9: Tamanho e Complexidade

- **Arquivo**: alvo 300–500 linhas, limite rigido **800**.
- **Funcao**: alvo ate ~40 linhas, uma unica responsabilidade.
- **Parametros**: ate ~4; acima disso, encapsule em objeto/record.
- **Aninhamento**: ate 3 niveis; extraia se passar disso (early returns, funcoes auxiliares).

Quando ultrapassar: refatore extraindo funcoes/modulos — **nao** desabilite a regra.

---

## REGRA 10: Seguranca (principios basicos)

- **Segredos nunca no codigo**: use env vars, secret managers.
- **Validacao no boundary**: todo input externo e untrusted ate prova em contrario.
- **Least privilege**: processos/usuarios/tokens com o minimo de permissao necessaria.
- **Defense in depth**: nao confie em uma unica camada (ex.: nao so validacao frontend).
- **Atualizacoes**: dependencias com CVE conhecidos = risco ativo.

---

## Anti-Patterns — NUNCA Faca

1. Regra de negocio em camada de apresentacao (UI, controller, CLI handler)
2. Estado local para dado que e global por natureza
3. Mutacao direta em estruturas compartilhadas (sem controle)
4. Escape hatches de tipo (`any`, `interface{}`, `dynamic`) como solucao de preguica
5. Sync ad-hoc que deveria viver no store/repository (loops de `effect` para manter estado coerente)
6. Arquivos gigantes (> limite acima)
7. Commits com `print`/`console.log`/`debugger`/breakpoints esquecidos
8. Secrets, tokens ou credenciais em codigo
9. Catch silencioso que esconde erro
10. Copy-paste de logica — extraia para um lugar so (DRY) quando a abstracao e clara

---

## Checklist de Code Review

- [ ] Codigo segue convencoes de nomenclatura da linguagem
- [ ] Funcoes/modulos tem proposito unico e claro
- [ ] Tipos/contratos explicitos e precisos
- [ ] Erros tratados e propagados com contexto
- [ ] Sem codigo morto, comentado ou de debug
- [ ] Testes cobrem caminho feliz + casos de borda importantes
- [ ] Performance considerada (sem O(n²) em hot paths, sem N+1)
- [ ] Seguranca considerada (input validado, sem secrets, least privilege)
- [ ] Documentacao atualizada (docstrings, READMEs, ADRs se decisao arquitetural)
- [ ] Arquivo/funcao dentro dos limites de tamanho
