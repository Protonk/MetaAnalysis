#Wrapping function
GadgetUsage.fun <- function(){
  
  #Read in config vars and libraries
  source(file.path(getwd(),"config.r"))
  
  #Read list of dbs
  dbs.df <- read.delim(file.path(getwd(),"KnownDbs","Databases.tsv"), header = TRUE, as.is = TRUE)
  
  data_retrieve.fun <- function(){
    
    #Query function
    sql.fun <- function(){
      
      #Open a connection
      con <- dbConnect(drv = "MySQL",
                       username = query_user,
                       password = query_pass,
                       host = query_server,
                       dbname = query_database)
      
      #Query
      QuerySend <- dbSendQuery(con, statement = "SELECT DISTINCT up_property AS preference, COUNT(*) AS users FROM user_properties GROUP BY preference;")
      
      #Retrieve output of query
      output <- fetch(QuerySend, n = -1)
      
      #Kill connection
      dbDisconnect(con)
      
      #Return output
      return(output)
    }
    
    #Empty dataframe
    output_data.df <- data.frame()
    
    #Required variables for while loop
    BatChainPuller <- 1
    AshtrayHeart <- TRUE
    RunPaintRunRun <- nrow(dbs.df)
    
    while(AshtrayHeart == TRUE){
      
      #Set query vars
      query_database <- as.character(dbs.df[BatChainPuller,1])
      query_server <- as.character(dbs.df[BatChainPuller,2])
      
      query.df <- sql.fun()

      #If to take into account the wikis which are, for some reason, pre-1.16 user.user_options blob hellholes.
      if(nrow(query.df) >= 1){
        output_data.df <- rbind(output_data.df, query.df)
      
        query.df$Project <- query_database
        query.df$Project_Type <- as.character(dbs.df[BatChainPuller,4])
      
      }
      
      #Increment
      BatChainPuller <- BatChainPuller+1
      
      #Control if
      if(BatChainPuller > RunPaintRunRun){
        AshtrayHeart <- FALSE
      }
    }
      