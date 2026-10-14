;;;; docset.lisp — writes a small docset, reads it back, and checks it.

(defpackage #:docset/tests
  (:use #:cl #:parachute))

(in-package #:docset/tests)

(defparameter *entries*
  '((:entry "function/frob" :names ("frob") :kind :function :kind-name "Function"
     :package "FROBS" :summary "Frobs a widget."
     :sections (("Description" (:p "Frobs " (:param "widget") ", like " (:ref "variable/*frob*" "*frob*") "."))))
    (:entry "variable/*frob*" :names ("*frob*") :kind :variable :kind-name "Variable"
     :package "FROBS" :summary "How hard to frob.")
    (:entry "glossary/frob" :names ("frob") :kind :glossary :kind-name "Glossary"
     :summary "frob n. A thing that is frobbed.")))

(defun call-with-docset (function)
  "Writes the docset to a new ROOT/frobs/ and calls FUNCTION with that directory and ROOT."
  (let* ((root (merge-pathnames (format nil "docset-test-~D/" (random 1000000 (make-random-state t)))
                                (uiop:temporary-directory)))
         (dir (merge-pathnames "frobs/" root)))
    (unwind-protect
         (progn (docset:write-docset dir '(:id "frobs" :title "Frobs" :packages ("FROBS")
                                           :toc ((:title "Frob" :entry "function/frob")))
                                     *entries*)
                (funcall function dir root))
      (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore))))

(define-test docset/tests)

(define-test round-trip
  :parent docset/tests
  (call-with-docset
   (lambda (dir root)
     (declare (ignore root))
     (let ((d (docset:open-docset dir)))
       (is equal "frobs" (docset:docset-id d))
       (is = 3 (getf (docset:docset-manifest d) :entry-count))
       (is equal (first *entries*) (docset:docset-entry d "function/frob"))
       (is equal (third *entries*) (docset:docset-entry d "glossary/frob"))
       (is equal "Frobs a widget." (docset:record-summary (docset:entry-record d "function/frob")))))))

(define-test lookup
  :parent docset/tests
  (call-with-docset
   (lambda (dir root)
     (declare (ignore root))
     (let ((d (docset:open-docset dir)))
       ;; The symbol's own entry before the glossary term, whatever the case
       (is equal '("function/frob" "glossary/frob")
           (mapcar (lambda (hit) (docset:record-id (cdr hit))) (docset:lookup-symbol (list d) "FROB" "frobs")))
       (is equal '("glossary/frob")
           (mapcar (lambda (hit) (docset:record-id (cdr hit))) (docset:lookup-symbol (list d) "frob" "OTHER")))
       (is equal '("*frob*") (docset:record-names (first (docset:search-names d "*fr"))))))))

(define-test find-docsets
  :parent docset/tests
  (call-with-docset
   (lambda (dir root)
     (declare (ignore dir))
     ;; The same directory twice: the docset is opened once
     (let ((found (docset:find-docsets :directories (list root root) :systems '() :user nil)))
       (is equal '("frobs") (mapcar #'docset:docset-id found))))))

(define-test check
  :parent docset/tests
  (call-with-docset
   (lambda (dir root)
     (declare (ignore root))
     (is = 0 (docset:check-docset dir :stream (make-broadcast-stream))))))
