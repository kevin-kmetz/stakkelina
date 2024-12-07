;; stakkelina/builtins.fnl

{
  :print {:type :function
          :operands 1
          :return-values 0
          :definition (lambda [text]
                        (io.write text))}
  :println {:type :function
            :operands 1
            :return-values 0
            :definition (lambda [text]
                          (io.write text "\n"))}
  :printlnln {:type :function
              :operands 1
              :return-values 0
              :definition (lambda [text]
                            (io.write text "\n\n"))}
  :printlnlnln {:type :function
                :operands 1
                :return-values 0
                :definition (lambda [text]
                              (io.write text "\n\n\n"))}
  "+" {:type :function
             :operands 2
             :return-values 1
             :definition (lambda [a b]
                           (+ a b))}
  "-" {:type :function
             :operands 2
             :return-values 1
             :definition (lambda [a b]
                           (- a b))}
  "*" {:type :function
       :operands 2
       :return-values 1
       :definition (lambda [a b]
                     (* a b))}
  "/" {:type :function
       :operands 2
       :return-values
       :definition (lambda [a b]
                     (/ a b))}
}
