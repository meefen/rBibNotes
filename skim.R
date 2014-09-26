### Skim

## Working directory
wd <- "~/src/r/myworkflow"
setwd(wd)

# Get args from Rscript command
args <- commandArgs(trailingOnly = TRUE)
# args[1] = citekey

library(stringr)
library(bibtex)
source("utils.R")
source("settings.R")

# Find out the newest file
file <- find_newest_file(skim_dir)

# Read file
conn <- file(file, open="r")
lines <- readLines(conn, encoding="UTF-8")
# lines <- readLines(file, encoding="UTF-8")
close(conn)

# Parse bib
bibs = read.bib(file = bib_file)
bibs_keys = unlist(bibs$key)
bib = bibs[which(bibs_keys == args[1])]
bib_str = format(bib)
bib_author = bib$author[1]$family
bib_title = gsub("\\{|\\}|\\/", "", paste(bib_author, "-", bib$year, "-", bib$title))

# Parse file
out <- paste0(jekyll_front_matter(args[1], bib_title, bib_str), 
              parse_skim(lines))

# Write results
out_file <- paste0(jekyll_dir, "/", Sys.Date(), "-", args[1], ".md")
if(file.exists(out_file)) {
  stop("File already exist! Please check.")
}
out_conn <- file(out_file, 'w')
writeLines(out, out_conn)
close(out_conn)

print(paste("Successfully parsed! Check", out_file))
