# sed -n 's/^	//p' $? > $@

.PHONY: all install publish

all:
	@echo "usage:"
	@echo " - install: install/replace the files in the system"
	@echo " - publish: generate gemini and www version of the files"
	@echo " - serve-gem: serve the gem directory"
	@echo " - serve-www: serve the www directory"
	@echo " - upload: publish the files on the geminispace and the web"
	@echo " - clean: undo publish"

include Makefile.local

index.lp: README.md ${XXXFILES:=.lp}
	cp README.md $@
	printf "\n\n### Files\n\n" >> $@
	for f in ${XXXFILES}; do printf "=> %s.EXT %s\n" "$$f" "$$f"; done>> $@

install: ${DOTFILES}

www: style.css
	mkdir -p www
	cp style.css www

gem:
	mkdir gem

publish: gem ${GEMFILES} www ${WWWFILES}

serve-gem: publish
	gmid -p 1966 gem

serve-www: publish
	python3 -m http.server --directory www 8888

upload:
	rsync --delete -a gem/ op:gemini/dots.omarpolo.com
	rsync --delete -a www/ op:sites/dots.omarpolo.com

clean:
	rm -rf gem www index.lsp
