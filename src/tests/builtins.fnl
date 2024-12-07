;; tests/builtins.fnl

(fn *built-in?* []
  (let [built-ins (require :stakkelina/builtins)
        has? built-ins.built-in?*]
    (print (has? "println"))
    (print (has? "printlnlnln"))
    (print (has? "+"))
    (print (has? "giraffe"))
    (print (has? "snowman"))))

(fn run []
  (print "\n**tests/builtins")
  (print "\nbuilt-in?*") (*built-in?*))

{: run}
