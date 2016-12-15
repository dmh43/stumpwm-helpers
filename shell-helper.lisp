;; (setq clone-path "/home/dany/harp")

;; (defcommand clone-repo () ()
;;   (let* (;(sel (get-x-selection))
;;          (sel "git@github.com:dmh43/harp-mode.git")
;;          (elisp (concatenate 'string
;;                              "'(open-git-project" " " "\"" clone-path "\"" " " "\"" sel "\"" ")'")))

;;     (message (run-shell-command (concatenate 'string "git clone" " " sel " " clone-path) t))
;;     (message (run-shell-command (concatenate 'string "emacsclient -e" " " elisp) t))))



;; (redirect-all-output (data-dir-file "debug-output" "txt"))

;; (setq *debug-level* 1)
