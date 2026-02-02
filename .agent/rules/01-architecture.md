---
trigger: always_on
---

# Padroes de Arquitetura e Codigo

> Este documento define os padroes de arquitetura e codigo que devem ser seguidos em todo o projeto.
> Adapte as regras conforme seu stack tecnologico.

---

## REGRA 1: Principios de Arquitetura (SoC & SRP)

- **Separation of Concerns (SoC)**: Mantenha logica de negocio, interface (UI) e gerenciamento de estado desacoplados.
- **Single Responsibility Principle (SRP)**: Cada arquivo, funcao ou componente deve possuir apenas uma responsabilidade clara.
- **Separacao de Logica Pesada**: Logicas complexas devem ser extraidas para hooks/services/utils, deixando componentes UI focados em renderizacao.

---

## REGRA 2: Qualidade de Codigo

### TypeScript/JavaScript
- Use TypeScript com modo `strict` habilitado
- Evite `any` - prefira `unknown` quando tipo e desconhecido
- Defina interfaces/types para estruturas de dados

### Nomenclatura
- **Variaveis/Funcoes**: `camelCase`
- **Classes/Types/Interfaces**: `PascalCase`
- **Constantes**: `UPPER_SNAKE_CASE`
- **Arquivos**: `kebab-case.ts` ou `PascalCase.tsx` (componentes)

### Documentacao
- Funcoes publicas devem ter JSDoc/TSDoc
- Logica complexa deve ter comentarios explicativos
- README atualizado com instrucoes de setup

---

## REGRA 3: Arquitetura de Estado

> Adapte conforme sua biblioteca de estado (Redux, Zustand, MobX, Context API, etc.)

### Responsabilidades do State Management:
- Mutations de estado
- Logica de validacao
- Chamadas de API e gestao de loading/error
- Calculos derivados (computed/selectors)

### Responsabilidades dos Componentes:
- Renderizacao UI apenas
- Event handlers que delegam ao state
- Logica de apresentacao trivial (formatacao, classes CSS)

### Boas Praticas:
- Use seletores especificos ao inves de selecionar estado inteiro
- Evite estado local para dados que deveriam ser globais
- Mantenha estado normalizado quando possivel

---

## REGRA 4: Arquitetura de Componentes

### Estrutura de Componentes
```
ComponentName/
├── index.ts          # Re-export
├── ComponentName.tsx # Componente principal
├── ComponentName.test.tsx # Testes
├── ComponentName.styles.ts # Estilos (se aplicavel)
└── components/       # Sub-componentes
```

### Principios
- Componentes pequenos e focados (< 200 linhas)
- Props bem tipadas com interfaces
- Evite props drilling - use Context ou state management
- Prefira composicao sobre heranca

---

## REGRA 5: Estilizacao

> Adapte conforme sua abordagem (Tailwind, CSS Modules, Styled Components, etc.)

### Com Tailwind CSS
- Use classes utilitarias diretamente
- Extraia componentes para padroes repetidos
- Use `@apply` com moderacao

### Principios Gerais
- Evite estilos inline
- Mantenha consistencia no design system
- Use variaveis CSS para cores/espacamentos
- Mobile-first quando aplicavel

---

## REGRA 6: Arquitetura de Layout (Flexbox/Grid)

- **Flexbox ao inves de Absolute Positioning** para layouts
- Deixe o navegador calcular espacos automaticamente
- Evite margins/widths hardcoded que dependem de outros componentes

### Anti-patterns
```css
/* EVITE */
position: absolute;
left: 60px; /* Depende da largura do sidebar */
width: calc(100% - 60px);

/* PREFIRA */
display: flex;
flex: 1;
```

---

## REGRA 7: Tratamento de Erros

- Use `try/catch` em operacoes assincronas
- Propague erros para camada de UI via estado
- Nunca silencie erros com `catch` vazio
- Log erros para debugging (console ou servico de monitoramento)
- Exiba feedback visual para o usuario

---

## REGRA 8: Performance

### React/Frontend
- Use `React.memo()` para componentes que re-renderizam frequentemente
- Evite funcoes inline em props (use `useCallback`)
- Lazy load componentes pesados
- Otimize imagens e assets

### Geral
- Evite loops aninhados O(n²)
- Cache resultados de calculos caros
- Use paginacao para listas grandes

---

## REGRA 9: Testes

### Niveis de Teste
- **Unit**: Funcoes puras, utils, helpers
- **Integration**: Componentes com estado
- **E2E**: Fluxos criticos do usuario

### Boas Praticas
- Teste comportamento, nao implementacao
- Use mocks para dependencias externas
- Mantenha testes rapidos e isolados

---

## REGRA 10: Tamanho de Arquivos

- **Limite Sugerido**: 300-500 linhas por arquivo
- **Limite Rigido**: 800 linhas maximo

### Estrategias de Refatoracao
- Extrair logica para hooks customizados
- Quebrar componentes grandes em sub-componentes
- Dividir stores/slices por dominio

---

## Anti-Patterns - NUNCA Faca

1. Logica de negocio em componentes UI
2. `useState` para estado que deveria ser global
3. Mutacao direta de estado (use immer ou spread)
4. `any` como solucao para erros de tipo
5. `useEffect` para sincronizacao que deveria estar no store
6. Arquivos com +800 linhas
7. Commits com `console.log` de debug
8. Secrets/credentials em codigo

---

## Checklist de Code Review

- [ ] Codigo segue padroes de nomenclatura
- [ ] Funcoes tem proposito unico e claro
- [ ] Tipos estao bem definidos
- [ ] Erros sao tratados adequadamente
- [ ] Sem codigo morto/comentado
- [ ] Testes cobrem casos importantes
- [ ] Performance considerada
- [ ] Seguranca considerada
