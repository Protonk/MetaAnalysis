#Wrapping function
GadgetUsage.fun <- function(){
  
  #Read in config vars and libraries
  source(file.path(getwd(),"config.r"))
  
  #Read list of dbs
  dbs.df <- read.delim(file.path(getwd(),"KnownDbs","Databases.tsv"), header = TRUE, as.is = TRUE)
  
  data_retrieve.fun <- function(){
    
    #Query function
    sql.fun <- function(query_type){
      
      #Open a connection
      con <- dbConnect(drv = "MySQL",
                       username = query_user,
                       password = query_pass,
                       host = query_server,
                       dbname = query_database)
      
      if(query_type == 1){
        QuerySend <- dbSendQuery(con, statement = "SELECT DISTINCT up_property AS preference, COUNT(*) AS users FROM user_properties GROUP BY preference;")
      } else if(query_type == 2){
        QuerySend <- dbSendQuery(con, statement = "SHOW TABLES;")
      }
      
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
      
      query.df <- sql.fun(query_type = 2)
      
      if(length(query.df[query.df[,1] == "user_properties",]) >= 1){
        query.df <- sql.fun(query_type = 1)

        #If to take into account the wikis which are, for some reason, pre-1.16 user.user_options blob hellholes.
        if(nrow(query.df) >= 1){
        
          query.df$Project <- query_database
          query.df$Project_Type <- as.character(dbs.df[BatChainPuller,4])
        
          output_data.df <- rbind(output_data.df, query.df)
        }
      }
      
      #Increment
      BatChainPuller <- BatChainPuller+1
      
      #Control if
      if(BatChainPuller > RunPaintRunRun){
        AshtrayHeart <- FALSE
      }
    }
    
    #Sanitise
    output_data.df <- output_data.df[grepl(pattern = "(gadget)", x = output_data.df$preference, perl = TRUE, ignore.case = TRUE),]
    
    #Return
    return(output_data.df)
  }
  
  output.fun <- function(){
    
    #Run data retrieval function
    gadget_data.df <- data_retrieve.fun()
    
    #Number of projects each gadget is on, and associated data
    gadget_by_wiki.df <- rename(ddply(.data = gadget_data.df,
                               .variable = "preference",
                               .fun = function(x){
                                  wikis <- length(x$Project)
                                  users <- sum(x$users)
                                  output.vec <- as.vector(c(wikis,users))
                                  return(output.vec)
                               }
                              ),replace=c("V1" = "Wikis","V2" = "Users"))
    
    #Number of gadgets each wiki has
    wiki_by_gadgets.df <- as.data.frame(table(gadget_data.df$Project))
    
    #Writes
    gadget_by_wiki.path <- file.path(getwd(),"GadgetUsage","gadgets_by_wikis.tsv")
    write.table(gadget_by_wiki.df, file = gadget_by_wiki.path, col.names = TRUE, row.names = FALSE, quote = FALSE
    sep = "\t")
    
    #Writes
    wiki_by_gadgets.path <- file.path(getwd(),"GadgetUsage","wikis_by_gadgets.tsv")
    write.table(gadget_by_wiki.df, file = wiki_by_gadgets.path, col.names = TRUE, row.names = FALSE, quote = FALSE
    sep = "\t")