BEGIN {
  e = sprintf("%c", 27);
  cyan   = e "[36m";
  white  = e "[37m";
  yellow = e "[33m";
  green  = e "[32m";
  red    = e "[31m";
  gray   = e "[90m";
  teal   = e "[38;5;30m";
  reset  = e "[0m";
  hollow      = "\xe2\x97\x8b";
  build_pass  = "\xef\x81\x98";
  build_warn  = "\xef\x81\xb1";
  build_fail  = "\xef\x94\xb0";
  appr_pass   = "\xef\x81\x9d";
  appr_warn   = "\xee\xa9\xac";
  appr_fail   = "\xee\xaa\x87";
  utd_yes     = "\xef\x80\x97";
  utd_no      = "\xef\x80\x97";
  comment_icon = "\xf3\xb0\xbb\x9e";
  draft_icon  = "\xef\x81\x80";
  link_close = e "]8;;" e "\\";
}
function linkify_brackets(str,   result, remaining, m, bracket_text, inner, replacement) {
  result = "";
  remaining = str;
  while ((m = match(remaining, /\[[^]]*\]/)) > 0) {
    result = result substr(remaining, 1, m - 1);
    bracket_text = substr(remaining, m, RLENGTH);
    inner = substr(bracket_text, 2, length(bracket_text) - 2);
    if (jira_url != "" && inner ~ /^[A-Za-z]+-[0-9]+$/) {
      replacement = e "]8;;" jira_url "/" inner e "\\" teal bracket_text white link_close;
    } else {
      replacement = teal bracket_text white;
    }
    result = result replacement;
    remaining = substr(remaining, m + RLENGTH);
  }
  return result remaining;
}
{
  gsub("T"," ",$4); gsub("Z","",$4);

  if ($6 == "SUCCESS")      { bcolor = green;  bglyph = build_pass }
  else if ($6 == "FAILURE") { bcolor = red;    bglyph = build_fail }
  else if ($6 == "PENDING") { bcolor = yellow; bglyph = build_warn }
  else                       { bcolor = gray;   bglyph = hollow }

  if ($5 == "APPROVED")               { acolor = green;  aglyph = appr_pass }
  else if ($5 == "CHANGES_REQUESTED") { acolor = red;    aglyph = appr_fail }
  else if ($5 == "REVIEW_REQUIRED")   { acolor = yellow; aglyph = appr_warn }
  else                                 { acolor = gray;   aglyph = hollow }

  if ($7 == "BEHIND") { ucolor = yellow; uglyph = utd_no } else { ucolor = green; uglyph = utd_yes }

  is_draft = ($9 == "true");

  status_field = "";
  svislen = 0;
  if (show_build == "true") {
    status_field = status_field bcolor bglyph reset;
    svislen = svislen + 1;
  }
  if (show_approval == "true") {
    if (svislen > 0) { status_field = status_field " "; svislen = svislen + 1 }
    status_field = status_field acolor aglyph reset;
    svislen = svislen + 1;
  }
  if (show_uptodate == "true") {
    if (svislen > 0) { status_field = status_field " "; svislen = svislen + 1 }
    status_field = status_field ucolor uglyph reset;
    svislen = svislen + 1;
  }
  if (show_unresolved == "true" && $8 == "true") {
    if (svislen > 0) { status_field = status_field " "; svislen = svislen + 1 }
    status_field = status_field yellow comment_icon reset;
    svislen = svislen + 1;
  }
  if (is_draft) {
    if (svislen > 0) { status_field = status_field " "; svislen = svislen + 1 }
    status_field = status_field gray draft_icon reset;
    svislen = svislen + 1;
  }
  spad = w_status - svislen;
  if (spad < 0) spad = 0;
  status_field = status_field sprintf("%*s", spad, "");

  pr_number = $10;
  sub(/.*\/pull\//, "", pr_number);
  full_title = "PR#" pr_number ": " $2;
  title = substr(full_title,1,w_title);
  pad = w_title - length(title);
  if (pad < 0) pad = 0;
  title = linkify_brackets(title);
  pr_link_open = e "]8;;" $10 e "\\";
  gsub(/^PR#[0-9]+/, pr_link_open teal "&" white link_close, title);
  title = title sprintf("%*s", pad, "");
  printf "%s%-*s%s  %s%-*s%s  %s  %s%-*s%s  %s%s%s\t%s\n",
    green,  w_upd,   substr($4,1,w_upd),   reset,
    cyan,   w_repo,  substr($1,1,w_repo),  reset,
    status_field,
    yellow, w_sub,   substr($3,1,w_sub),   reset,
    white,  title,   reset,
    $10
}
