# docset

Reads, writes and checks docsets. A docset is the documentation of a language or
library as plain Lisp data: three files of keywords, strings and lists, so a
program can show it without parsing HTML. The format is in
[docs/format.md](docs/format.md).

The library is plain Common Lisp with no dependencies. It is shared by:

- **spec-browser**, which shows docsets in a window and makes the Common Lisp
  docset from the dpANS3 sources;
- **Cadre**, whose HyperSpec tab shows them beside the code;
- the generators that write them: gtk4's and raylib's own, and the **docsets**
  project for libraries such as bordeaux-threads.

## Use

```lisp
(asdf:load-system "docset")

;; Writing
(docset:write-docset #p"out/" '(:id "frobs" :title "Frobs" :packages ("FROBS") :toc ())
                     '((:entry "function/frob" :names ("frob") :kind :function
                        :kind-name "Function" :package "FROBS" :summary "Frobs."
                        :sections (("Description" (:p "Frobs."))))))

;; Reading
(defvar *docsets* (docset:find-docsets))      ; library docs/docset/ dirs and ~/.local/share/docsets/
(docset:lookup-symbol *docsets* "FROB" "FROBS") ; => ((docset . record) ...)
(docset:docset-entry (car hit) (docset:record-id (cdr hit)))

;; Checking
(docset:check-docset #p"out/")                ; prints problems, returns how many
```

## Make targets

- `make test` runs the tests (needs Quicklisp for parachute).
- `make check DIR=...` checks the docset in `DIR`.
