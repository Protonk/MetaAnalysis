\name{gadgetUsage}
\alias{gadgetUsage}
\title{Gadget usage}
\usage{
  gadgetUsage(output = c("All", "byGadgets", "byWikis"),
    username, password, host, dbname, ...)
}
\arguments{
  \item{output}{A character vector denoting which output is
  preferred}

  \item{username}{slave access username}

  \item{password}{slave access password}

  \item{host}{host database}

  \item{dbname}{database name}
}
\value{
  Data frame with stuff based on things (Oliver, help!)
}
\description{
  Yank data around gadgets being used on various wikimedia
  projects, via the user_properties table.
}

