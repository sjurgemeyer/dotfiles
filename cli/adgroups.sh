# ad* — Azure AD / Entra ID lookup helpers built on `az` + Microsoft Graph.
# Sourced (bash + zsh); every function is read-only apart from `adlogin`.
#
#   adlogin [-f]              Sign in with --allow-no-subscriptions (no Azure
#                             subscription needed for directory lookups). No-op
#                             if a session already exists; -f forces a re-login.
#   adwhoami                  Signed-in user: name, UPN, object id.
#
#   adgroups [who] [-i]       Every group <who> is a transitive member of
#                             (i.e. including nested groups), sorted by name.
#                             <who> defaults to you; -i/--ids adds the object id.
#   adingroup <pat> [who]     Does <who> belong to a group matching <pat>
#                             (case-insensitive substring)? Prints the matches;
#                             exit 0 if in at least one, 1 if none.
#
#   admembers <group> [-t] [-i]
#                             Members of <group> (display name or object id).
#                             -t/--transitive flattens nested groups; -i/--ids
#                             adds object ids. Nested groups show as "group" in
#                             the kind column.
#   adgroupfind <text>        Groups whose name contains <text>, with object ids.
#
#   aduser <who>              A user's display name, UPN, mail and object id.
#
# <who> is an email/UPN, an object id, or a display-name prefix ("Kyle Hath").
# A prefix that matches several people lists the candidates instead of guessing.
#
# Output is TSV when piped and column-aligned on a terminal, so
# `adgroups | grep -i snowflake` and `admembers foo | wc -l` both behave.

_AD_GRAPH=https://graph.microsoft.com/v1.0

# Guard used by every lookup: az present and a live session.
_ad_ready() {
  if ! command -v az >/dev/null 2>&1; then
    printf 'az not found — brew install azure-cli\n' >&2
    return 1
  fi
  if ! az account show --only-show-errors >/dev/null 2>&1; then
    printf 'Not signed in to Azure — run: adlogin\n' >&2
    return 1
  fi
}

# GET a Graph collection, following @odata.nextLink, emitting one compact JSON
# object per line. Extra args go to `az rest` (e.g. --headers for $search).
_ad_graph() {
  local url="$1" page
  shift
  while [ -n "$url" ]; do
    page=$(az rest --method GET --url "$url" --only-show-errors "$@") || return 1
    printf '%s' "$page" | jq -c '.value[]?'
    url=$(printf '%s' "$page" | jq -r '."@odata.nextLink" // empty')
  done
}

# Align columns for a human, stay TSV for a pipe.
_ad_table() {
  if [ -t 1 ]; then
    column -t -s "$(printf '\t')"
  else
    cat
  fi
}

_ad_is_guid() {
  [ ${#1} -eq 36 ] || return 1
  case "$1" in
    ????????-????-????-????-????????????) return 0 ;;
  esac
  return 1
}

# Resolve a person to an object id: object id > UPN/email > display-name prefix.
_ad_user_id() {
  local who="$1" id candidates count
  if _ad_is_guid "$who"; then
    printf '%s\n' "$who"
    return 0
  fi
  case "$who" in
    *@*)
      id=$(az ad user show --id "$who" --query id -o tsv --only-show-errors 2>/dev/null)
      if [ -z "$id" ]; then
        printf 'No user with UPN/email: %s\n' "$who" >&2
        return 1
      fi
      printf '%s\n' "$id"
      return 0
      ;;
  esac
  candidates=$(az ad user list --display-name "$who" \
    --query "[].{id:id,name:displayName,upn:userPrincipalName}" -o tsv \
    --only-show-errors 2>/dev/null)
  count=$(printf '%s' "$candidates" | grep -c . )
  if [ "$count" -eq 0 ]; then
    printf 'No user matching: %s\n' "$who" >&2
    return 1
  fi
  if [ "$count" -gt 1 ]; then
    printf 'Ambiguous — %s users match "%s":\n' "$count" "$who" >&2
    printf '%s\n' "$candidates" >&2
    return 1
  fi
  printf '%s\n' "$candidates" | cut -f1
}

# Resolve a group to an object id: object id > exact name > sole prefix match.
_ad_group_id() {
  local group="$1" candidates exact count
  if _ad_is_guid "$group"; then
    printf '%s\n' "$group"
    return 0
  fi
  candidates=$(az ad group list --display-name "$group" \
    --query "[].{id:id,name:displayName}" -o tsv --only-show-errors 2>/dev/null)
  exact=$(printf '%s\n' "$candidates" | awk -F'\t' -v g="$group" 'tolower($2)==tolower(g)')
  if [ -n "$exact" ]; then
    printf '%s\n' "$exact" | head -1 | cut -f1
    return 0
  fi
  count=$(printf '%s' "$candidates" | grep -c . )
  if [ "$count" -eq 0 ]; then
    printf 'No group matching: %s\n' "$group" >&2
    return 1
  fi
  if [ "$count" -gt 1 ]; then
    printf 'Ambiguous — %s groups match "%s":\n' "$count" "$group" >&2
    printf '%s\n' "$candidates" >&2
    return 1
  fi
  printf '%s\n' "$candidates" | cut -f1
}

