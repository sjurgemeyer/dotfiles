def build_status:
  if (.statusCheckRollup == null) or ((.statusCheckRollup | length) == 0) then "NONE"
  else
    ([.statusCheckRollup[] |
      if .__typename == "CheckRun" then
        if .status != "COMPLETED" then "PENDING"
        elif (.conclusion == "SUCCESS" or .conclusion == "NEUTRAL" or .conclusion == "SKIPPED") then "SUCCESS"
        elif (.conclusion == "FAILURE" or .conclusion == "CANCELLED" or .conclusion == "TIMED_OUT" or .conclusion == "ACTION_REQUIRED" or .conclusion == "STARTUP_FAILURE") then "FAILURE"
        else "PENDING"
        end
      else
        if .state == "SUCCESS" then "SUCCESS"
        elif (.state == "FAILURE" or .state == "ERROR") then "FAILURE"
        else "PENDING"
        end
      end
    ]) as $s
    | if any($s[]; . == "FAILURE") then "FAILURE"
      elif any($s[]; . == "PENDING") then "PENDING"
      else "SUCCESS"
      end
  end;

.[] | [$short_repo, .title, .author.login, .updatedAt, .reviewDecision, build_status, .mergeStateStatus, .baseRefName, .baseRefOid, (.isDraft | tostring), .url] | join("")
