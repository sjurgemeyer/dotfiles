#!/bin/sh
# Fetches open PRs across subscribed repos and prints formatted, colored rows.
# Usage: prreview-fetch.sh <w-updated> <w-repo> <w-status> <w-submitter> <w-title>
prreview_dir="$HOME/projects/dotfiles/cli/prreview"
. "$prreview_dir/prreview-config.sh"

w_upd="${1:-16}"
w_repo="${2:-35}"
w_status="${3:-8}"
w_sub="${4:-18}"
w_title="${5:-60}"

branch_tip_cache=$(mktemp)
trap 'rm -f "$branch_tip_cache"' EXIT

if [ -n "$PRREVIEW_REPOS" ]; then
  printf '%s\n' $PRREVIEW_REPOS
else
  gh api --paginate user/subscriptions --jq '.[].full_name'
fi | \
  while read -r repo; do
    short_repo="${repo#*/}"
    gh pr list --repo "$repo" --state=open \
      --json title,updatedAt,author,url,reviewDecision,isDraft,statusCheckRollup,mergeStateStatus,baseRefName,baseRefOid | \
    jq --arg short_repo "$short_repo" -r -f "$prreview_dir/build-status.jq" | \
    while IFS=$'\x1f' read -r f_repo f_title f_author f_updated f_review f_build f_merge f_baseref f_baseoid f_url; do
      if [ "$PRREVIEW_SHOW_UPTODATE" = "true" ]; then
        cache_key=$(printf '%s\t%s\t' "$repo" "$f_baseref")
        cache_line=$(grep -F -m1 "$cache_key" "$branch_tip_cache" 2>/dev/null)
        if [ -n "$cache_line" ]; then
          tip="${cache_line##*$'\t'}"
        else
          tip=$(gh api "repos/${repo}/git/ref/heads/${f_baseref}" --jq .object.sha 2>/dev/null)
          printf '%s%s\n' "$cache_key" "$tip" >> "$branch_tip_cache"
        fi
        if [ "$f_merge" = "DIRTY" ] || { [ -n "$tip" ] && [ "$tip" != "$f_baseoid" ]; }; then
          behind_flag="BEHIND"
        else
          behind_flag="CLEAN"
        fi
      else
        behind_flag="CLEAN"
      fi

      if [ "$PRREVIEW_SHOW_UNRESOLVED" = "true" ]; then
        owner="${repo%%/*}"
        pr_number="${f_url##*/}"
        unresolved=$(gh api graphql -F query="@$prreview_dir/unresolved-threads.graphql" \
          -F owner="$owner" -F name="$short_repo" -F number="$pr_number" \
          --jq 'any(.data.repository.pullRequest.reviewThreads.nodes[]; .isResolved == false)' 2>/dev/null)
        [ -n "$unresolved" ] || unresolved="false"
      else
        unresolved="false"
      fi

      printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$f_repo" "$f_title" "$f_author" "$f_updated" "$f_review" "$f_build" "$behind_flag" "$unresolved" "$f_url"
    done
  done | sort -t$'\t' -k4 -r | \
  awk -F'\t' -v w_upd="$w_upd" -v w_repo="$w_repo" -v w_status="$w_status" -v w_sub="$w_sub" -v w_title="$w_title" \
      -v show_build="$PRREVIEW_SHOW_BUILD" -v show_approval="$PRREVIEW_SHOW_APPROVAL" \
      -v show_uptodate="$PRREVIEW_SHOW_UPTODATE" -v show_unresolved="$PRREVIEW_SHOW_UNRESOLVED" \
      -f "$prreview_dir/format-rows.awk"
