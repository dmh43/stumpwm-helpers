(defun chars-before-space-right ())

(defun chars-before-space-left ()
  (set-x-selection "")
  (labels ((repeater (ctr)
             (sleep 0.001)
             (stumpwm::send-meta-key (current-screen) (kbd "S-Left"))
             (let* ((sel (get-x-selection))
                    (start-pos (search " " sel)))
               (if start-pos
                   (progn
                     (loop
                        for i from 0 to ctr
                        do (stumpwm::send-meta-key (current-screen) (kbd "Right")))
                     (subseq sel (+ start-pos 1)))
                   (repeater (+ 1 ctr))))))
    (repeater 0)))

(defun kill-till-space-left ()
  (let* ((chars-left (chars-before-space-left))
         (num-chars (length chars-left)))
    (sleep 0.5)
    (loop
       for i from 0 to num-chars
       do (progn
            (sleep 0.1)
            (stumpwm::send-meta-key (current-screen) (kbd "DEL"))))))
