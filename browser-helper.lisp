;; Web jump (works for Google and Imdb)
(defmacro make-web-jump (name prefix)
  `(defcommand ,(intern name) (search) ((:rest ,(concatenate 'string name " search: ")))
               (substitute #\+ #\Space search)
               (run-shell-command (concatenate 'string ,prefix search))))

(make-web-jump "google" "chromium http://www.google.fr/search?q=")

(defcommand chrome () ()
  "Start chrome unless it is already running, in which case focus it."
  (run-or-raise "chromium" '(:class "Chromium")))

(defcommand firefox () ()
  "Start firefox unless it is already running, in which case focus it."
  (run-or-raise "firefox" '(:class "Firefox")))
