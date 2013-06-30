#Libraries
library(RMySQL)

db_tsv_gen.fun <- function(){
  
  #Load config
  source(file.path(getwd(),"config.r"))
  
  lang_read.fun <- function(){
  
    #Grab URL of the ISO-639-3 standard, in UTF-8
    lang.url <- "http://www-01.sil.org/iso639-3/iso-639-3_20130531.tab"
  
    #Open URL, read in, close
    lang.con <- url(description = lang.url, open = "rt", blocking = TRUE, encoding = "UTF-8")
      lang_codes.df <- read.delim(file = lang.con,
                                  header = TRUE, sep = "\t",
                                  fill = TRUE, encoding = "UTF-8",
                                  colClasses = c(rep("character",7),"NULL"),
                                  quote = "", nrows = -1)
    close(lang.con)
    
    #Remove an unnecessary column and limit to living and special languages,
    #while I'm there, overwrite 3-alpha language codes with 2-alpha when available.
    lang_codes.df <- lang_codes.df[lang_codes.df$Language_Type %in% c("L","S"), c(1,3:7)]
    lang_codes.df[!lang_codes.df$Part1 == "",1] <- lang_codes.df[!lang_codes.df$Part1 == "",3]
    
    #Return
    return(lang_codes.df)
  }
  
  #Function to read in different db names
  db_read.fun <- function(){
    
    #Generalised function for querying the db
    sql.fun <- function(){
      
      #Open a connection
      con <- dbConnect(drv = "MySQL",
                       username = query_user,
                       password = query_pass,
                       host = query_server,
                       dbname = NULL)
      
      #Query
      QuerySend <- dbSendQuery(con, statement = "SHOW DATABASES;")
      
      #Retrieve output of query
      output <- fetch(QuerySend, n = -1)
      
      #Kill connection
      dbDisconnect(con)
      
      #Return output
      return(output)
    }
    
    #Create a list of server names
    servers.ls <- list(c("s1-analytics-slave.eqiad.wmnet"),
                       c("s2-analytics-slave.eqiad.wmnet"),
                       c("s3-analytics-slave.eqiad.wmnet"),
                       c("s4-analytics-slave.eqiad.wmnet"),
                       c("s5-analytics-slave.eqiad.wmnet"),
                       c("s6-analytics-slave.eqiad.wmnet"),
                       c("s7-analytics-slave.eqiad.wmnet"))
    
    #Create a dataframe to be filled with the output of the while loop
    databases.df <- data.frame()
    
    #Disposable objects for the while loop
    TroutMaskReplica <- FALSE
    IceCreamForCrow <- 1
    BobKrasnow <- length(servers.ls)
    
    while(TroutMaskReplica == FALSE){
      
      #Set the pertinent analytics slave
      query_server <- as.character(servers.ls[IceCreamForCrow])
      
      #Query each analytics slave in turn, asking for a list of dbs.
      results.df <- sql.fun()
      
      #Add slave name
      results.df$Slave <- query_server
      
      #Spit out into databases.df
      databases.df <- rbind(databases.df,results.df)
      
      #Increment IceCreamForCrow
      IceCreamForCrow <- IceCreamForCrow+1
      
      #If loop to prevent overrun
      if(IceCreamForCrow > BobKrasnow){
        TroutMaskReplica <- TRUE
      }
    }
    
    #Return
    return(databases.df)
  }
  
  #Filter out incorrect projects and parse to generate new data
  db_filter.fun <- function(){
  
    #Run. We now have two dataframes, one containing all possible ISO codes and one containing db and server names
    databases.df <- db_read.fun()
    lang_codes.df <- lang_read.fun()
  
    #Remove non-wikis
    databases.df <- databases.df[grepl(pattern = "wiki", x = databases.df$Database, ignore.case = FALSE, perl = TRUE),]
    databases.df <- databases.df[!grepl(pattern = "(arbcom|demo|affcom|config|board|l10n|audit|transition|commons|meta|simple|iegcom|usability|grants|foundation|checkuser|collab|chapcom|advisory|beta|old|wikimania|strategy|test|quality|labs|outreach|specieswiki|mediawikiwiki|comcom|donate|closed|chair|search|sep11|quality|office|ombudsmen|movement|nostalgia|steward|internal|incubator|quotewiki|otrs|langcom|vote|login|data|spcom)",x = databases.df$Database, ignore.case = TRUE, perl = TRUE),]
  
    #Insert language code, and subsequently project type
    databases.df$Lang_Code <- gsub(pattern = "(wiki|quote|source|versity|voyage|books|news|media|species)", replacement = "", x = databases.df$Database, ignore.case = FALSE, perl = TRUE)
    databases.df$Lang_Code <- gsub(pattern = "(_)", replacement = "-", x = databases.df$Lang_Code, ignore.case = FALSE, perl = TRUE)
    reg_matches.vec <- regexpr(text = databases.df$Database, pattern = "(wiki(quote|source|versity|voyage|books|news|media|species|\\Z))", ignore.case = TRUE, perl = TRUE)
    databases.df$Project_Type <- regmatches(databases.df$Database, m = reg_matches.vec)
    
    #Return
    return(databases.df)
    
  }
  
  #Run
  to_output.df <- db_filter.fun()
  
  #Write out
  output_file_path <- file.path(getwd(),"KnownDbs","Databases.tsv")
  write.table(x = to_output.df, file = output_file_path,
              col.names = TRUE, row.names = FALSE,
              sep = "\t")
  
}

#Run
db_tsv_gen.fun()  