(defvar floating ())

(defcommand float-this () ()
  (let* ((w (current-window))
         (g (current-group))
         (f (tile-group-current-frame g))
         (tree (tile-group-frame-tree g)))
    (change-class w 'stumpwm.floating-group::float-window)
    (stumpwm.floating-group::float-window-align w)
    (push w floating)
    (sync-frame-windows g (frame-by-number g 0))
    (setf (tile-group-frame-tree g)
          (funcall-on-leaf tree f (lambda (f)
                                    (let ((frame (copy-structure f)))
                                      (setf (slot-value frame 'window) nil)
                                      frame))))))

(defcommand unfloat-last () ()
  (let ((frame (frame-by-number (current-group) 0))
        (w (first floating)))
    (change-class w 'tile-window :frame frame)
    (setf (window-frame w) (first (group-windows (current-group))))
    (setq floating (rest floating))
    (sync-frame-windows (current-group) frame)))
