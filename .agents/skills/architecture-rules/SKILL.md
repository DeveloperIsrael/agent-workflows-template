---
name: architecture-rules
description: >
  Padroes de arquitetura e codigo stack-agnosticos: SoC, SRP, dependency
  direction, qualidade de codigo, gerenciamento de estado, modulos/componentes,
  camada de apresentacao, tratamento de erros, performance, testes, tamanho/
  complexidade, seguranca basica, anti-patterns e checklist de code review.
  Carrega no inicio de toda task de codigo e quando o user/contexto menciona
  "architecture", "arquitetura", "SoC", "SRP", "state", "estado", "error
  handling", "performance", "file size", "tamanho de arquivo", "antipattern".
  Complementa `clean-architecture`, `clean-code`, `solid-principles`.
license: MIT
allowed-tools: Read
---

# Padroes de Arquitetura e Codigo

> Regras **stack-agnosticas** que se aplicam a qualquer projeto (frontend,
> backend, CLI, mobile, qualquer linguagem). Regras especificas do **seu**
> projeto vao na secao [Project-Specific](#regras-project-specific) ao final.

---

## REGRA 1: Principios de Arquitetura

- **Separation of Concerns (SoC)**: logica de negocio, apresentacao e estado/persistencia desacoplados.
- **Single Responsibility Principle (SRP)**: cada arquivo/funcao/modulo tem **uma** responsabilidade clara.
- **Dependency Direction**: dependencias apontam para dentro (dominio nao depende de infraestrutura). Ver [`context/adr/`](../../../context/adr/) quando houver ADR formal.
- **Logica pesada fora da borda**: camadas de I/O (UI, HTTP handlers, CLI, controllers) nao contem regra de negocio — delegam para servicos/usecases/dominio.

## REGRA 2: Qualidade de Codigo

- **Tipagem**: habilite o modo mais estrito da linguagem. Prefira tipos especificos a escape hatches (`any`, `interface{}`, `dynamic`) — so em bordas, nunca como solucao de erro de tipo. Defina estruturas explicitas em vez de mapas genericos.
- **Nomenclatura**: convencao idiomatica da linguagem; nomes revelam intencao; abreviacoes so quando convencionais no dominio.
- **Documentacao**: APIs publicas com docstring/JSDoc/godoc. Documente o **porque**, nao o **o que**. README com setup/build/test.

## REGRA 3: Gerenciamento de Estado

> Qualquer camada de estado: store frontend, sessao, cache, banco, estado em memoria.

- Mutations em **um** lugar canonico (store/service/repository).
- Calculos derivados sao **selectors/computed** — nao recalcule em cada consumidor.
- Evite estado duplicado: defina a fonte de verdade.
- Estado minimo (derive o que puder); imutabilidade por padrao; separe estado de dominio de estado de UI.

## REGRA 4: Arquitetura de Modulos/Componentes

- Modulos pequenos e focados. Interface publica minima; internos encapsulados.
- Prefira **composicao** a **heranca**. Entradas/saidas tipadas/documentadas.
- Evite acoplamento por caminho (`../../../foo`); use barrels/pacotes nomeados.

## REGRA 5: Camada de Apresentacao (quando aplicavel)

- Apresentacao so renderiza/formata — **nao** contem regra de negocio.
- Layout responsivo por default; evite posicionamento absoluto para layouts.
- Siga o design system do projeto (tokens) e evite valores magicos inline.

## REGRA 6: Tratamento de Erros

- Falhe rapido: valide entradas no boundary do modulo.
- Erros sao **valores** ou **excecoes** — escolha a convencao da linguagem e use consistentemente.
- Nunca silencie erros (`catch` vazio, `except: pass`, `_ =`). Se intencional, comente o porque.
- Propague com contexto (operacao, IDs). Log no limite certo, nao no fundo da stack.
- UI/cliente recebe feedback claro — nunca stack traces crus pro usuario final.

## REGRA 7: Performance

- **Primeiro mensure, depois otimize.** Nao otimize sem profiler/benchmark.
- Evite O(n²) em hot paths e loops aninhados sobre dados grandes.
- Cache calculos caros com invalidacao clara. Pagination/streaming para datasets grandes.
- I/O em paralelo quando independente; sequencial so com dependencia real.

## REGRA 8: Testes

- **Piramide**: unit (logica pura, numerosos) → integration (modulos coordenando) → E2E/contract (fluxos criticos, poucos e estaveis).
- Teste **comportamento**, nao implementacao. Dados deterministicos; fixtures claras.
- Mocks no **limite** do sistema (APIs externas), nao no meio do dominio.
- Disciplina anti-skip + 8 vulnerabilidades: skill `testing-discipline`.

## REGRA 9: Tamanho e Complexidade

- **Arquivo**: alvo 300–500 linhas, limite rigido **800** (ajuste no seu projeto).
- **Funcao**: ate ~40 linhas, uma responsabilidade. **Parametros**: ate ~4 (acima, encapsule).
- **Aninhamento**: ate 3 niveis (early returns, funcoes auxiliares).
- Ultrapassou? Refatore extraindo — **nao** desabilite a regra.

## REGRA 10: Seguranca (principios basicos)

- Segredos nunca no codigo (env vars, secret managers).
- Validacao no boundary: todo input externo e untrusted.
- Least privilege; defense in depth (nao confie so em validacao frontend).
- Dependencias com CVE conhecido = risco ativo.

---

## Anti-Patterns — NUNCA Faca

1. Regra de negocio em camada de apresentacao (UI, controller, CLI handler)
2. Estado local para dado global por natureza
3. Mutacao direta em estruturas compartilhadas sem controle
4. Escape hatches de tipo (`any`, `interface{}`, `dynamic`) como solucao de preguica
5. Sync ad-hoc que deveria viver no store/repository (loops de effect pra manter estado coerente)
6. Arquivos gigantes (> limite acima)
7. Commits com `print`/`console.log`/`debugger` esquecidos
8. Secrets, tokens ou credenciais em codigo
9. Catch silencioso que esconde erro
10. Copy-paste de logica — extraia (DRY) quando a abstracao e clara

---

## Checklist de Code Review

- [ ] Convencoes de nomenclatura da linguagem
- [ ] Funcoes/modulos com proposito unico e claro
- [ ] Tipos/contratos explicitos e precisos
- [ ] Erros tratados e propagados com contexto
- [ ] Sem codigo morto, comentado ou de debug
- [ ] Testes cobrem caminho feliz + casos de borda
- [ ] Performance considerada (sem O(n²) em hot paths, sem N+1)
- [ ] Seguranca considerada (input validado, sem secrets, least privilege)
- [ ] Documentacao atualizada (docstrings, READMEs, ADRs se decisao arquitetural)
- [ ] Arquivo/funcao dentro dos limites de tamanho

---

## Regras Project-Specific

<!-- ADAPT: adicione aqui as regras de arquitetura especificas DESTE projeto
     (ex.: store escolhido, framework de UI, padroes de modulo, limite de
     tamanho ajustado, paginas read-only). Mantenha numeradas a partir de REGRA 11.
     Se preencher, atualize a `description` do frontmatter com os novos gatilhos. -->

_(Nenhuma ainda — preencha ao adotar o template.)_
