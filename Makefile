SHELL  = /bin/bash

TSDIR   ?= $(CURDIR)/tree-sitter-sql
TESTDIR ?= $(CURDIR)/test
BINDIR  ?= $(CURDIR)/bin

all:
	@

dev: $(TSDIR)
$(TSDIR):
	@git clone --depth=1 https://github.com/DerekStride/tree-sitter-sql
	@printf "\33[1m\33[31mNote\33[22m npm build can take a while" >&2
	cd $(TSDIR) && npm --loglevel=info --progress=true install

.PHONY: parse-% extract-tests
extract-tests:
	@cd $(TSDIR)/test/corpus && find . -type f -name "*.txt" -print0 | \
		while IFS= read -r -d '' f; do                             \
		ff="$$(basename $$f)";                                     \
		$(BINDIR)/examples.rb < $$f > $(TESTDIR)/$${ff%.*}.sql;    \
	done

parse-%:
	cd $(TSDIR) && npx tree-sitter parse $(TESTDIR)/$(subst parse-,,$@)

clean:
	$(RM) -r *~

distclean: clean
	$(RM) -rf $$(git ls-files --others --ignored --exclude-standard)
