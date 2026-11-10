# ai-engineering

A personal zero-to-hero guide for AI-assisted development with Claude Code. Markdown only, no code to build.

## Structure
- `README.md`: roadmap and entry point
- `levels/0N-*.md`: one level each (L0–L7). Every level ends with a "Level up when…" checklist.
- `practices/`: cross-cutting topics (best practices, security, context & cost, anti-patterns, staying sharp)
- `templates/`: copy-paste files for Go projects (CLAUDE.md, spec, plan, checklist, .claude/, GitHub workflow)

## Conventions
- English. Practical and concise: tables and checklists over prose.
- Diagrams: Mermaid. Key workflows also get an ASCII fallback.
- Code examples in Go. Running example project: `shorty` (URL-shortener API).
- Claude Code features change fast: prefer stable concepts, and say "check `--help`/docs" for version-specific flags.
- When adding a practice, link it from `practices/best-practices.md` and the relevant level.
- Keep relative links working when moving files.
