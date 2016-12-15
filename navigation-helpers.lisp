(defun chars-before-space-right ())

(defun chars-before-space-left ()
  (labels ((repeater ()
             (stumpwm::send-meta-key (current-screen) (kbd "S-C-b"))
             (let* ((sel (get-x-selection))
                    (start-pos (search " " sel)))
               (if start-pos
                   (subseq sel (+ start-pos 1))
                   (repeater)))))
    (repeater)))

(message (chars-before-space-left))
