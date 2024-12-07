;; stakkelina/builtins/init.fnl

(local functions (require :stakkelina/builtins/functions))

(fn built-in?* [symbol]
  (case (. functions symbol)
    nil            false
    implementation [true implementation]))

{
  : built-in?*
}
