### Doku Wiki migration

library(stringr)
source("utils.R")
options(warn=-1) # turn warnings off

dir <- "~/Dropbox/Public/meefen.github.io/notes/_drafts"

## Start from /ref

# for each doc
dir_ref <- paste0(dir, "/ref")
dir_clip <- paste0(dir, "/clip")
dir_notes <- paste0(dir, "/notes")
refs <- list.files(dir_ref)
refs <- subset(refs, refs != "_dummy")

for(ref in refs) {
  # read file
  citekey <- gsub("\\.txt$", "", ref)
  ref_uri <- paste(dir_ref, ref, sep="/")
  conn <- file(ref_uri, open="r")
  lines <- readLines(conn, encoding="UTF-8")
  close(conn)
  
  # check whether there's any file with the same name in 
  # notes, and clip
  # if so, merge them into one file
  notes_uri <- paste(dir_notes, ref, sep="/")
  if(file.exists(notes_uri)) {
    conn <- file(notes_uri, open="r")
    notes_lines <- readLines(conn, encoding="UTF-8")
    close(conn)
    
    lines <- c(lines, "## Notes", notes_lines)
  }
  
  clip_uri <- paste(dir_clip, ref, sep="/")
  if(file.exists(clip_uri)) {
    conn <- file(clip_uri, open="r")
    clip_lines <- readLines(conn, encoding="UTF-8")
    close(conn)
    
    lines <- c(lines, "## Clippings", clip_lines)
  }
  
  # then replace h1., etc., with Markdown headings (i.e., #s)
  # and strip unnecessary characters
  lines <- gsub("^h1\\..*$", "## References", lines)
  lines <- gsub("^h2\\. Links here$", "", lines)
  lines <- gsub("^\\{\\{.*\\}\\}$", "", lines)
  lines <- gsub("^h2\\.", "##", lines)
  lines <- gsub("^h3\\.", "###", lines)
  lines <- gsub("^h4\\.", "####", lines)
  lines <- gsub("^h5\\.", "#####", lines)
  lines <- gsub("^h6\\.", "######", lines)
  lines <- gsub("(^\\^ Citation \\|)(.*)\\^ <html>.*", "\\2", lines)
  lines <- gsub("- ", "", lines)
  lines <- gsub("::(.*)(::)", "__\\1__", lines)
  
  # add Jekyll yam header
  lines <- c(jekyll_front_matter(citekey), lines)
  
  # then save to a new file
  # with date as creation date of that file
  out_file <- paste0(dir, "/", 
                     format(file.info(ref_uri)$mtime, format="%Y-%m-%d"), 
                     "-", citekey, ".md")
  if(file.exists(out_file)) {
    print(paste0("File ", out_file, " already exist! Please check."))
    next
  }
  out_conn <- file(out_file, 'w')
  writeLines(lines, out_conn)
  close(out_conn)
}
