# The `~/projects` convention

agent-home keeps every piece of work in its own folder under `~/projects/<name>`,
and gives each one its own [beads](https://github.com/gastownhall/beads) database
for task tracking:

```
~/projects/
  my-app/
    .beads/        # this project's task tracker (bd)
    ...
  another-thing/
    .beads/
    ...
```

Why per-project beads:

- Tasks, dependencies, and history travel **with the repo** (the `.beads/issues.jsonl`
  is committed; the working Dolt db is local).
- `bd ready` in any project shows only that project's actionable work.
- A separate **inbox** project (the `inbox` plugin) is where loose ideas land before
  they're planned into a real project.

Start a new project:

```bash
mkdir -p ~/projects/my-app && cd ~/projects/my-app
bd init
```
