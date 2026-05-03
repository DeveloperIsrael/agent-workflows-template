<!--
PR template canonico do agent-workflows-template.
Preserve as secoes — sao usadas por humanos e agentes na revisao.
Apague linhas-guia e tags HTML antes de enviar.
-->

## Summary

<!-- 1–3 linhas: o que mudou e por que. -->

## Changes

<!-- Bullets file-by-file ou modulo-por-modulo. Liste o "o que" — o "por que" vai no Summary. -->

- `path/to/file`: …
- `path/to/file`: …

## Why

<!-- O motivo da mudanca: bug, decisao arquitetural, requisito de produto, dividia tecnica, refactor.
     Se for decisao arquitetural, linke o ADR (`context/adr/YYYY-MM-DD-slug.md`). -->

## Test plan

<!-- Como reproduzir e validar. Use checkboxes para o reviewer marcar. -->

- [ ] `<comando 1>` (lint / type-check / unit / integration / E2E)
- [ ] `<cenario manual>` (passo-a-passo)
- [ ] Smoke do caminho feliz na UI/API afetada

## Risk & rollback

<!-- Blast radius (so este modulo? cross-cutting? schema?), feature flag, plano de revert. -->

- Impacto: …
- Como reverter: `git revert <sha>` / desligar flag `<nome>` / migration `<down>`

## Review checklist

- [ ] Sem `any` (ou escape hatch da linguagem) introduzido
- [ ] Tipos exhaustivos onde aplicavel (discriminated unions cobertos)
- [ ] Testes passam local (`<comando do projeto>`)
- [ ] Sem skip novo de teste (ou justificado com SKIP-REASON + OWNER + DEADLINE — ver `.agents/rules/03-testing.md`)
- [ ] Documentacao atualizada (`update-docs` skill se mudanca significativa)
- [ ] ADR criado/atualizado se decisao arquitetural (`context/adr/`)
- [ ] Sem segredos, tokens ou URLs internas hardcoded
- [ ] Sem `console.log` / `print` / `debugger` esquecidos

## Related

<!-- Links: issue, ADR, PR dependente, doc externa. -->

- Issue: …
- ADR: …
