metaanalysis.fun <- function(){

  #Load config file
  source(file.path(getwd(),"config.r"))
  
  #Read in the dataframe of servers/projects
  servers.df <- read.delim(file.path(getwd(),"KnownDbs","Databases.tsv"), as.is = TRUE, header = TRUE)
  
  #And now the fun begins.
  parse.fun <- function(){
    
    #Random nonsense variables needed for the while loop
    PlasticFactory <- 1
    CaptainBeefheart <- TRUE
    
    #Query function
    retrieve.fun <- function(statement){
  
      query.df <- sql_wrapper(query_user = query_user,
        query_pass = query_pass,
        query_database = query_database,
        query_server = query_server,
        statement = statement) 
    
      return(query.df)
    }
    #Create output dataframe.
    while.output <- data.frame()
    
    #While loop. For each project, retrieve the number of active users in the last 30 days
    while(CaptainBeefheart == TRUE){
      
      #Grab pertinent row
      ServerRow <- servers.df[PlasticFactory,]
      
      #Split out server and database name
      query_server <- as.character(ServerRow[1])
      query_database <- as.character(ServerRow[2])
      
      #Query to retrieve the number of users
      query.df <- retrieve.fun(statement = "SELECT COUNT(*) FROM recentchanges WHERE rc_user > 0 AND rc_bot = 0 GROUP BY rc_user HAVING COUNT(*) > 5")
      
      #Prep output
      ToPrint <- as.character(nrow(query.df))
      
      #Print
      while.output[PlasticFactory,1] <- as.numeric(ToPrint)
      
      #Increment PlasticFactory, run check against it
      PlasticFactory <- PlasticFactory + 1
      
      #Check and break.
      if(PlasticFactory > nrow(servers.df)){
        CaptainBeefheart <- FALSE
      }
    }
    
    #Bind servers across
    while.output[,2] <- servers.df[,2]
    
    #Output
    return(while.output)
    
  }
  
  #Run
  parse.output <- parse.fun()
  
  #Order
  parse.output <- parse.output[order (parse.output$V1, decreasing = TRUE),]
  
  #Sanitise names
  parse.output <- rename(parse.output, c("V1" = "Users", "V2" = "Project"))
  
  #Sanitise output and replace with link
  parse.output$Project <- gsub(("_"), x = parse.output$Project, replacement = "-", perl = TRUE, ignore.case = TRUE)
  parse.output$Project <- gsub(("wiki"), x = parse.output$Project, replacement = "\\.wikipedia\\.org", perl = TRUE, ignore.case = TRUE)
  parse.output$Project <- paste("https://",parse.output$Project, sep = "")
  
  #Print
  tsv_wrapper(parse.output, file = file.path(getwd(),"meta_output.tsv"))
}

#Run
metaanalysis.fun()