(defun get-chars-to-slash-left ()
  (labels ((repeater (ctr)
             (stumpwm::send-meta-key (current-screen) (kbd "S-Left"))
             (sleep 0.001)
             (let* ((sel (get-x-selection))
                    (start-pos (search "/" sel)))
               (if (or start-pos (> ctr 20))
                   (subseq sel 1)
                   (repeater (+ 1 ctr))))))
    (repeater 0)))

(defun chars-to-slash-left ()
  (let ((sel (get-chars-to-slash-left)))
    (stumpwm::send-meta-key (current-screen) (kbd "Right"))
    sel))

(defun kill-to-slash-left ()
  (let* ((chars-left (chars-to-slash-left))
         (num-chars (length chars-left)))
    (loop
       for i from 1 to num-chars
       do (stumpwm::send-meta-key (current-screen) (kbd "DEL")))))
