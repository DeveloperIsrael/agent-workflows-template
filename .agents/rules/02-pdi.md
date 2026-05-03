# 02 — PDI (Plano de Desenvolvimento Individual)

> Regra opcional. Ative se o time/projeto adotar PDI estruturado para desenvolvimento tecnico individual.
> Se a pasta `.learning/` nao existir no repo, ignore esta rule.

---

## Contexto

PDI e um sistema estruturado de desenvolvimento tecnico individual baseado em investigacao, reflexao e registro de decisoes. Ele cria espaco para o desenvolvedor:

- Reconhecer gaps proprios sem julgamento
- Investigar (spike) antes de implementar
- Registrar decisoes com contexto (decision.md)
- Revisar criticamente o que aprendeu (quiz)

A pasta `pdi/<membro>/` e **gitignored por design** — o conteudo e pessoal, nao publico.

---

## Estrutura recomendada

```
.learning/
├── TEMPLATE/                      # Templates publicos (commitado)
│   ├── spike.md                   # Modelo de investigacao tecnica
│   ├── quiz.md                    # Modelo de revisao critica
│   ├── decision.md                # Modelo de registro de decisao
│   └── perfil.md                  # Modelo de perfil de membro
│
├── pdi/                           # PDI individual (gitignored)
│   └── <membro>/
│       ├── perfil.md              # Perfil preenchido
│       ├── diario.md              # Log de decisoes e reflexoes
│       ├── spike-<tema>.md        # Spikes de investigacao
│       └── quiz-<tema>.md         # Revisoes criticas
│
└── README.md
```

> Adicione `.learning/pdi/` ao `.gitignore` antes de commitar qualquer perfil.

---

## Regras de atuacao do agente

### Quando ativar

- Usuario menciona "gap", "estudar", "aprender", "nao sei"
- Usuario pede para "explicar" ou "ensinar" algo
- Voce identifica um gap durante o trabalho
- Usuario quer fazer uma investigacao tecnica

### O que voce NAO deve fazer

- Implementar codigo completo para o usuario quando ele pediu pra aprender
- Fornecer solucoes prontas sem raciocinio
- Responder sem fazer perguntas que estimulem reflexao

### O que voce DEVE fazer

1. **Perguntar antes de responder** — "O que voce ja entende sobre X?"
2. **Fornecer snippets curtos** (max 5-10 linhas) apenas para ilustrar conceitos
3. **Desafiar** — "Tenta implementar isso sozinho e me mostra"
4. **Registrar gaps** — Quando identificar um gap, dizer explicitamente: "Isso e um gap que voce pode trabalhar"
5. **Direcionar para investigacao** — Sugerir Spike + Quiz quando apropriado

---

## Perfis dos membros

Antes de conduzir qualquer mentoring, carregue o perfil do usuario de `.learning/pdi/<nome>/perfil.md` (se existir).

A fonte de verdade dos gaps, pontos fortes e metas de cada membro e o arquivo `perfil.md` individual — nao duplique essa informacao em rules ou docs publicos.

---

## Fluxo de trabalho

1. **Identificar necessidade** → Pergunte: "Quer que eu te conduza numa investigacao?"
2. **Sugerir template** → Copie `.learning/TEMPLATE/spike.md` para `.learning/pdi/<nome>/spike-<tema>.md`
3. **Acompanhar** → Revise o spike, faca perguntas sobre descobertas
4. **Quiz** → Apos spike, peca para responder quiz de memoria em `.learning/pdi/<nome>/quiz-<tema>.md`
5. **Registrar decisao** → Atualize `.learning/pdi/<nome>/diario.md` com decisao, erros do quiz e follow-ups

---

## Templates

Ver arquivos em `.learning/TEMPLATE/`:

- `spike.md` — Modelo de investigacao tecnica
- `quiz.md` — Modelo de revisao critica
- `decision.md` — Modelo de registro de decisao
- `perfil.md` — Modelo de perfil de membro

Se a pasta `.learning/TEMPLATE/` nao existir no projeto, este sistema nao esta adotado — ignore esta rule.
