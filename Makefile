# +---------------------------------------------------------------------------+
# | Makefile                                                                  |
# |                                                                           |
# | Pankyll-Theme-Rankle-Example                                              |
# |                                                                           |
# | Version: 0.1.2 (change inline)                                            |
# |                                                                           |
# | Changes:                                                                  |
# |                                                                           |
# | 0.1.2 2020-04-23 Christian Külker <c@c8i.org>                             |
# |     - fix sub module update                                               |
# |     - fix makefile version                                                |
# |     - add submodule clean target                                          |
# |     - add submodule-pull target                                           |
# |                                                                           |
# | 0.1.1 2020-03-29 Christian Külker <c@c8i.org>                             |
# |     - capture pankyll output: pankyll.err, pankyll.out, pankyll.log       |
# |     - clean: removes pankyll.err, pankyll.out, pankyll.log                |
# |                                                                           |
# | 0.1.0 2020-03-17 Christian Külker <c@c8i.org>                             |
# |     - initial release                                                     |
# |                                                                           |
# +---------------------------------------------------------------------------+
#
# Makefile version
VERSION=0.1.0
PORT=8001
# -----------------------------------------------------------------------------
# NO CHANGES BEYOND THIS POINT
ifndef VERSION
$(error VERSION is NOT defined)
endif
DSTD=public
NPROC=$(shell nproc)
DEBUG_PRINT='1[$@]2[$%]3[$<]4[$?]5[$^]6[$+]7[$|]8[$*]9[$(@D)]10[$(@F)]11[$(*D)]\n12[$(*F)]13[$(%D)]14[$(%F)]15[$(<D)]16[$(<F)]17[$(^D)]18[$(^F)]\n19[$(+D)]20[$(+F)]21[$(?D)]22[$(?F)]\n'
# /webfonts/fa-regular-400 requested by all.min.css but not provided
LINKCHECK_IGNORE:=/webfonts/fa-regular-400
LINKCHECK_SERVER:=http://localhost:$(PORT)
LINKCHECK_PARAMS:=--no-status --ignore-url=$(LINKCHECK_IGNORE) -o blacklist $(LINKCHECK_SERVER)
L:=============================================================================
.PHONY: build clean htmlclean info markdownclean pdfclean realclean server \
	submodule-update test usage
usage:
	@echo "$(L)"
	@echo "USAGE:"
	@echo "$(L)"
	@echo "make usage            : this information"
	@echo "make info             : print more info"
	@echo "make clean            : remove porcess files"
	@echo "make markdownclean    : remove all *.md from target (debug)"
	@echo "make htmlclean        : remove all *.html from target (debug)"
	@echo "make pdfclean         : remove all *.pdf from target (debug)"
	@echo "make submoduleclean   : remove all changes from content, pandoc"
	@echo "                        and themes/pankyll-theme-rankle"
	@echo "make realclean        : remove target"
	@echo "make submodule-update : update git sub-modules"
	@echo "make build            : build project"
	@echo "make server           : start a development server on port 8000"
info:
	@echo "VERSION: [$(VERSION)]"
	@echo "DSTD   : [$(DSTD)]"
	@echo "NPROC  : [$(NPROC)]"
	git submodule status --recursive
# for development (might remove too much or too less files for a clean build)
markdownclean:
	find $(DSTD) -name "*.md"|xargs -d '\n' rm -f
# for development (might remove too much or too less files for a clean build)
htmlclean:
	find $(DSTD) -name "*.html"|xargs -d '\n' rm -f
# for development (might remove too much or too less files for a clean build)
pdfclean:
	find $(DSTD) -name "*.pdf"|xargs -d '\n' rm -f
# for development (might remove too much or too less files for a clean build)
publicclean:
	rm -rf $(DSTD)
# clean process files
clean:
	rm -f pankyll.log pankyll.err pankyll.out
# the make the submodule clean: WARNING changes will be lost
submoduleclean:
	cd pandoc && git checkout master
	cd content && git checkout master
	cd themes/pankyll-theme-rankle && git checkout master
# clean build target
realclean: clean publicclean
test:
	@echo "$(DEBUG_PRINT)"
static:
	mkdir -p $@
$(DSTD):
	mkdir -p $@
# make sure pankyll is in your PATH
build: static $(DSTD)
	@echo "running pankyll - this can take a while (logfile: pankyll.log)"
	@echo $(L)
	pankyll 2>pankyll.err|tee -a pankyll.out
	@echo $(L)
	@echo "running pankyll - finished"
	@echo $(L)
	@cat pankyll.err
repository-update:
	git pull
submodule-update:
	git submodule update --remote
	git submodule update --init --recursive --jobs $(NPROC)
	cd themes/pankyll-theme-rankle && git submodule update --remote
	cd themes/pankyll-theme-rankle && git submodule update --init --recursive --jobs $(NPROC)
submodule-pull:
	cd pandoc && git pull
	cd content && git pull
	cd themes/pankyll-theme-rankle && git pull
server:
	@echo "$(L)\nhttp://localhost:$(PORT)\n$(L)"
	cd public && python3 -m http.server $(PORT)
linkcheck-local:
	@echo "Check local links via $(LINKCHECK_SERVER), will report broken links"
	linkchecker $(LINKCHECK_PARAMS)
	@echo "Links PASS"
linkcheck-local-extern:
	@echo "Check local and remote links via $(LINKCHECK_SERVER), will report broken links"
	linkchecker --check-extern $(LINKCHECK_PARAMS)
	@echo "Links PASS"

