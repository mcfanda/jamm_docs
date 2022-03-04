library(yaml)
library(rmarkdown)
library(Rsearchable)
library(gh)


datafile<-function(name,file) {
  if (length(grep(":/",file,fixed = T))==0)
    file<-paste0(DATALINK,"/",file)
  paste0('[',name,'](',file,')')
}

keywords<-function(key) {
  span<-'<span class="keywords"> <span class="keytitle"> keywords </span>'
  paste(span,key,"</span>")
}

jamovi<-function() {
  paste0('<span class="jamovi">jamovi</span>')
}

module<-paste0('<span class="modulename">',MODULE_NAME,'</span>')



version<-function(ver) {
    paste('<span class="version"> <span class="versiontitle"> ',MODULE_NAME,' version ≥ </span> ',ver,' </span>')
}

draft<-'<span class="draft"> Draft version, mistakes may be around </span>'

incomplete<-'<span class="incomplete"> Work in progress: incomplete version </span>'

pic<-function(name) paste('<img src="',name,'" class="img-responsive" alt="">')


get_files<-function() {
  lf<-list.files(pattern = ".Rmd",full.names = F)
  files<-list()
  for (f in lf) {
   name<-gsub(".Rmd","",f)
   record<-yaml_front_matter(f)
   record$filename<-name
   files[[name]]<-record
  }
  files
}

get_pages<-function(nickname=NULL,topic=NULL,category=NULL) {
  
  criteria=c()
  if (!is.null(topic))
    criteria["topic"]<-topic
  if (!is.null(category))
    criteria["category"]<-category
  if (!is.null(nickname))
    criteria["nickname"]<-nickname
  
  files<-get_files()
  sfiles<-searchable(files)  
  res<-lookup.searchable(sfiles,criteria)
  res
}

link_pages<-function(nickname=NULL,topic=NULL,category=NULL) {
  
 pages<-get_pages(nickname,topic,category)
 a<-""
 for (p in pages) {
   link<-paste0(p$filename,".html")
   a<-paste(a,paste0('<a href="',link,'">',p$title,'</a>'))
 }
 return(a)  
}
  
list_pages<-function(nickname=NULL,topic=NULL,category=NULL) {
  pages<-get_pages(nickname,topic,category)
  ul<-'<ul>\n'
  a<-""
  for (p in pages) {
    link<-paste0(p$filename,".html")
    b<-paste0('<li><a href="',link,'">',p$title,'</a></li>\n')
    a<-paste(a,b)
  }
  a<-paste(ul,a,'</ul>\n')
  return(a)
}

include_examples<-function(topic)  {
  return(list_pages(topic=topic,category = "example"))
}

