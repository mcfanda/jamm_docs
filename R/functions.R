library(yaml)
library(rmarkdown)
library(Rsearchable)



keywords<-function(key) {
  span<-'<span class="keywords"> <span class="keytitle"> keywords </span>'
  paste(span,key,"</span>")
}

version<-function(ver) {
    paste('<span class="version"> <span class="versiontitle"> jAMM version ≥ </span> ',ver,' </span>')
}


draft<-'<span class="draft"> Draft version, mistakes may be around </span>'


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
  res<-lookup(sfiles,criteria)
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
      <a href=" https://github.com/mcfanda/jamm/issues ">
      jAMM at github“</a> or <a href="mailto:mcfanda@gmail.com">send me an email</a></p>
  ')
  return(a)
  
}

test<-function() return("xx xxxxxx x")
