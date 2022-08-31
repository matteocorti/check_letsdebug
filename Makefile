PLUGIN=check_letsdebug
VERSION=`cat VERSION`
DIST_DIR=$(PLUGIN)-$(VERSION)
DIST_FILES=AUTHORS COPYING ChangeLog INSTALL Makefile NEWS README.md VERSION $(PLUGIN) $(PLUGIN).spec COPYRIGHT ${PLUGIN}.1 ${PLUGIN}.completion
YEAR=`date +"%Y"`
MONTH_YEAR=`date +"%B, %Y"`
FORMATTED_FILES=AUTHORS COPYING ChangeLog INSTALL Makefile NEWS README.md VERSION $(PLUGIN) $(PLUGIN).spec COPYRIGHT ${PLUGIN}.1 .github/workflows/* prepare_rpm.sh publish_release.sh
SCRIPTS=$(PLUGIN) prepare_rpm.sh publish_release.sh

dist: version_check formatting_check copyright_check shellcheck
	rm -rf $(DIST_DIR) $(DIST_DIR).tar.gz
	mkdir $(DIST_DIR)
	cp -r $(DIST_FILES) $(DIST_DIR)
# avoid to include extended attribute data files
# see https://superuser.com/questions/259703/get-mac-tar-to-stop-putting-filenames-in-tar-archives
	env COPYFILE_DISABLE=1 tar cfz $(DIST_DIR).tar.gz  $(DIST_DIR)
	env COPYFILE_DISABLE=1 tar cfj $(DIST_DIR).tar.bz2 $(DIST_DIR)

install:
ifndef DESTDIR
	echo "Please define DESTDIR and MANDIR variables with the installation targets"
	echo "e.g, make DESTDIR=/nagios/plugins/dir MANDIR=/nagios/plugins/man/dir install"
else
	mkdir -p $(DESTDIR)
	install -m 755 $(PLUGIN) $(DESTDIR)
	mkdir -p ${MANDIR}/man1
	install -m 644 ${PLUGIN}.1 ${MANDIR}/man1/
endif
ifdef COMPLETIONDIR
	mkdir -p $(COMPLETIONDIR)
	install -m 644 check_ssl_cert.completion $(COMPLETIONDIR)/check_ssl_cert
endif

COMPLETIONS_DIR := $(shell pkg-config --variable=completionsdir bash-completion)
install_bash_completion:
ifdef COMPLETIONS_DIR
	cp $(PLUGIN).completion $(COMPLETIONS_DIR)/$(PLUGIN)
endif

version_check:
	grep -q "VERSION\ *=\ *[\'\"]*$(VERSION)" $(PLUGIN)
	grep -q "^%define\ version\ *$(VERSION)" $(PLUGIN).spec
	grep -q -- "- $(VERSION)-" $(PLUGIN).spec
	grep -q "\"$(VERSION)\"" $(PLUGIN).1
	grep -q "${VERSION}" NEWS
	grep -q "$(MONTH_YEAR)" $(PLUGIN).1
	echo "Version check: OK"

# we check for tabs
# and remove trailing blanks
formatting_check:
	! grep -q '\\t' check_letsdebug
	! grep -q '[[:blank:]]$$' $(FORMATTED_FILES)

remove_blanks:
	sed -i '' 's/[[:blank:]]*$$//' $(FORMATTED_FILES)

SHFMT= := $(shell command -v shfmt 2> /dev/null)
format:
ifndef SHFMT
	echo "No shfmt installed"
else
# -p POSIX
# -w write to file
# -s simplify
# -i 4 indent with 4 spaces
	shfmt -p -w -s -i 4 $(SCRIPTS)
endif


clean:
	rm -f *~
	rm -rf rpmroot

distclean: clean
	rm -rf $(PLUGIN)-[0-9]*
	rm -f *.crt
	rm -f *.error

test: dist
	true
#	( export SHUNIT2="$$(pwd)/shunit2/shunit2" && cd test && ./unit_tests.sh )

SHELLCHECK := $(shell command -v shellcheck 2> /dev/null)

shellcheck:
ifndef SHELLCHECK
	echo "No shellcheck installed: skipping test"
else
	if shellcheck --help 2>&1 | grep -q -- '-o\ ' ; then shellcheck -o all check_letsdebug prepare_rpm.sh publish_release.sh ; else shellcheck check_letsdebug  prepare_rpm.sh publish_release.sh ; fi
endif

copyright_check:
	grep -q "&copy; Matteo Corti, 2021-$(YEAR)" README.md
	grep -q "Copyright (c) 2021-$(YEAR) Matteo Corti" COPYRIGHT
	grep -q "Copyright (c) 2021-$(YEAR) Matteo Corti <matteo@corti.li>" $(PLUGIN)
	echo "Copyright year check: OK"

rpm: dist
	mkdir -p rpmroot/SOURCES rpmroot/BUILD
	cp $(DIST_DIR).tar.gz rpmroot/SOURCES
	rpmbuild --define "_topdir `pwd`/rpmroot" -ba check_letsdebug.spec



.PHONY: install clean test rpm distclean
