main.fun <- function(){
  
  source(file.path(getwd(),"KnownDbs","KnownDbs.r"))
  
  print("Database list built")
  
  source(file.path(getwd(),"ProjectActivity","ProjectActivity.r"))
  
  print("Active wikis identified")
  
}

main.fun()