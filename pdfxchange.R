### PDF-Xchange

library(stringr)

## Function for formatting text
format_xchange <- function(type, text, page) {
  highlight <- ""
  if(str_detect(type, "Sticky Note|Callout")) highlight <- "::"
  else if(str_detect(type, "Underline|Underline-standalone")) highlight <- ":::"
  
  text <- str_trim(text)
  text <- str_replace_all(text, " +", " ") # fix multiple spaces
  return(paste0(highlight, text, highlight, " (p. ", page, ")\n\n"))
}

# Find out the newest file
files <- list.files(xchange_dir)
mdate <- as.vector(sapply(files, function(f) 
  file.info(paste0(xchange_dir, "/", f))$mtime))
file_name <- files[which(mdate == max(mdate))]
file <- paste0(xchange_dir, "/", file_name)

# Change encoding to UTF-8
file_tmp <- paste0(file, ".tmp")
system(paste0("iconv -f UTF-16LE -t UTF-8 ", file, " > ", file_tmp))
# iconv -f UTF-16LE -t UTF-8 file.txt > file.txt.tmp
system(paste("mv", file_tmp, file)) # replace original with re-encoded

# Read file
conn <- file(file, open="r")
lines <- readLines(conn, encoding="UTF-8")

# Parse file
out = ''
page = 0
type = ''
text = ''
for(i in 1:length(lines)) {
  line <- str_trim(lines[i])
  
  if(str_detect(line, "Author: (.+?) Subject: (.+?)")) {
    type <- str_extract(line, "Highlight|Sticky Note|Callout|Cross-Out|Underline|Underline-standalone")
    next
  }

  if(str_detect(line, "^Page: ([0-9]+?)")) {
    page <- str_extract(line, "[0-9]+")
    next
  }
  
  if(line == "" || i == length(lines) || str_detect(line, "^-----------------+$")) {
    if(str_length(text) > 0 && type != "") {
      out <- paste0(out, format_xchange(type, text, page))
    } else { # if this is the last line, and it has something
      if(i == length(lines) && line != "") {
        out <- paste0(out, format_xchange(type, line, page))
      }
    }
    text = ""
    type = ""
    next
  }
  text <- paste(text, line)
}
close(conn)

# Write results
out_conn <- file(paste0(file,".r.txt"), 'w')
writeLines(out, out_conn)
close(out_conn)

# process file and save it as 'file.rtxt'
# library(tau)
# Encoding(file) <- "UTF-8"
# Encoding(file)
# iconv(file, 'UTF-16LE', 'UTF-8')
# readLines(file, encoding="UTF-8")