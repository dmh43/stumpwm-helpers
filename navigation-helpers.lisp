(defun chars-before-space-right ())

(defun chars-before-space-left ()
  (set-x-selection "")
  (labels ((repeater (ctr)
             (sleep 0.001)
             (stumpwm::send-meta-key (current-screen) (kbd "S-C-b"))
             (let* ((sel (get-x-selection))
                    (start-pos (search " " sel)))
               (if start-pos
                   (progn
                     (loop
                        for i from 0 to ctr
                        do (stumpwm::send-meta-key (current-screen) (kbd "C-f")))
                     (subseq sel (+ start-pos 1)))
                   (repeater (+ 1 ctr))))))
    (repeater 0)))

(message (chars-before-space-left))
