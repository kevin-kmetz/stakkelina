;; stakkelina/macros.fnl

(fn zoo [thing]
  (if (list? thing)
    true
    false))

(fn boo [thing]
  (print thing)
  (print (= thing (sym "a")))
  (if (sym? thing)
    true
    false))

(fn zibzorb [thing]
  `(do
     (print "hello")
     (print "and")
     (print "goodbye")))
{
  : zoo
  : boo
  : zibzorb
}
