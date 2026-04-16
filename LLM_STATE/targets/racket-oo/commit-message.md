Research FFI surface elimination, triage Modaliser-Racket bugs

Completed comprehensive audit of every FFI concept leaking into app
code across all 4 sample apps. Produced a 3-phase solution architecture
(borrow-objc-object + type-aware delegates → contract cleanup → app
rewrite). Closed the "Selector parameter contracts" stretch task as
subsumed (string args, not sel?). Added three new Bug Fixes tasks from
Modaliser-Racket real-world usage (nsscreen.rkt duplicate symbol,
nsmenuitem.rkt class-method misclassification, wkwebview.rkt missing
inherited method) and two core backlog tasks (make-objc-block #f
handling, is_definition() guard audit).
