BUILD_FOLDER := slides/build
REVEALJS_ARCHIVE_URL := https://github.com/hakimel/reveal.js/archive/3.8.0.tar.gz

.PHONY: slides
slides: $(BUILD_FOLDER)/index.html
	cd "$(BUILD_FOLDER)"
	firefox "./index.html"

# Download
.PHONY: download-revealjs
download-revealjs: $(BUILD_FOLDER)/revealjs.tar.gz

$(BUILD_FOLDER)/revealjs.tar.gz:
	mkdir -p "$(BUILD_FOLDER)"
	curl "$(REVEALJS_ARCHIVE_URL)" -O "$(BUILD_FOLDER)/revealjs.tar.gz"


# Extract
.PHONY: extract-revealjs
extract-revealjs: $(BUILD_FOLDER)/.extract-revealjs

$(BUILD_FOLDER)/.extract-revealjs: $(BUILD_FOLDER)/revealjs.tar.gz
	tar -zxvf "$(BUILD_FOLDER)/revealjs.tar.gz" -C "$(BUILD_FOLDER)"


$(BUILD_FOLDER)/index.html: $(BUILD_FOLDER)/revealjs.tar.gz
