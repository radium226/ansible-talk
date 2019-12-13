BUILD_FOLDER := slides/build
REVEALJS_ARCHIVE_URL := https://github.com/hakimel/reveal.js/archive/3.8.0.tar.gz

.PHONY: build-slides
build-slides: $(BUILD_FOLDER)/index.html

# Download
.PHONY: download-revealjs
download-revealjs: $(BUILD_FOLDER)/revealjs.tar.gz

$(BUILD_FOLDER)/revealjs.tar.gz:
	mkdir -p "$(BUILD_FOLDER)"
	curl -L -o "$(BUILD_FOLDER)/revealjs.tar.gz" "$(REVEALJS_ARCHIVE_URL)"


# Extract
.PHONY: extract-revealjs
extract-revealjs: $(BUILD_FOLDER)/.extract-revealjs

.PHONY: clean-slides
clean-slides:
	rm -Rf "$(BUILD_FOLDER)"

$(BUILD_FOLDER)/.extract-revealjs: $(BUILD_FOLDER)/revealjs.tar.gz
	tar -xf "$(BUILD_FOLDER)/revealjs.tar.gz" --strip-component=1 -C "$(BUILD_FOLDER)"
	touch "$(BUILD_FOLDER)/.extract-revealjs"


# Patch
.PHONY: patch-revealjs
patch-revealjs: $(BUILD_FOLDER)/.patch-revealjs

$(BUILD_FOLDER)/.patch-revealjs: $(BUILD_FOLDER)/.extract-revealjs
	mv "$(BUILD_FOLDER)/index.html" "$(BUILD_FOLDER)/index.html-BACKUP"
	false

.PHONY: setup-revealjs
setup-revealjs: download-revealjs extract-revealjs patch-revealjs


$(BUILD_FOLDER)/index.html: setup-revealjs
