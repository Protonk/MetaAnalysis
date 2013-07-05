#####
###
### Project stuff
###
#####

#' Get project activity 
#'
#' Return active users for the passed in projects 
#'
#' @param qstatement A character vector with the SQL statement
#' @param username slave access username
#' @param password slave access password
#' @param host host database
#' @param dbname database name
#' @return Data frame containing activity across projects. 
#' @import plyr
#' @import RMySQL
#' @export


projectActivity <- function(qstatement = "SELECT COUNT(*) FROM recentchanges WHERE rc_user > 0 AND rc_bot = 0 GROUP BY rc_user HAVING COUNT(*) > 5;",
                            username, password, host, dbname,
                            ...){

  
  #Read in the dataframe of servers/projects
  servers.df <- knownDbs(...)
  
  #And now the fun begins.
  parse.fun <- function(){
    
    #Generalised function for querying the db
    sql.fun <- function(){
      
      #Open a connection
      con <- dbConnect(drv = "MySQL",
                       username = username,
                       password = password,
                       host = host,
                       dbname = dbname)
      
      #Query
      QuerySend <- dbSendQuery(con, statement = "SELECT COUNT(*) FROM recentchanges WHERE rc_user > 0 AND rc_bot = 0 GROUP BY rc_user HAVING COUNT(*) > 5;")
      
      #Retrieve output of query
      output <- fetch(QuerySend, n = -1)
      
      #Kill connection
      dbDisconnect(con)
      
      #Return output
      return(output)
    }
    
    #Create output dataframe.
    servers.df$Active_Editors <- NA
    
    #While loop. For each project, retrieve the number of active users in the last 30 days
    for(i in (1:nrow(servers.df))) {
      
      #Grab pertinent row
      ServerRow <- servers.df[i,]
      
      #Split out server and database name
      query_database <- as.character(ServerRow[1])
      query_server <- as.character(ServerRow[2])
      
      #Query to retrieve the number of users
      query.df <- sql.fun()
      
      #Output
      servers.df[i,6] <- as.numeric(nrow(query.df))
      
    }
    
  }
  
  #Run
  parse.fun()
  
  #Order
  parse.output <- parse.output[order (parse.output$V1, decreasing = TRUE),]
  
  return(parse.output)
}
