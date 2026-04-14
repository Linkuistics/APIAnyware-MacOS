Read {{DEV_ROOT}}/LLM_CONTEXT/backlog-plan.md — focus on Phase 4 COMPACT and the Memory style subsection.

Read {{PLAN}}/memory.md.

Rewrite memory.md in place applying the style rules:
- Assertion register, not narrative
- One fact per entry
- Cross-reference, don't re-explain
- Headings ~8 words max, subject-predicate form
- Drop session numbers, dates, "previously"/"initially"/"after the fix"
- Drop retired/falsified hypotheses unless they encode a live "X does not work" fact
- Keep load-bearing numbers; drop narrative decoration

This is lossless — preserve every live fact, only rewrite prose. Reflect is
the lossy-pruning phase; compact is not.

Write `triage` to {{PLAN}}/phase.md. Then stop.
