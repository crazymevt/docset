# docset

Reads, writes and checks docsets. A docset is the documentation of a language or
library as plain Lisp data: three files of keywords, strings and lists, so a
program can show it without parsing HTML. The format is in
[docs/format.md](docs/format.md).

The library is plain Common Lisp with no dependencies. It is shared by:

- **[spec-browser](https://github.com/crazymevt/spec-browser)**, which shows docsets in a window and makes the Common Lisp
  docset from the dpANS3 sources;
- **[Cadre](https://github.com/crazymevt/cadre-editor)**, whose HyperSpec tab
  shows them beside the code;
- the generators that write them: [gtk4](https://github.com/crazymevt/gtk4)'s
  and [raylib](https://github.com/crazymevt/raylib)'s own, and the [docsets](https://github.com/crazymevt/docsets)
  project for libraries such as bordeaux-threads.

## Installing

It isn't in Quicklisp's dist. Check it out and link it where Quicklisp finds
local projects:

```sh
git clone https://github.com/crazymevt/docset.git ~/projects/lisp/docset
ln -s ~/projects/lisp/docset ~/quicklisp/local-projects/docset
```

Then `(ql:quickload :docset)`, or `(asdf:load-system "docset")` once ASDF can
find it. If Quicklisp doesn't see a new link, run
`(ql:register-local-projects)` once. The library needs nothing else; the
tests need parachute, which Quicklisp fetches.

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
