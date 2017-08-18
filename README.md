rBibNotes
=========

## Motivation

As an academic, my daily workflow involves reading materials (normally in PDFs on a computer or an iPad), highlighting content in materials, and writing summaries about highlighted content.

Reference management tools like Mendeley has PDF highlighting and note taking functions readily built in. And you might be very happy with them. However, I want all my annotations to be portable. A fancier way of saying this is: I want to give annotations their own independent lives as conceptual artifacts, open to be connected with other artifacts. Read more in a recent explanation of my [digital workflow here](http://bodong.ch/blog/2016/09/22/paperpile-workflow-part-1/).

## How it works

This `rBibNotes` repository contains R scripts I wrote to support *my* personal academic workflow, which looks like the following:

- organize references with [Paperpile](https://paperpile.com/app) (or [BibDesk](http://bibdesk.sourceforge.net/), or [Mendeley](http://www.mendeley.com/) if you like)
- read PDF materials in Paperpile's integrated PDF reader (aka. MetaPDF), or [Skim](http://skim-app.sourceforge.net/) (an open source PDF reader for Mac), or [PDFExpert](https://readdle.com/products/pdfexpert5/) (an iPad app), make annotations (e.g., highlights, comments, underlines) along the way, and export annotations to designated Dropbox folders. (Depending on the tool you use, this process may pan out differently.)
- run one R script that matches with your PDF reader (`pp.R` or `skim.R` or `pdfexpert.R`) to combine highlights with BibTeX information into a structured [Markdown](http://daringfireball.net/projects/markdown/) file ready to be shared on [my personal annotated bibliography page](http://meefen.github.io/notes/) powered by [Jekyll](http://jekyllrb.com/). (Note: Because it takes too long to iterate through a large .bib file, I decided to insert bib infor manually.)
- edit the Markdown file as needed (e.g., write a summary, add tags), and then push to my bibliography page

Note: For Windows or Linux users (I was one before), [PDF-xChange](http://www.tracker-software.com/product/pdf-xchange-viewer) might be the best choice to export highlights. And you could use `pdfxchange.R` to do similar things.

## Usage

These scripts were really written only for myself and may not meet your needs, or your philosophy, at all. But if you like, you are more than welcome to take them, tweak them, and make them your own. Here are a few things to do to make it work:

- install `R`
- install dependencies: `stringr`, `bibtex`
- edit `settings.R` based on your environment settings

To convert a reference, e.g, `Chen2014`, which you just read using Paperpile and exported highlights (in the JSON format) to the configured `pp_dir` folder, simply run `Rscript pp.R Chen2014` in your `rBibNotes` directory using the Terminal. You will then find converted text in `jekyll_dir`, and you can do whatever you like from there.

Last but not least, **please send pull requests** after making any improvement.

## Disclaimer

I will not be responsible for any damage caused by using these scripts. It is unlikely that your bib file gets lost, your ideas get *stolen* because you share them online, or your academic reputation gets damaged because you accidentally champion a terrible study. But in case any of these happens when/after using these scripts, I won't be responsible for it :P
