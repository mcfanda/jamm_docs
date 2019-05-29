
source("R/constants.R")
source("R/functions.R")
source("R/secrets.R")

gh_whoami(.token=API_TOKEN)
get_commits()
write_commits2()

query<-paste0("/repos/:owner/:repo/branches")
MODULE_REPO
MODULE_REPO_OWNER
API_TOKEN
gh(query, owner = MODULE_REPO_OWNER, repo = MODULE_REPO,.limit=Inf,.token=API_TOKEN)
gh(query, owner = MODULE_REPO_OWNER, repo = MODULE_REPO,.limit=Inf,.token=API_TOKEN)

