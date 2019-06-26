all: Slides.pdf

Slides.pdf: Slides.rmd
	# render the rmd to md using knitr
	R -e "rmarkdown::render('Slides.rmd',clean=FALSE,run_pandoc=FALSE)" ;
	# run pandoc to generate beamer tex
	/usr/bin/pandoc \
		+RTS -K512m \
		-RTS Slides.utf8.md \
		--to beamer \
		--from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash-implicit_figures \
		--output Slides.tex \
		--highlight-style tango \
		--self-contained \
		--include-in-header style/header.tex \
		--include-before-body style/body.tex ;
	# turn off the ignorenonframetext class option (which blocks full-size images)
	grep -v "ignorenonframetext" Slides.tex > Slides2.tex ;
	mv Slides2.tex Slides.tex ;
	# run pdflatex twice to get the transparency right
	pdflatex Slides.tex ;
	pdflatex Slides.tex ;
	# remove cruft
	rm Slides.nav Slides.log Slides.aux Slides.toc Slides.snm