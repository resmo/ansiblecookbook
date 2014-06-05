
website:
	pandoc -s -S -c style/pan-am.css README.md -o build/index.html
	cp -r style images build/
publish: website pdf html
	rsync -avz --delete build/  ansiblecookbook.com:/var/www/ansiblecookbook.com/www/public
pdf:
	mkdir -p build/downloads
	pandoc --latex-engine=xelatex --template=mytemplate.tex \
		--variable mainfont="DejaVu Serif" \
		--variable sansfont="DejaVu Sans" \
		--variable monofont="DejaVu Sans Mono" \
		--variable fontsize=11pt \
		--variable version="$$(cat VERSION) - Licensed under CC BY-NC-SA 3.0 - $$(date --universal )" \
		--variable author="René Moser" \
		--variable title="Ansible Cookbook 2014" \
		--variable date="$$(date --universal)" \
		--highlight-style=zenburn \
		--toc en/*/*.md -o build/downloads/ansiblecookbook.en.pdf
html:
	mkdir -p build/html
	pandoc --toc -s -S -c style/style.css en/*/*.md -o build/html/en.html
	cp -r style images build/html/
