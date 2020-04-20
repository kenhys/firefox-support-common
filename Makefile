# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

VERSION = 1.1

DATE=$(shell date +%Y%m%d)
UPDATES_PDF = "Firefox_$(DATE).pdf"
BASE=$(shell pwd)

PANDOC_OPT_PDF= -N --toc-depth=2 --table-of-contents \
                -f markdown+ignore_line_breaks \
                -V documentclass=ltjsarticle \
                -V classoption=titlepage \
                --latex-engine=lualatex
PANDOC_OPT_DOCX= -N --toc-depth=2 --table-of-contents \
                 -f markdown+ignore_line_breaks \
                 -V documentclass=ltjsarticle \
                 -V classoption=titlepage \
                 -t docx \
                 --reference-doc="$(BASE)/template.docx"


all: config.xlsx

config.xlsx: build-xlsx esr60/*
	./build-xlsx

fetch-policies-schema:
	rm -f policies-schema.json
	wget https://hg.mozilla.org/mozilla-central/raw-file/tip/browser/components/enterprisepolicies/schemas/policies-schema.json

list-untracked-policies:
	cat policies-schema.json | jq -r 'select(.. | .properties?).properties | keys[]' | sort | uniq | while read key; do grep -r "\"$${key}\"" esr* >/dev/null 2>&1 || echo "$${key}"; done

list-unverified-configs:
	bash -c 'grep -r -E -v  "^ " esr* | cut -d : -f 2- | sort | cut -d : -f 1 | uniq | grep -v -f <(grep -r -E -v  "^ " esr* | grep 廃止 | cut -d : -f 2 | sort | uniq) | while read key; do grep -E "$${key}[^0-9]" manual.md >/dev/null 2>&1 || echo "$${key}"; done'

updates:
	cd esr78/updates && cat updates.md | pandoc ${PANDOC_OPT_DOCX} -o "updates-esr78-$(DATE).docx" && mv *.docx ../../
#	cd esr78/updates && cat updates.md | pandoc ${PANDOC_OPT_PDF} -o "updates-esr78-$(DATE).pdf" && mv *.pdf ../../

clean:
	rm -f config.xlsx updates-*.docx updates-*.pdf

.PHONY: fetch-policies-schema list-untracked-policies clean all
