---
name: update-docs
description: >
  Use ao concluir qualquer task significativa em qualquer projeto: nova feature,
  decisao arquitetural, mudanca de stack, novo schema de DB, novo endpoint, ou
  refatoracao relevante. Garante que a documentacao do projeto (README, context/,
  ADRs, regras de agente) fique em sincronia com o codigo antes do commit.
  Skill agnostica de stack — descobre a estrutura de docs do repositorio atual e
  respeita perfil declarativo opcional em <repo>/.agents/update-docs.profile.yaml.
---

# Update Docs — Documentation Sync Workflow

Ao encerrar qualquer task nao trivial, execute este fluxo antes de considerar o trabalho concluido. A skill **descobre** a estrutura de doc do projeto atual em vez de assumir caminhos fixos.

---

## Principio central

**So atualize o que mudou.** Identifique a secao afetada, edite apenas ela, mantenha o resto intacto. Nao reescreva documentos inteiros. Nao crie arquivos novos sem perguntar.

---

## Passo 1 — Discovery (escaneia o projeto atual)

Rode estes checks no diretorio raiz do repo. Tudo opcional — degrada graciosamente se nao encontrar.

```bash
# Entry points de agente
ls CLAUDE.md AGENTS.md GEMINI.md 2>/dev/null
ls .cursor/rules/*.mdc .github/copilot-instructions.md 2>/dev/null

# Doc humano
ls README.md CONTRIBUTING.md 2>/dev/null

# Diretorios de contexto
for d in context docs documentation wiki; do [ -d "$d" ] && echo "FOUND $d/" && ls "$d/" 2>/dev/null; done

# Diretorios de ADR (ordem de busca — primeiro encontrado vence)
for d in context/adr docs/adr docs/architecture/decisions architecture/decisions adr; do
  [ -d "$d" ] && echo "ADR_DIR $d" && break
done

# Regras de codigo
for d in .agents/rules .cursor/rules .windsurf/rules; do [ -d "$d" ] && echo "RULES $d/"; done

# Manifestos de stack (apenas para informar categorias relevantes)
ls package.json pyproject.toml Cargo.toml go.mod 2>/dev/null
```

Anote o inventario em memoria. Esse inventario e a base do mapeamento no Passo 3.

---

## Passo 1.5 — Carrega perfil do projeto (se existir)

Procure nesta ordem; primeiro encontrado vence:

```bash
for p in .agents/update-docs.profile.yaml .agent/update-docs.profile.yaml update-docs.profile.yaml; do
  [ -f "$p" ] && echo "PROFILE $p" && cat "$p" && break
done
```

**Se o perfil existe**: ele declara `mappings`, `adr.dir`, `disabled_categories`, `notes`. Faca merge com o discovery — em conflito, o perfil vence (declaracao explicita do projeto). Pule discovery exaustivo se o perfil ja cobre as categorias da task.

**Se nao existe**: siga apenas com o discovery.

Schema do perfil esta no anexo no fim deste arquivo.

---

## Passo 2 — Categorize a mudanca

Em qual destas categorias cai a task que acabou? Multipla escolha permitida.

| Categoria | Quando aplicar |
|---|---|
| `architecture` | Decisao tecnica nao trivial, novo padrao, mudanca de boundary |
| `stack` | Nova dependencia principal, troca de framework, atualizacao major |
| `schema` | Nova tabela/coluna, migration, mudanca de estrutura de dados |
| `domain` | Nova entidade, novo termo, regra de negocio, escopo de produto |
| `code_pattern` | Nova convencao, anti-pattern descoberto, refatoracao guidance |
| `setup` | Novos scripts, pre-requisitos, variaveis de ambiente, build |
| `api` | Novo endpoint, contrato externo, breaking change publico |

Categorias do perfil em `disabled_categories` devem ser ignoradas.

---

## Passo 3 — Mapeamento dinamico

Para cada categoria selecionada, cruze com o inventario (discovery ∪ perfil) e produza uma lista enxuta `arquivo → motivo`. Exemplo de output esperado:

> Categoria: `schema`
> Candidatos:
> - `<arquivo-detectado-em-context-ou-docs>` (encontrado, contem secao "Schema") — atualizar
> - `<arquivo-de-dominio-detectado>` — verificar se nova entidade entra aqui
> - `README.md` (encontrado) — so se afeta setup

**Se um candidato esperado nao existe** (ex.: categoria `architecture` mas sem ADR dir):
- **Nao crie silenciosamente.**
- Sugira ao usuario: *"Sem diretorio ADR detectado. Quer invocar a skill `adr-skill` para bootstrappar?"*

**Se o perfil tem `notes`**, exiba-as antes do checklist final.

---

## Delegacao

Em vez de reimplementar fluxos que outras skills ja fazem, **delegue**:

| Situacao | Skill a invocar |
|---|---|
| Decisao arquitetural nao trivial (com alternativas reais) | `adr-skill` |
| Commit pos-update | `git-commit` |

---

## Anti-patterns (NUNCA faca)

1. Reescrever um documento inteiro quando so uma secao mudou.
2. Criar arquivo novo sem perguntar — sempre confirme com o usuario.
3. Duplicar a mesma info entre `README.md` e `CLAUDE.md` (entry points de agente).
4. Editar `AGENTS.md` ou `GEMINI.md` quando o projeto trata `CLAUDE.md` como canonical (ver perfil ou checar se sao stubs).
5. Assumir uma stack especifica nos exemplos — use sempre o que o discovery encontrou.

---

## Checklist final

Antes de marcar a task como concluida:

- [ ] Listei o que mudou (de fato, nao em abstrato)
- [ ] Mapeei cada mudanca para arquivo(s) **detectados** no inventario
- [ ] Atualizei **apenas as secoes afetadas** — nada de rewrite

Opcional: rode `git diff` nos docs alterados antes do commit para validar que so o necessario mudou.

---

## Anexo — Schema do `update-docs.profile.yaml`

Coloque em `<repo>/.agents/update-docs.profile.yaml` para acelerar o discovery e declarar convencoes do projeto.

```yaml
# Perfil opcional para a skill global update-docs
version: 1

# Mapa categoria → arquivos que devem ser revisados ao concluir uma task daquele tipo.
# Caminhos relativos a raiz do repositorio. Skill faz merge com discovery automatico;
# em conflito, o perfil vence (declaracao explicita do projeto).
mappings:
  architecture:
    - <path/para/doc/de/arquitetura.md>
  stack:
    - README.md
  schema:
    - <path/para/doc/de/schema.md>
  domain:
    - <path/para/doc/de/dominio.md>
  code_pattern:
    - CLAUDE.md
  setup:
    - README.md
  api:
    - <path/para/doc/de/api.md>

# Onde criar ADRs neste projeto. Skill delega para adr-skill respeitando este path.
adr:
  dir: <path/para/adr>
  template: <path/para/template-de-adr.md>
  naming: "YYYY-MM-DD-titulo-curto.md"

# Categorias que este projeto explicitamente ignora (skill nao sugere mais).
disabled_categories: []

# Notas livres exibidas pela skill antes do checklist final.
notes:
  - "Convencao especifica deste projeto que a skill nao tem como inferir."
```

Campos suportados:
- `mappings` (obrigatorio, parcial OK) — chaves sao as categorias do Passo 2.
- `adr.dir` / `adr.template` / `adr.naming` (opcional) — usado quando delega para `adr-skill`.
- `disabled_categories` (opcional) — lista de categorias a ignorar.
- `notes` (opcional) — strings exibidas antes do checklist.

Sem perfil, a skill funciona apenas com discovery — perfil e otimizacao, nao requisito.
