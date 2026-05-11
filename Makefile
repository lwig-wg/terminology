TEXT_PAGINATION := true
LIBDIR := lib
include $(LIBDIR)/main.mk

$(LIBDIR)/main.mk:
ifneq (,$(shell grep "path *= *$(LIBDIR)" .gitmodules 2>/dev/null))
	git submodule sync
	git submodule update $(CLONE_ARGS) --init
else
	git clone -q --depth 10 $(CLONE_ARGS) \
	    -b main https://github.com/martinthomson/i-d-template $(LIBDIR)
endif

prep: lists.md

lists.md: draft-ietf-iotops-7228bis.xml
	kramdown-rfc-extract-figures-tables -trfc $< >$@.new
	if cmp $@.new $@; then rm -v $@.new; else mv -v $@.new $@; fi
