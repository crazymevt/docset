;;;; docset.asd

(defsystem "docset"
  :description "Reads, writes and checks docsets: the documentation of a language or library as plain Lisp data. No dependencies."
  :author "Jessie Hughart"
  :license "MIT"
  :version "1.0.0"
  :components ((:module "src"
                :serial t
                :components ((:file "package")
                             (:file "docset")
                             (:file "check"))))
  :in-order-to ((test-op (test-op "docset/tests"))))

(defsystem "docset/tests"
  :description "Tests of writing, reading and checking a docset."
  :author "Jessie Hughart"
  :license "MIT"
  :depends-on ("docset" "parachute")
  :components ((:file "tests/docset"))
  :perform (test-op (o c) (uiop:symbol-call :parachute :test :docset/tests)))
