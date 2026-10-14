# Makefile for docset. Needs Quicklisp (for the tests' parachute), loaded from your Lisp's init file.

LISP ?= sbcl
RUN = $(LISP) --non-interactive --eval '(require :asdf)' --eval '(push (truename ".") asdf:*central-registry*)'

.PHONY: test check clean

test:
	$(RUN) --eval '(ql:quickload :docset/tests :silent t)' \
		--eval '(uiop:quit (if (eq :passed (parachute:status (parachute:test :docset/tests))) 0 1))'

# Check the docset in DIR: make check DIR=~/.local/share/docsets/bordeaux-threads
check:
	$(RUN) --eval '(asdf:load-system :docset)' \
		--eval '(uiop:quit (if (zerop (docset:check-docset "$(DIR)")) 0 1))'

clean:
	find . -name '*.fasl' -delete
