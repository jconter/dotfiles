# git worktree helpers (gw* — see aliases below in .zshrc)

export WORKTREE_REPO="$HOME/projects/nt"
export WORKTREES_DIR="$HOME/projects/nt-worktrees"

# _gw_setup_dir <dir>: link in gitignored local config that `git worktree add`
# can't bring over (only tracks files git tracks), then approve direnv.
# .envrc-local holds NT_USER and other per-developer settings the checked-in
# .envrc reads via source_env_if_exists — symlinked so edits in the main repo
# apply to every worktree.
_gw_setup_dir() {
  local dir="$1"
  if [[ -f "$WORKTREE_REPO/.envrc-local" && ! -e "$dir/.envrc-local" ]]; then
    ln -s "$WORKTREE_REPO/.envrc-local" "$dir/.envrc-local"
  fi
  command -v direnv >/dev/null && (cd "$dir" && direnv allow)
}

# gwpr <pr-number>: check out a GitHub PR into its own worktree and cd in.
# Starts the worktree detached (no placeholder branch) and uses `gh pr checkout
# --force` so a stale local branch left over from a prior review (shared across
# worktrees via the same .git) gets reset to match the PR instead of failing.
gwpr() {
  local pr="$1"
  if [[ -z "$pr" ]]; then
    echo "usage: gwpr <pr-number>" >&2
    return 1
  fi
  local dir="$WORKTREES_DIR/pr-$pr"
  if [[ ! -d "$dir" ]]; then
    (cd "$WORKTREE_REPO" && git fetch origin && git worktree add --detach "$dir" origin/main) || return 1
  fi
  cd "$dir" || return 1
  _gw_setup_dir "$dir"
  gh pr checkout "$pr" --force
}

# gwnew <branch-name>: create a new worktree for your own branch off main and cd in.
gwnew() {
  local branch="$1"
  if [[ -z "$branch" ]]; then
    echo "usage: gwnew <branch-name>  (e.g. joshua/some-feature)" >&2
    return 1
  fi
  local dir="$WORKTREES_DIR/${branch//\//-}"
  (cd "$WORKTREE_REPO" && git worktree add "$dir" -b "$branch" main) || return 1
  cd "$dir" || return 1
  _gw_setup_dir "$dir"
}

# gwb <remote-branch>: check out an existing remote branch into its own worktree and cd in.
gwb() {
  local branch="$1"
  if [[ -z "$branch" ]]; then
    echo "usage: gwb <remote-branch-name>" >&2
    return 1
  fi
  local dir="$WORKTREES_DIR/${branch//\//-}"
  (cd "$WORKTREE_REPO" && git fetch origin "$branch" && git worktree add "$dir" "$branch") || return 1
  cd "$dir" || return 1
  _gw_setup_dir "$dir"
}

# gwl: list all worktrees off the main repo.
gwl() {
  (cd "$WORKTREE_REPO" && git worktree list)
}

# gwcd [name]: cd into a worktree by (partial, case-insensitive) name; no arg lists choices.
gwcd() {
  if [[ -z "$1" ]]; then
    ls "$WORKTREES_DIR"
    return 0
  fi
  local match
  match=$(ls "$WORKTREES_DIR" 2>/dev/null | grep -i "$1" | head -1)
  if [[ -z "$match" ]]; then
    echo "no worktree matching '$1' in $WORKTREES_DIR" >&2
    return 1
  fi
  cd "$WORKTREES_DIR/$match"
}

# gwrm <name>: remove a worktree dir and (safe-)delete its local branch.
gwrm() {
  local name="$1"
  if [[ -z "$name" ]]; then
    echo "usage: gwrm <worktree-dir-name>" >&2
    return 1
  fi
  local dir="$WORKTREES_DIR/$name"
  if [[ ! -d "$dir" ]]; then
    echo "no such worktree dir: $dir" >&2
    return 1
  fi
  local branch
  branch=$(cd "$dir" && git branch --show-current)
  (cd "$WORKTREE_REPO" && git worktree remove "$dir") || return 1
  if [[ -n "$branch" ]]; then
    (cd "$WORKTREE_REPO" && git branch -d "$branch") ||
      echo "branch '$branch' not fully merged; delete manually with 'git branch -D $branch' if you're sure" >&2
  fi
}
