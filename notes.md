gotta start somewhere

collect 2 timestamps on buildkite-agent: PR-merged and deployed to production
write a cron job that goes through each repo and collects
- merged_at times for each PR (state=all, merged_at is not null)
- deploy_at times for each PR
(linked by commit)

how to update the spreadsheet:
base-url: https://sheets.googleapis.com
POST <base-url>/v4/spreadsheets/{spreadsheetId}:batchUpdate
GET /v4/spreadsheets
