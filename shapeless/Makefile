#!/usr/bin/env make

SHELL=/bin/bash
.SHELLFLAGS = -e -c
.ONESHELL:

include make/slides.mk
include make/samples.mk

.PHONY: clean
clean: clean-slides

.PHONY: build
build: build-slides
