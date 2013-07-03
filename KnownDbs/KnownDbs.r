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
    
    #Create a list of server dblist URLs
    servers.ls <- list(c("http://noc.wikimedia.org/conf/s1.dblist"),
                       c("http://noc.wikimedia.org/conf/s2.dblist"),
                       c("http://noc.wikimedia.org/conf/s3.dblist"),
                       c("http://noc.wikimedia.org/conf/s4.dblist"),
                       c("http://noc.wikimedia.org/conf/s5.dblist"),
                       c("http://noc.wikimedia.org/conf/s6.dblist"),
                       c("http://noc.wikimedia.org/conf/s7.dblist"))
    #Create a dataframe to be filled with the output of the while loop
    databases.df <- data.frame()
    
    #Disposable objects for the while loop
    TroutMaskReplica <- FALSE
    IceCreamForCrow <- 1
    BobKrasnow <- length(servers.ls)
    
    while(TroutMaskReplica == FALSE){
      
      #Set the pertinent analytics slave
      slave_name <- as.character(servers.ls[IceCreamForCrow])
      
      #Query each analytics slave in turn, grabbing a list of dbs.
      slave.con <- url(description = slave_name, open = "rt", blocking = TRUE, encoding = "UTF-8")
      results.df <- as.data.frame(
                      I(
                        scan(file = slave.con,
                         what = "character",
                         nmax = -1,
                         sep = "\n")
                        )
                      )
      close(slave.con)
      
      #Add slave name
      results.df$Slave <- substring(slave_name,32,33)
      
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
    colnames(databases.df)[1] <- "Database"
    return(databases.df)
  }
  
  #Read in non-prod wikis
  bad_read.fun <- function(){
    
    output.df <- data.frame()
    
    servers.ls <- list(c("http://noc.wikimedia.org/conf/closed.dblist"),
                       c("http://noc.wikimedia.org/conf/deleted.dblist"),
                       c("http://noc.wikimedia.org/conf/special.dblist"))
    
    MirrorMan <- FALSE
    Tarotplane <- 1
    Order66 <- length(servers.ls)
    
    while(MirrorMan == FALSE){
      
      list_url <- as.character(servers.ls[Tarotplane])
      
      slave.con <- url(description = list_url, open = "rt", blocking = TRUE, encoding = "UTF-8")
      results.df <- as.data.frame(
                      I(
                        scan(file = slave.con,
                         what = "character",
                         nmax = -1,
                         sep = "\n")
                        )
                      )
      close(slave.con)
      
      output.df <- rbind(output.df,results.df)
      
      Tarotplane <- Tarotplane+1
      
      if(Tarotplane > Order66){
        MirrorMan <- TRUE
      }
    }
    
    colnames(output.df)[1] <- "Database"
    return(output.df)
  }

  #Filter out incorrect projects and parse to generate new data
  db_filter.fun <- function(){
  
    #Run. We now have two dataframes, one containing all possible ISO codes and one containing db and server names
    databases.df <- db_read.fun()
    exclude.df <- bad_read.fun()
    lang_codes.df <- lang_read.fun()
    
    #Exclude old/dead/private/special wikis
    databases.df <- databases.df[!databases.df$Database %in% exclude.df$Database,]
    
    #Insert language code, and subsequently project type
    databases.df$Lang_Code <- gsub(pattern = "(wiki|quote|source|versity|voyage|books|news|media|species)", replacement = "", x = databases.df$Database, ignore.case = FALSE, perl = TRUE)
    databases.df$Lang_Code <- gsub(pattern = "(_)", replacement = "-", x = databases.df$Lang_Code, ignore.case = FALSE, perl = TRUE)
    reg_matches.vec <- regexpr(text = databases.df$Database, pattern = "(wik(iquote|isource|iversity|ivoyage|ibooks|inews|imedia|ispecies|tionary|i\\Z))", ignore.case = TRUE, perl = TRUE)
    databases.df$Project_Type <- regmatches(databases.df$Database, m = reg_matches.vec, invert = TRUE)
    
    
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