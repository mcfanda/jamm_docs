# folders should be absolute or relative to the docssource folder
# do not use the trailing slash
MODULE_FOLDER="../../jamm"
SOURCE_FOLDER="pubs"
TARGET_FOLDER="../jamovi-amm.github.io"
DATALINK<-"https://raw.githubusercontent.com/mcfanda/gamlj_docs/master/data"

# These handle the release notes from commits
MODULE_REPO="jamm"
MODULE_REPO_OWNER="jamovi-amm"
FIRST_VERSION="version.1.0.1"
BANNED_COMMITS=list("initialize","fix commits","remove some marks","1.5.0")
BANNED_COMMITS_GREP=list("^#","^!","^Merge branch","spelling")