issues<-function() {
  a<-'<h1>Comments?</h1>\n'
  a<-paste(a,'<p>Got comments, issues or spotted a bug? Please open an issue on
      <a href=" https://github.com/mcfanda/gamlj/issues ">
      GAMLj at github“</a> or <a href="mailto:mcfanda@gmail.com">send me an email</a></p>
  ')
  return(a)
  
}

test<-function() return("xx xxxxxx x")


write_commits<-function() {
  wd<-getwd()
  setwd(MODULE_FOLDER)
### With dates ...  a<-system("git log --pretty=format:'%cd %s' --date=short",intern = T)
  a<-system("git log --pretty=format:'%s' --date=short",intern = T)
  test<-grep("initialize",a,fixed=T)
  if (length(test)==0)
      return(FALSE)
  coms<-a[1:(grep("initialize",a,fixed=T)-1)]
  coms<-rev(unique(coms))
  sel<-list()
  j<-1
  version="none"
  versions<-character()
  for (i in seq_along(coms)) {
    test<-grep("!",coms[[i]],fixed=T)
    if (length(test)>0) next()
    test<-grep("Merge",coms[[i]],fixed=T)
    if (length(test)>0) next()
    test<-grep("§",coms[[i]],fixed=T)
    if (length(test)>0) coms[[i]]<-paste("<b>",coms[[i]],"</b>")
    
    test<-grep("#",coms[[i]],fixed=T)
    if (length(test)>0) {
      version<-strsplit(coms[[i]],"#",fixed = T)[[1]][2]
      versions<-c(versions,version)
      next()
    }
    sel[[j]]<-c(coms[[i]],version)
    j<-j+1
  }
  sel<-rev(sel)
  versions<-rev(versions)
  coms<-do.call("rbind",sel)
  for (i in seq_along(versions)) {
    rel<-""
    if (i==1) rel<-"(future)"
    if (i==2) rel<-"(current)"
    
    cat(paste("#",versions[i],rel,"\n\n"))
    cs<-coms[coms[,2]==versions[i],1]
    for (j in cs)
      cat(paste("*",j,"\n\n"))
  }
  setwd(wd)
  #coms
}


get_commits<-function() {
  
  query<-paste0("/repos/:owner/:repo/branches")
  vers<-gh::gh(query, owner = MODULE_REPO_OWNER, repo = MODULE_REPO,.limit=Inf,.token=API_TOKEN)
  vernames<-sapply(vers,function(a) a$name)
  ord<-order(vernames)
  vernames<-vernames[ord]
  vers<-vers[ord]
  vernames<-rev(vernames)
  rvers<-rev(vers)
  nvers<-1:(which(vernames==FIRST_VERSION)+1)
  rvers<-rvers[nvers]
  vers<-rev(rvers)
  vernames<-sapply(vers,function(a) a$name)
  r<-vers[[1]]
  query<-paste0("/repos/:owner/:repo/commits")
  coms<-gh::gh(query,sha=r$name, owner = MODULE_REPO_OWNER, repo = MODULE_REPO,.limit=Inf,.token=API_TOKEN)
  date<-coms[[1]]$commit$author$date
  vers<-vers[2:length(vernames)]
  j<-1
  r<-vers[[2]]
  results<-list()
  for (r in vers) {
    query<-paste0("/repos/:owner/:repo/commits")
    coms<-gh::gh(query, sha=r$name, since=date,owner = MODULE_REPO_OWNER, repo = MODULE_REPO,.limit=Inf,.token=API_TOKEN)
    if (length(coms)==0)
      next()
    for (com in coms) {
      results[[j]]<-c(sha=com$sha,msg=com$commit$message,version=r$name)
      j<-j+1
    }
    date<-coms[[1]]$commit$author$date
  }
  data<-data.frame(do.call("rbind",results),stringsAsFactors = FALSE)
  data<-data[!duplicated(data$sha),]
  data<-data[!duplicated(data$msg),]
  data  
}


write_commits2<-function(commits) {
  sel<-list()
  j<-1
  for (i in 1:dim(commits)[1]) {
    msg<-trimws(commits[i,"msg"])
    gonext=FALSE
    for (rule in BANNED_COMMITS) {
      if (msg==rule)
        gonext=TRUE
    }
    for (rule in BANNED_COMMITS_GREP) {
      if (length(grep(rule,msg)))
        gonext=TRUE
    }
    
    if (gonext)
      next()
    test<-grep("§",msg,fixed=T)
    if (length(test)>0) msg<-paste("<b>",msg,"</b>")
    sel[[j]]<-c(msg,commits[i,"version"])
    j<-j+1
  }
  sel<-rev(sel)
  versions<-rev(unique(commits$version))
  coms<-do.call("rbind",sel)
  for (i in seq_along(versions)) {
    rel<-""
    if (i==1) rel<-"(future)"
    if (i==2) rel<-"(current)"
    
    cat(paste("#",versions[i],rel,"\n\n"))
    cs<-coms[coms[,2]==versions[i],1]
    for (j in cs)
      cat(paste("*",j,"\n\n"))
  }
  #coms
}
