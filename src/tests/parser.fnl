;; tests/parser.fnl

(fn *parse-one []
  (let [parser (require :stakkelina/parser)
        parse-one parser.parse-one
        new-token #{:token-type $1 :representation $2}
        show-token #(let [{:node-type n :sub-type s :value v} $] (print n s v))]
    (show-token (parse-one (new-token :number 86.75)))
    (show-token (parse-one (new-token :symbol "butterfly")))))

(fn run []
  (print "\n**tests/parser")
  (print "\n*parse-one") (*parse-one))

{: run}
