;; tests/parser.fnl

(fn *parse-token []
  (let [parser (require :stakkelina/parser)
        parse-token parser.parse-token
        new-token #{:token-type $1 :representation $2}
        show-token #(let [{:node-type n :sub-type s :value v} $] (print n s v))]
    (show-token (parse-token (new-token :number 86.75)))
    (show-token (parse-token (new-token :symbol "butterfly")))))

(fn run []
  (print "\n**tests/parser")
  (print "\n*parse-token") (*parse-token))

{: run}
