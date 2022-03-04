# folders should be absolute or relative to the docssource folder
# do not use the trailing slash
MODULE_NAME="jAMM"
MODULE_FOLDER="../../jamm"
SOURCE_FOLDER="pubs"
TARGET_FOLDER="../jamovi-amm.github.io"
DATALINK<-"https://raw.githubusercontent.com/mcfanda/gamlj_docs/master/data"

# These handle the release notes from commits
MODULE_REPO="jamm"
MODULE_REPO_OWNER="jamovi-amm"
FIRST_VERSION="Version.1.0.1"
BANNED_COMMITS=list("initialize","fix commits","remove some marks")
BANNED_COMMITS_GREP=list("^#","^!","^Merge branch","spelling","1.0.2")

