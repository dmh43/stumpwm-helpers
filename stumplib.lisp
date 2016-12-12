(defun as-command-sexp (&rest body)
  (let ((sym (intern (string (gensym)))))
    `(,sym (defcommand ,sym () () ,@body))))

(defun as-command-func (&rest body)
  (destructuring-bind (command-sym command-body) (apply 'as-command-sexp body)
    (eval command-body)
    (string command-sym)))

(defmacro as-command (&rest body)
  `(as-command-func ,@body))

(defmacro define-key-func (key-map key &rest body)
  (let ((command-string (apply 'as-command body)))
    `(define-key ,key-map ,key ,command-string)))

(defun is-emacs () (string= (window-class (current-window)) "Emacs"))

(defmacro if-emacs (yes no)
  `(if (is-emacs)
       ,yes
       ,no))

(defmacro def-non-emacs-key (key-map key body)
  `(define-key ,key-map ,key ,(as-command-func `(if-emacs
                                                 (stumpwm::send-meta-key ,(current-screen) ,key)
                                                 ,body))))

(defun get-shell-command (shell-cmd)
  (as-command `(run-shell-command ,shell-cmd)))

(defun join-with-newlines (seq) (format nil "~{~A~%~}" seq))

(defun get-last-messages ()
  (format nil "~{~A~%~}" (remove-if (lambda (str-val) (string-match str-val "^Key sequence: "))
                                    (mapcar 'first (screen-last-msg (current-screen))))))

(defun get-last-n-messages (n)
  (let* ((msgs (remove-if (lambda (str-val) (string-match str-val "^Key sequence: "))
                          (mapcar 'first (screen-last-msg (current-screen)))))
        (short (if (> (length msgs) n)
                   (subseq msgs 0 n)
                   msgs)))
    (format nil "~{~A~%~}" short)))

(defcommand echo-last-messages () () (get-last-n-messages 30))
(defcommand select-last-messages (n) ((:number "Count: "))
  (set-x-selection (get-last-n-messages n)))

;; (without-windows-placement-rules
;;     (run-shell-command "emacsclient -c -n -e '(helm-kill-ring-frame)")) ; TODO: Should have some window placement rules for emacs
