### PDF-Expert

## Working directory
wd <- "~/src/r/myworkflow"
setwd(wd)

# Get args from Rscript command
args <- commandArgs(trailingOnly = TRUE)
# args[1] = citekey

library(stringr)
source("utils.R")
source("settings.R")

# Find out the newest file
file <- find_newest_file(pdfexpert_dir)

# Read file
conn <- file(file, open="r")
lines <- readLines(conn, encoding="UTF-8")
# lines <- readLines(file, encoding="UTF-8")
close(conn)

# Parse file
out <- paste0(jekyll_front_matter(args[1]), parse_expert(lines))

# Write results
out_file <- paste0(jekyll_dir, "/", Sys.Date(), "-", args[1], ".md")
if(file.exists(out_file)) {
  stop("File already exist! Please check.")
}
out_conn <- file(out_file, 'w')
writeLines(out, out_conn)
close(out_conn)

print(paste("Successfully parsed! Check", out_file))

# process file and save it as 'file.rtxt'
# library(tau)
# Encoding(file) <- "UTF-8"
# Encoding(file)
# iconv(file, 'UTF-16LE', 'UTF-8')
# readLines(file, encoding="UTF-8")