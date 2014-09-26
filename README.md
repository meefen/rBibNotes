rBibNotes
=========

## Motivation

As an academic, my daily workflow involves reading materials (normally in PDFs on a computer or an iPad), highlighting content in materials, and making summaries about highlighted content.

Reference management tools like Mendeley has PDF highlighting and note taking functions readily built in. And you might be very happy with them. However, I hate the fact that you would get locked in their environment, unable to take your notes elsewhere for productive work with ideas.

## How it works

This `rBibNotes` repository contains R scripts I wrote to support my personal academic workflow, which looks like the following:

- organize references with [BibDesk](http://bibdesk.sourceforge.net/) (or [Mendeley](http://www.mendeley.com/) if you like), with all references synced as a BibTeX file somewhere in my computer
- read PDF materials in [Skim](http://skim-app.sourceforge.net/) (an open source PDF reader for Mac) or [PDFExpert](https://readdle.com/products/pdfexpert5/) (an iPad app), highlighting text snippets while reading and exporting them to designated Dropbox folders
- run R scripts (`skim.R` or `pdfexpert.R`) to combine highlights with BibTeX information into a structured [Markdown](http://daringfireball.net/projects/markdown/) file ready to be shared on [my personal annotated bibliography page](http://meefen.github.io/notes/) powered by [Jekyll](http://jekyllrb.com/)
- edit the Markdown file as needed (e.g., write a summary, add tags), and then push to my bibliography page

Note: For Windows or Linux users (I was before), [PDF-xChange](http://www.tracker-software.com/product/pdf-xchange-viewer) might be the best choice to export highlights. And you could use `pdfxchange.R` to do similar things.

## Usage

These scripts were really written only for myself and may not meet your needs, or your philosophy, at all. But if you like, you are more than welcome to take them, tweak them, and make them your own. Here are a few things to do to make it work:

- install R (obviously)
- install dependencies: `stringr`, `bibtex`
- edit `settings.R` based on your environment settings

To convert a reference, e.g, `Chen2014`, which you just read using Skim and exported highlights to the configured `skim_dir` folder, simply run `Rscript skim.R Chen2014` in your rBibNotes directory using the Terminal. You will then find converted text in `jekyll_dir`, and you can do whatever you like from there.

Last but not least, **please send pull requests** after making any improvement.

## Disclaimer

I will not be responsible for any damage caused by using these scripts. It is unlikely that your bib file gets lost, your ideas get *stolen* because you share them online, or your academic reputation gets damaged because you accidentally champion a terrible study. But in case any of these happens when/after using these scripts, I won't be responsible for it :P