adlogin() {
  if ! command -v az >/dev/null 2>&1; then
    printf 'az not found — brew install azure-cli\n' >&2
    return 1
  fi
  case "$1" in
    -f|--force) ;;
    *)
      if az account show --only-show-errors >/dev/null 2>&1; then
        printf 'Already signed in as %s\n' \
          "$(az account show --query user.name -o tsv --only-show-errors)"
        return 0
      fi
      ;;
  esac
  # --allow-no-subscriptions: directory reads don't need an Azure subscription.
  az login --allow-no-subscriptions --only-show-errors
}

adwhoami() {
  _ad_ready || return 1
  az ad signed-in-user show \
    --query "{name:displayName,upn:userPrincipalName,id:id}" -o tsv \
    --only-show-errors
}

aduser() {
  local who id
  _ad_ready || return 1
  who="$1"
  if [ -z "$who" ]; then
    printf 'usage: aduser <email|object-id|name-prefix>\n' >&2
    return 2
  fi
  id=$(_ad_user_id "$who") || return 1
  az ad user show --id "$id" \
    --query "{name:displayName,upn:userPrincipalName,mail:mail,id:id}" -o tsv \
    --only-show-errors
}

# Transitive group membership. Prints "name" (or "id<TAB>name" with -i).
adgroups() {
  local who="" show_ids=0 arg id url
  _ad_ready || return 1
  for arg in "$@"; do
    case "$arg" in
      -i|--ids) show_ids=1 ;;
      -*)
        printf 'usage: adgroups [who] [-i|--ids]\n' >&2
        return 2
        ;;
      *) who="$arg" ;;
    esac
  done

  if [ -z "$who" ] || [ "$who" = me ]; then
    url="$_AD_GRAPH/me/transitiveMemberOf/microsoft.graph.group"
  else
    id=$(_ad_user_id "$who") || return 1
    url="$_AD_GRAPH/users/$id/transitiveMemberOf/microsoft.graph.group"
  fi
  url="$url"'?$select=id,displayName&$top=999'

  if [ "$show_ids" -eq 1 ]; then
    _ad_graph "$url" | jq -r '[.id, .displayName] | @tsv' | sort -f -t"$(printf '\t')" -k2 | _ad_table
  else
    _ad_graph "$url" | jq -r '.displayName' | sort -f
  fi
}

# Membership check: exit 0 when <who> is in a group matching <pattern>.
adingroup() {
  local pattern="$1" who="$2" hits
  _ad_ready || return 1
  if [ -z "$pattern" ]; then
    printf 'usage: adingroup <pattern> [who]\n' >&2
    return 2
  fi
  hits=$(adgroups "$who" | grep -i -- "$pattern")
  if [ -z "$hits" ]; then
    printf 'no — no group matching "%s"\n' "$pattern"
    return 1
  fi
  printf 'yes — member of:\n'
  printf '%s\n' "$hits"
}

# Group members. Kind column is user/group/servicePrincipal etc.
admembers() {
  local group="" transitive=0 show_ids=0 arg id url edge fields
  _ad_ready || return 1
  for arg in "$@"; do
    case "$arg" in
      -t|--transitive) transitive=1 ;;
      -i|--ids) show_ids=1 ;;
      -*)
        printf 'usage: admembers <group> [-t|--transitive] [-i|--ids]\n' >&2
        return 2
        ;;
      *) group="$arg" ;;
    esac
  done
  if [ -z "$group" ]; then
    printf 'usage: admembers <group> [-t|--transitive] [-i|--ids]\n' >&2
    return 2
  fi

  id=$(_ad_group_id "$group") || return 1
  if [ "$transitive" -eq 1 ]; then
    edge=transitiveMembers
  else
    edge=members
  fi
  url="$_AD_GRAPH/groups/$id/$edge"'?$select=id,displayName,mail,userPrincipalName&$top=999'

  # @odata.type distinguishes users from nested groups in a mixed collection.
  if [ "$show_ids" -eq 1 ]; then
    fields='[.id, (."@odata.type" | sub("#microsoft.graph.";"")), .displayName, (.userPrincipalName // .mail // "")]'
  else
    fields='[(."@odata.type" | sub("#microsoft.graph.";"")), .displayName, (.userPrincipalName // .mail // "")]'
  fi
  _ad_graph "$url" | jq -r "$fields | @tsv" | sort -f | _ad_table
}

# Substring search over group names. $search needs ConsistencyLevel: eventual.
adgroupfind() {
  local text="$1" enc url out
  _ad_ready || return 1
  if [ -z "$text" ]; then
    printf 'usage: adgroupfind <text>\n' >&2
    return 2
  fi
  enc=$(jq -rn --arg s "displayName:$text" '$s|@uri')
  url="$_AD_GRAPH"'/groups?$search=%22'"$enc"'%22&$select=id,displayName,mail&$top=999'
  out=$(_ad_graph "$url" --headers ConsistencyLevel=eventual \
    | jq -r '[.id, .displayName, (.mail // "")] | @tsv' | sort -f -t"$(printf '\t')" -k2)
  if [ -z "$out" ]; then
    printf 'No group name contains: %s\n' "$text" >&2
    return 1
  fi
  printf '%s\n' "$out" | _ad_table
}
