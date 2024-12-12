;; tests/builtins.fnl

(local fennel/view (. (require :fennel) :view))

(fn pp [printable]
  (print (fennel/view printable) "\n"))

(fn *built-in?* []
  (let [built-ins (require :stakkelina/builtins)
        has? built-ins.built-in?*]
    (pp (has? "println"))
    (pp (has? "printlnlnln"))
    (pp (has? "+"))
    (pp (has? "giraffe"))
    (pp (has? "snowman"))))

(fn run []
  (print "\n**tests/builtins")
  (print "\nbuilt-in?*") (*built-in?*))

{: run}
