.PHONY: resume watch clean

resume: resume.pdf index.html

watch:
	@command -v entr >/dev/null 2>&1 || { echo >&2 "entr is not installed. Please install entr to use the watch feature."; exit 1; }
	ls *.md *.css | entr make resume

name := $(shell grep "^\#" resume.md | head -1 | sed -e 's/^\#[[:space:]]*//' | xargs)

index.html: preamble.html resume.md postamble.html
	cat preamble.html | sed -e 's/___NAME___/$(name)/' > $@
	python -m markdown -x smarty resume.md >> $@
	cat postamble.html >> $@

resume.pdf: index.html resume.css
	weasyprint index.html resume.pdf

clean:
	rm -f index.html resume.pdf
