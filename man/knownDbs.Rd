\name{knownDbs}
\alias{knownDbs}
\title{Read Wikimedia slave servers for available databases.}
\usage{
  knownDbs(servers = list(c("http://noc.wikimedia.org/conf/s1.dblist"), c("http://noc.wikimedia.org/conf/s2.dblist"), c("http://noc.wikimedia.org/conf/s3.dblist"), c("http://noc.wikimedia.org/conf/s4.dblist"), c("http://noc.wikimedia.org/conf/s5.dblist"), c("http://noc.wikimedia.org/conf/s6.dblist"), c("http://noc.wikimedia.org/conf/s7.dblist")),
    exclude = list(c("http://noc.wikimedia.org/conf/closed.dblist"), c("http://noc.wikimedia.org/conf/deleted.dblist"), c("http://noc.wikimedia.org/conf/special.dblist"), c("http://noc.wikimedia.org/conf/private.dblist")),
    languages = "http://www-01.sil.org/iso639-3/iso-639-3_20130531.tab")
}
\arguments{
  \item{servers}{A list of character vectors denoting the
  server list.}

  \item{exclude}{A list of character vectors denoting non
  production servers}

  \item{languages}{A character vector of length 1
  specifying the ISO-639-3 language standard}
}
\value{
  Data frame for each of the known databases.
}
\description{
  Grabs a list of discrete databases found on the Wikimedia
  cluster, filtering out non-production and special
  databases, and extracts and associates various forms of
  human-readable metadata.
}

