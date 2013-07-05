#' Database Data
#' 
#' Different datasets available based on past tool output
#' 
#' @name databases
#' @docType data
#' @format A dataframe with ~700 observations on the following 5 variables,
#'
#' \describe{
#' 
#' \item{Database}{String: Project Name}
#' 
#' \item{Slave}{String: Slave location}
#' 
#' \item{Lang_Code}{String: Project language}
#'
#' \item{Project_Type}{String: Type, e.g. wiki}
#'
#' \item{Lang_name}{String: Full language name}
#'
#' }
#' @keywords datasets
NULL

#' Gadget Data
#' 
#' Gadget usage across projects and users.
#' 
#' @name gadgetdata
#' @docType data
#' @format A dataframe with ~5000 observations on the following 4 variables,
#'
#' \describe{
#' 
#' \item{preference}{String: Name of the gadget}
#' 
#' \item{users}{Numeric: Number of users with that preference recorded}
#' 
#' \item{Project}{String: Project name}
#'
#' \item{Project_Type}{String: Project type, e.g. wiki}
#'
#' }
#' @keywords datasets
NULL
