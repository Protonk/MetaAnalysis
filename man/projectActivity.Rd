\name{projectActivity}
\alias{projectActivity}
\title{Get project activity}
\usage{
  projectActivity(qstatement = "SELECT COUNT(*) FROM recentchanges WHERE rc_user > 0 AND rc_bot = 0 GROUP BY rc_user HAVING COUNT(*) > 5;",
    username, password, host, dbname, ...)
}
\arguments{
  \item{qstatement}{A character vector with the SQL
  statement}

  \item{username}{slave access username}

  \item{password}{slave access password}

  \item{host}{host database}

  \item{dbname}{database name}
}
\value{
  Data frame containing activity across projects.
}
\description{
  Return active users for the passed in projects
}

