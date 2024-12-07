;; stakkelina/repl.fnl

(fn quit-repl []
  (print " === Goodbye! === "))

(fn get-input-one-line []
  (io.write ">> ")
  (io.read))

(fn repl-command? [string_]
  (if (= "," (string.sub string_ 1 1))
    true
    false))

(fn loop-once []
  (let [user-input (get-input-one-line)]
    (if (repl-command? user-input)
      (quit-repl)
      (do ;(interpreter.evaluate)
          (print (.. "Should interpret " user-input))
          (loop-once)
          ))))

(fn start-repl []
  (print " === Stakkelina REPL v0.1.0 ===")
  (loop-once))

{
  : quit-repl
  : get-input-one-line
  : repl-command?
  : loop-once
  : start-repl
}
