SLIDES_FOLDER := slides
SLIDES_BUILD_FOLDER := $(SLIDES_FOLDER)/build
REVEALJS_ARCHIVE_URL := https://github.com/hakimel/reveal.js/archive/3.8.0.tar.gz

.PHONY: build-slides
build-slides: $(SLIDES_BUILD_FOLDER)/index.html

# Download
.PHONY: download-revealjs
download-revealjs: $(SLIDES_BUILD_FOLDER)/revealjs.tar.gz

$(SLIDES_BUILD_FOLDER)/revealjs.tar.gz:
	mkdir -p "$(SLIDES_BUILD_FOLDER)"
	curl -L -o "$(SLIDES_BUILD_FOLDER)/revealjs.tar.gz" "$(REVEALJS_ARCHIVE_URL)"


# Extract
.PHONY: extract-revealjs
extract-revealjs: $(SLIDES_BUILD_FOLDER)/.extract-revealjs

.PHONY: clean-slides
clean-slides:
	rm -Rf "$(SLIDES_BUILD_FOLDER)"

$(SLIDES_BUILD_FOLDER)/.extract-revealjs: $(SLIDES_BUILD_FOLDER)/revealjs.tar.gz
	tar -xf "$(SLIDES_BUILD_FOLDER)/revealjs.tar.gz" --strip-component=1 -C "$(SLIDES_BUILD_FOLDER)"
	touch "$(SLIDES_BUILD_FOLDER)/.extract-revealjs"


# Patch
.PHONY: patch-revealjs
patch-revealjs: $(SLIDES_BUILD_FOLDER)/.patch-revealjs

$(SLIDES_BUILD_FOLDER)/.patch-revealjs: $(SLIDES_BUILD_FOLDER)/.extract-revealjs
	find "$(SLIDES_FOLDER)/patches" -name "*.patch" -print0 | xargs -0 -I {} \
    patch \
			--strip=2 \
			--unified \
			--backup \
			--forward \
			--directory="$(SLIDES_BUILD_FOLDER)" \
			--input="{}"
	mv "$(SLIDES_FOLDER)/index.html" "$(SLIDES_BUILD_FOLDER)/index.html"

.PHONY: setup-revealjs
setup-revealjs: download-revealjs extract-revealjs patch-revealjs


$(SLIDES_BUILD_FOLDER)/index.html: setup-revealjs
