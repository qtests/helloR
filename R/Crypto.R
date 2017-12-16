

# Cleaning
# rm(list = ls(all=TRUE))

# setwd("C:/hsk/ProjectHR")

library(rvest)
library(xml2)

f_getCrypto <- function (c.curr="bitcoin", c.startDate=Sys.Date()-30, c.endDate=Sys.Date(), c.sep="," )
{
  f.parseDate <- function(x) as.Date(x, "%b %d %Y")
  f.parseNumbers <- function(x) return(1)
  f.removeSymb<- function(x, c.symb=",") gsub(paste0("[", c.symb ,"]"), "", x)

  c.url1 <- "https://coinmarketcap.com/currencies/"
  c.url2 <- "/historical-data/?start="
  c.url3 <- "&end="
  c.urlCurr <- paste0(c.url1, c.curr, c.url2, format(c.startDate, "%Y%m%d"), c.url3, format(c.endDate, "%Y%m%d"))

  c.html <- try(read_html(c.urlCurr), silent = TRUE)
  if (inherits(c.html, "try-error")) return ( matrix("NA", 1, 1) )
  
  c.nodes <- try(html_nodes(c.html, "table"), silent = TRUE)
  if (inherits(c.nodes, "try-error")) return ( matrix("NA", 1, 1) )
  
  c.table <- try(html_table(c.nodes[[1]]), silent=TRUE)
  if (inherits(c.table, "try-error")) return ( matrix("NA", 1, 1) )
  
  d.data <- apply(c.table, 2, f.removeSymb)
  c.dates <- format(f.parseDate(d.data[, "Date"]), "%Y-%m-%d")
  d.numData <- cbind (c.dates, d.data[, c("Open", "High", "Low", "Close", "Volume", "Market Cap")])
  
  apply(d.numData, 1, function(x) paste0(x, collapse =c.sep))
}


f_id <- function(x) x

# a <- f.getCrypto()

# write.csv(as.data.frame(cbind(format(a[[1]]), a[[2]])), file="test.csv")


