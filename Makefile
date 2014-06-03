
website:
	pandoc -s -S -c style/pan-am.css README.md -o build/index.html
	cp -r style images build/
publish: website pdf
	rsync -avz --delete build/  ansiblecookbook.com:/var/www/ansiblecookbook.com/www/public
pdf:
	mkdir -p build/downloads
	pandoc --template=mytemplate.tex \
		--variable mainfont="Georgia" \
		--variable sansfont="Bitstream Vera Sans" \
		--variable monofont="Bitstream Vera Sans Mono" \
		--variable fontsize=12pt \
		--variable version="$$(date --universal --rfc-2822)" \
		--toc en/*/*.md -o build/downloads/ansiblecookbook.en.pdf
