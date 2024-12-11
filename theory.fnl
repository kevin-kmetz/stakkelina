;; theory.fnl

(local fennel (require :fennel))

(set fennel.path (.. fennel.path ";./src/?.fnl;"));./src/tests/?.fnl;./src/stakkelina/?.fnl;"))

(local test (require :tests/lexer))

(test.run)

;; (each [index test (ipairs tests)]
;;   (if (not (= (type test) :string))
;;     (test.run)))
