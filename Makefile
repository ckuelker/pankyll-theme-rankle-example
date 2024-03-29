# +---------------------------------------------------------------------------+
# | Makefile                                                                  |
# |                                                                           |
# | Pankyll-Theme-Rankle-Example                                              |
# |                                                                           |
# | Version: 0.2.1 (change inline)                                            |
# |                                                                           |
# | Changes:                                                                  |
# |                                                                           |
# | 0.2.1 2022-05-20 Christian Külker <c@c8i.org>                             |
# |     - Improve 'info' target                                               |
# |     - Add 'update' target                                                 |
# |     - Add submoduleclean dependencies                                     |
# | 0.2.0 2022-05-19 Christian Külker <c@c8i.org>                             |
# |     - Checkout submodule current branch (avoid detached HEAD)             |
# | 0.1.9 2022-05-09 Christian Külker <c@c8i.org>                             |
# |     - Add THEME                                                           |
# |     - Add repository-update to .PHONY                                     |
# |     - clean will not remove pankyll.err and pankyll.out                   |
# | 0.1.8 2021-05-18 Christian Külker <c@c8i.org>                             |
# |     - unmask pankyll run (better error visibility)                        |
# | 0.1.7 2020-05-16 Christian Külker <c@c8i.org>                             |
# |     - Add 'all' target                                                    |
# |     - Add check for pankyll binary                                        |
# |     - Add check for pandoc binary                                         |
# |     - Add check for pdflatex binary                                       |
# | 0.1.6 2020-05-13 Christian Külker <c@c8i.org>                             |
# |     - Clean pankyll.rsync                                                 |
# |     - Rename target linkcheck-local-extern to linkcheck-extern            |
# | 0.1.5 2020-04-30 Christian Külker <c@c8i.org>                             |
# |     - Use PORT variable in usage (fixes wrong value)                      |
# | 0.1.4 2020-04-29 Christian Külker <c@c8i.org>                             |
# |     - Fix server target for simple url prefix                             |
# |     - Fix build index.html for simple url prefix                          |
# | 0.1.3 2020-04-28 Christian Külker <c@c8i.org>                             |
# |     - Add more phony targets                                              |
# |     - Read configuration partly from cfg.yaml                             |
# |     - Build example root index.html                                       |
# |     - Server target supports URL prefix                                   |
# |     - Fix URL for root index.html for prefix /                            |
# | 0.1.2 2020-04-23 Christian Külker <c@c8i.org>                             |
# |     - Fix sub module update                                               |
# |     - Fix makefile version                                                |
# |     - Add submodule clean target                                          |
# |     - Add submodule-pull target                                           |
# | 0.1.1 2020-03-29 Christian Külker <c@c8i.org>                             |
# |     - Capture pankyll output: pankyll.err, pankyll.out, pankyll.log       |
# |     - Clean: removes pankyll.err, pankyll.out, pankyll.log                |
# | 0.1.0 2020-03-17 Christian Külker <c@c8i.org>                             |
# |     - Initial release                                                     |
# |                                                                           |
# +---------------------------------------------------------------------------+
#
# Makefile version
THEME:=rankle
VERSION=0.2.1
PORT=8001
NS=pankyll-theme-$(THEME)-example
# -----------------------------------------------------------------------------
# NO CHANGES BEYOND THIS POINT
ifndef VERSION
$(error VERSION is NOT defined)
endif
# Test if pankyll is installed and in the PATH
ifeq (, $(shell which pankyll))
  $(error "No pankyll in $(PATH), consider installing pankyll")
else
  PANKYLL=$(shell which pankyll)
endif
# Test if pandoc is installed and in the PATH
ifeq (, $(shell which pandoc))
  $(error "No pandoc in $(PATH), consider installing pandoc")
else
  PANDOC=$(shell which pandoc)
endif
# Test if pdflatex, installed and in the PATH
# pdflatex is default option for pandoc
ifeq (, $(shell which pdflatex))
  $(error "No pdflatex in $(PATH), consider installing pdflatex")
else
  PDFLATEX=$(shell which pdflatex)
