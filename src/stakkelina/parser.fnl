;; repl/parser.fnl
;;
;; The functions needed to convert Stakkelina code into
;; an abstract syntax tree.

(local builtins (require stakkelina/builtins))

(fn token-type [token] (. token :token-type))
(fn representation [token] (. token :representation))

(fn parse-token [token]
  "Takes a token and returns the equivalent abstract
   syntax tree node."
  (case (token-type token)
    :number {:node-type :literal
             :sub-type  :number
             :value     (tonumber (representation token))}
    :symbol {:node-type :symbol
             :value     (representation token)}
    :symbol (case (builtins.built-in?* token))
    () ()
    () ())
