(defun into-clipboard (text)
  (run-shell-command (format nil "emacsclient -e '(kill-new ~S)'" text)))

(defcommand url-copy () ()
  (let* ((sel (get-x-selection)))
    (multiple-value-bind (match)
        (cl-ppcre::scan-to-strings "((https?://)?(www\.)?[a-z]+[.][a-z]{2,3}[^ .]+)" sel)
      (into-clipboard match))))

(defcommand in-quotes-copy () ()
  (let ((sel (get-x-selection)))
    (multiple-value-bind (_ matches)
        (cl-ppcre::scan-to-strings "('|\")([^\\1]+)(\\1)" sel)
      (into-clipboard (svref matches 1)))))

(defcommand normal-copy () ()
  (stumpwm::send-meta-key (current-screen) (kbd "C-c")))
