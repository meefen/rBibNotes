### Utils

library(stringr)
source("settings.R")

### Function to insert jekyll front-matter
jekyll_front_matter <- function(citekey="Unknown", bib_title="", bib_str=""){
  if(is.na(bib_title)) bib_title = citekey
  paste0("---\nlayout: post\ncategories: notes\ntitle: 'Notes: ", bib_title,
        "'\ndate: '", format(Sys.time(), "%Y-%m-%d"), "'\n---",
         "\n\n## References\n\n**Citekey**: @", citekey, "\n\n", bib_str,
         "\n\n## Notes\n\n*Summarize*: \n\n*Assess*: \n\n*Reflect*: \n\n",
         "## Highlights\n")
}

## Function for parsing and formating Paperpile/MetaPDF annotations
parse_paperpile <- function(json_df) {
  ## json_df: a data frame parsed from a json file containingPaperpile annotations

  text = '\n'

  by(json_df, 1:nrow(json_df), function(r) {
    text <<- paste0(text, format_paperpile_annotation(
      r$Subtype, r$MarkupText, r$Text, r$Color, r$PageNumber))
  })

  return(text)
}

format_paperpile_annotation <- function(type, highlight, comment, color=NULL, page=NULL) {
  # set page text
  page_text = if(is.null(page) | is.na(page)) "" else paste0(" (p. ", page, ")")

  if(str_detect(type, "Comment")) {
    syntax_wrap <- TEXT_NOTE_TAG
    return(paste0(syntax_wrap[1], comment, syntax_wrap[2], page_text, "\n\n"))

  } else if(str_detect(type, "Underline")) {
    syntax_wrap <- UNDERLINE_TAG
    return(paste0(syntax_wrap[1], highlight, syntax_wrap[2], page_text, "\n\n"))

  } else if(type == "StrikeOut") {
    syntax_wrap <- STRIKETHROUGH_TAG
    return(paste0(syntax_wrap[1], highlight, syntax_wrap[2], page_text, "\n\n"))

  } else if(type == "Highlight") {
    if(!is.null(color) && color != "#f8e29c") {
      syntax_wrap <- UNDERLINE_TAG
      text = paste0(syntax_wrap[1], highlight, syntax_wrap[2], page_text, "\n\n")
    } else {
      text = paste0(highlight, page_text, "\n\n")
    }
    if(!is.null(comment) && !is.na(comment)) {
      syntax_wrap <- TEXT_NOTE_TAG
      text = paste0(text, paste0(syntax_wrap[1], comment, syntax_wrap[2], page_text, "\n\n"))
    }
    return(text)
  }
}

## Function for formatting Skim text
format_skim <- function(type, text, page=NULL) {
  highlight <- rep("", 2)
  if(str_detect(type, "TextNote")) highlight <- TEXT_NOTE_TAG
  else if(str_detect(type, "Underline")) highlight <- UNDERLINE_TAG
  else if(type == "AnchoredNote") {
    highlight <- TEXT_NOTE_TAG
    # do more here
  }

  text <- gsub("- ", "", str_trim(text)) # sub pdf newline
  if(!is.null(page))
    return(paste0(highlight[1], text, highlight[2], " (p. ", page, ")\n\n"))
  else
    return(paste0(highlight[1], text, highlight[2], "\n\n"))
}

## Function for parsing Skim text
parse_skim <- function(lines) {
  out = '\n\n'
  page = 0
  type = ''
  text = ''

  for(i in 1:length(lines)) {
    line <- str_trim(lines[i])

    if(str_detect(line, "^\\* (Highlight|Text Note|Underline|Anchored Note), page (.+?)$")) {
      ## if it's a line with type and page

      if(page > 0) { # if there are notes before, format them, and paste to out
        out <- paste0(out, format_skim(type, text, page))
        text = ''
      }

      type = gsub("[\\* ,]|page|[0-9]", "", line)
      page = str_extract(line, "[0-9]+")
    } else {
      ## if it's a normal highlight
      text <- paste(text, line)
      if(line == '') { # happens for 'AnchoredNote'
        text <- paste(text, "\n")
      }
    }
  }
  out <- paste0(out, format_skim(type, text, page)) # add the final line

  return(out)
}

## Function for formatting PDFExpert text
format_expert <- function(type, text, page=NULL) {
  highlight <- rep("", 2)
  if(str_detect(type, "Note")) highlight <- TEXT_NOTE_TAG
  else if(str_detect(type, "Underline-standalone")) highlight <- UNDERLINE_TAG

  text <- gsub("- ", "", str_trim(text)) # sub pdf newline
  if(!is.null(page))
    return(paste0(highlight[1], text, highlight[2], " (p. ", page, ")\n\n"))
  else
    return(paste0(highlight[1], text, highlight[2]))
}

## Funciton for parsing PDFExpert text
parse_expert <- function(lines) {
  out = ''
  page = 0
  type = ''
  text = ''

  for(i in 1:length(lines)) {
    line <- str_trim(lines[i])

    if(grepl("Annotations Summary of ", line)) next

    if(str_detect(line, "^(Highlight|Note|Underline|and Note)$")) {
      ## if it's a line with type and page

      if(page > 0 & type != "") { # if there are notes before, format them, and paste to out
        if(type == "Note") {
          out <- paste0(out, text, "\n")
        } else {
          out <- paste0(out, format_expert(type, text, page))
        }
        text = ''
      }

      type = line
    } else if(str_detect(line, "^PAGE ([0-9]+?):$")) {
      page <- str_extract(line, "[0-9]+")
    } else {
      if(type == "Note") {
        if(line != "")
          text <- paste(text, format_expert(type, line, NULL), sep="\n")
      } else {
        ## if it's a normal highlight
        text <- paste(text, line, sep="\n")
      }
    }

#     # if the line is about note type
#     if(line == "Highlight" || line == "Underline" ||
#          line == "Note"  || line == "and Note" || line == "") {
#       type = line
#       next
#     }
#
#     # if the line is about page
#     if(str_detect(line, "^PAGE ([0-9]+?):$")) {
#       page <- str_extract(line, "[0-9]+")
#       next
#     }
#
#     if(type == "Highlight") {
#       out <- paste0(out, format_expert("Text", line, page))
#     } else if(type == "Underline") {
#       out <- paste0(out, format_expert("Underline-standalone", line, page))
#     } else if(type == "Note" || type == "and Note") {
#       out <- paste0(out, format_expert("Text Note", line, page))
#     }
  }
  out <- paste0(out, format_skim(type, text, page)) # add the final line

  return(out)
}

## Function to find out the newest file in a dir
find_newest_file <- function(dir) {
  files <- list.files(dir)
  mdate <- as.vector(sapply(files, function(f)
    file.info(paste0(dir, "/", f))$mtime))
  file_name <- files[which(mdate == max(mdate))]
  paste(dir, file_name, sep="/")
}