endif
HOST=$(shell hostname)
# Python yaml 5.1 require Loader= parameter, see
# https://github.com/yaml/pyyaml/wiki/PyYAML-yaml.load(input)-Deprecation
# python3 -c "import yaml;print(yaml.load(open('cfg.yaml'), Loader=yaml.SafeLoader)['site']['public_dir'])"
PYB :=  python3 -c "import yaml;print(yaml.load(open('cfg.yaml'), Loader=yaml.SafeLoader)['
PYE := '])"
DSTD=$(shell $(PYB)site']['public_dir$(PYE))
PFX=$(shell $(PYB)site']['url$(PYE))
LOC=$(shell $(PYB)default']['l10n_locale$(PYE))
PFXDIR=$(shell echo "$(PFX)"|sed -e 's%^/%%')
NPROC=$(shell nproc)
WDIR=$(shell echo $(DSTD) $(PFXDIR)|tr ' ' '/') # public | public/PFXDIR
DEBUG_PRINT='1[$@]2[$%]3[$<]4[$?]5[$^]6[$+]7[$|]8[$*]9[$(@D)]10[$(@F)]11[$(*D)]\n12[$(*F)]13[$(%D)]14[$(%F)]15[$(<D)]16[$(<F)]17[$(^D)]18[$(^F)]\n19[$(+D)]20[$(+F)]21[$(?D)]22[$(?F)]\n'
# /webfonts/fa-regular-400 requested by all.min.css but not provided
LINKCHECK_IGNORE:=/webfonts/fa-regular-400
LINKCHECK_SERVER:=http://localhost:$(PORT)
LINKCHECK_PARAMS:=--no-status --ignore-url=$(LINKCHECK_IGNORE) -o blacklist $(LINKCHECK_SERVER)
L:=============================================================================
.PHONY: build clean htmlclean info markdownclean pdfclean realclean server \
	submodule-update test usage submoduleclean submodule-pull \
	repository-update
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
	@echo "                        and themes/pankyll-theme-$(THEME)"
	@echo "make realclean        : remove target"
	@echo "make submodule-update : update git sub-modules configuration"
	@echo "make submodule-pull   : get latest git sub-module update"
	@echo "make repository-update: update git repository"
	@echo "make build            : build project"
	@echo "make server           : start a development server on port $(PORT)"
	@echo "make all              : update realclean build server"
info:
	@echo "NS     : [$(NS)]"
	@echo "VERSION: [$(VERSION)]"
	@echo "LOC    : [$(LOC)]"
	@echo "DSTD   : [$(DSTD)]"
	@echo "PFX    : [$(PFX)]"
	@echo "PFXDIR : [$(PFXDIR)]"
	@echo "WDIR   : [$(WDIR)]"
	@echo "NPROC  : [$(NPROC)]"
	@echo "HOST   : [$(HOST)]"
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
	rm -f pankyll.log pankyll.rsync
# the make the submodule clean: WARNING changes will be lost
submoduleclean:
	cd pandoc && git checkout master
	cd content && git checkout master
	cd themes/pankyll-theme-$(THEME) && git checkout master
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
	pankyll
	@echo $(L)
	@echo "running pankyll - finished"
	@echo $(L)
	sed -i -e 's%=/en_US/index.html%=$(PFX)/$(LOC)/index.html%' $(DSTD)/index.html
	sed -i -e 's%=//en_US/index.html%=/$(LOC)/index.html%' $(DSTD)/index.html
repository-update:
	git pull
submodule-update: submoduleclean
	git submodule update --remote
	git submodule update --init --recursive --jobs $(NPROC)
	cd themes/pankyll-theme-$(THEME) && git submodule update --remote
	cd themes/pankyll-theme-$(THEME) && git submodule update --init --recursive --jobs $(NPROC)
submodule-pull: submoduleclean
	cd pandoc && git checkout master && git pull
	cd content && git checkout master && git pull
	cd themes/pankyll-theme-$(THEME) && git checkout master && git pull
update: submoduleclean submodule-update submodule-pull repository-update
server:
	@if [ "$(PFX)" = "/" ]; then \
	    echo "$(L)\nhttp://localhost:$(PORT)\nhttp://${HOST}:$(PORT)\n$(L)"; \
	else \
	    echo "$(L)\nhttp://localhost:$(PORT)/$(PFXDIR)\nhttp://${HOST}:$(PORT)/$(PFXDIR)\n$(L)"; \
	fi
	@if [ "$(PFX)" = "/" ]; then \
	    cd $(DSTD) && python3 -m http.server $(PORT);\
	else \
	    if [ -d /tmp/$(NS) ]; then rm -rf /tmp/$(NS) ]; fi; \
	    mkdir -p /tmp/$(NS)/$(WDIR);\
	    cp -a public/* /tmp/$(NS)/$(WDIR);\
	    cd /tmp/$(NS)/$(DSTD) && python3 -m http.server $(PORT);\
	fi
all: submodule-update submoduleclean submodule-pull realclean build server
linkcheck-local:
	@echo "Check local links via $(LINKCHECK_SERVER), will report broken links"
	linkchecker $(LINKCHECK_PARAMS)
	@echo "Links PASS"
linkcheck-extern:
	@echo "Check local and remote links via $(LINKCHECK_SERVER), will report broken links"
	linkchecker --check-extern $(LINKCHECK_PARAMS)
	@echo "Links PASS"
