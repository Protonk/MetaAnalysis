#####
###
### Check Gadget usage
###
#####

#' Gadget usage
#'
#' Yank data around gadgets being used on various wikimedia projects, via the user_properties table.
#'
#' @param output A character vector denoting which output is preferred
#' @param username slave access username
#' @param password slave access password
#' @param host host database
#' @param dbname database name
#' @return Data frame with stuff based on things (Oliver, help!)
#' @import plyr
#' @import RMySQL
#' @export

#Wrapping function
gadgetUsage <- function(output = c("All", "byGadgets", "byWikis"),
                        username, password, host, dbname,
                        ...){
  
  #Read list of dbs
  dbs.df <- knownDbs(...)
  
  downstairs_mixup.fun <- function(){
    
    #Query function
    sql.fun <- function(query_type){
      
      #Open a connection
      con <- dbConnect(drv = "MySQL",
                       username = username,
                       password = password,
                       host = host,
                       dbname = dbname)
      
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
        
    for(i in (1:nrow(dbs.df))) {
      
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
      
    }
    
    #Sanitise
    output_data.df <- output_data.df[grepl(pattern = "(gadget)", x = output_data.df$preference, perl = TRUE, ignore.case = TRUE),]
    
    #Return
    return(output_data.df)
  }
  gadget_data.df <- downstairs_mixup.fun()

  output.df <- switch(output,
                      All = gadget_data.df,
                      byGadgets = rename(ddply(.data = gadget_data.df,
                                         .variables = "preference",
                                         .fun = function(x){
                                            wikis <- length(x$Project)
                                            users <- sum(x$users)
                                            output.vec <- as.vector(c(wikis,users))
                                            return(output.vec)
                                         }
                                        ),replace=c("V1" = "Wikis","V2" = "Users")),
                      byWikis = as.data.frame(table(gadget_data.df$Project)))

  return(output.df)
}
