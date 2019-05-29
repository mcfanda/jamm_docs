
source("R/constants.R")
source("R/functions.R")
source("R/secrets.R")

write_commits2()
query<-paste0("/repos/:owner/:repo/branches")
MODULE_REPO
API_TOKEN
gh(query, owner = MODULE_REPO_OWNER, repo = MODULE_REPO,.limit=Inf,.token=API_TOKEN)
