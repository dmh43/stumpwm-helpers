(defvar floating ())

(defcommand float-this () ()
  (let* ((w (current-window))
         (g (current-group))
         (f (tile-group-current-frame g))
         (tree (tile-group-frame-tree g)))
    (change-class w 'stumpwm.floating-group::float-window)
    (stumpwm.floating-group::float-window-align w)
    (push w floating)
    ;;(sync-frame-windows g f)
    (setf (tile-group-frame-tree g)
          (funcall-on-leaf tree f (lambda (f)
                                    (let ((frame (copy-structure f)))
                                      (setf (slot-value frame 'window) nil)
                                      frame))))))

(defcommand unfloat-this () ()
  (let* ((g (current-group))
        (frame (first (group-frames g)))
        (w (current-window)))
    (change-class w 'tile-window :frame frame)
    (setf (window-frame w) frame
          (frame-window frame) w
          (tile-group-current-frame g) frame)
    (setq floating (remove w floating))
    (update-decoration w)
    (sync-frame-windows g frame)))
