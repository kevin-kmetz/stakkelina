;; stakkelina/interpreter.fnl

(local built-ins (require :stakkelina/builtins))
(local stack (require :stakkelina/stack))

;; I will need to differentiate between a frame stack
;; and a local stack within a given frame. Frame will
;; almost certainly need to be its own module.
(fn initialize-interpeter []
  "Provides a fresh program state."
  {:symbol-table "not yet"
   :stack (stack.create-stack)
   :heap "a heap"})

(fn evaluate-built-in-symbol [func-name program-state]
  nil)

;; I know that eventually I'll actually have to consolidate the
;; symbols back into one type, since it shouldn't be known ahead
;; of time whether a symbol represents a function or a variable,
;; whether built-in or not. Just doing it like this for now to
;; something moving, but will obviously re-write.
(fn evaluate-node [node program-state]
  (let [[node-type sub-type value] node]
    (case [node-type sub-type]
      [:literal :number] (stack.push value (. program-state :stack))
      [:literal :string] (stack.push value (. program-state :stack))
      [:symbol :created] nil
      [:symbol :built-in] (evaluate-built-in-symbol value program-state)
      _ (error "Unhandled exception in function 'evaluate-node' - unrecognized node type."))))

(fn evaluate-sequence [nodes program-state]
  nil)

(fn interpret [code program-state]
  nil)
