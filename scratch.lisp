(defcommand scratcher () () (with-restarts-menu (message 1)))
(defcommand looper () () (dotimes (i 100000) (message (prin1-to-string i))))
(defcommand async-message () ()
  (as:with-event-loop ()
    (blackbird:with-promise (resolve reject)
                                        ;(resolve (as:delay (lambda () (message "ya aww") 1) :time 4)))
      (resolve (progn (dotimes (i 1000000000) (prin1-to-string i)) (message "ya aww") 1)))
    (message "man")))
(screen-bg-color (current-screen))

(defun ac (color)
  (xlib:alloc-color (xlib:screen-default-colormap screen-number) color))

(defvar screen-number (first (xlib:display-roots *display*)))
(defvar win (xwin-to-window (xlib:create-window
                             :parent (screen-root (current-screen))
                             :x 0 :y 0 :width 500 :height 500
                             :background 50
                             :border-width 1
                             :colormap (xlib:screen-default-colormap screen-number)
                             :border (xlib:alloc-color (xlib:screen-default-colormap screen-number) +default-border-color+)
                             :event-mask '(:exposure))))

(setf (xlib:drawable-height (window-xwin win)) 500)
(setf (xlib:drawable-width (window-xwin win)) 500)
(kill-group (current-group) (second (sort-groups (current-screen))))
(let* ((screen-root (screen-root (current-screen)))
       (screen-number (first (xlib:display-roots *display*)))
       (default-colormap (xlib:screen-default-colormap screen-number))
       (bg-color (xlib:alloc-color (xlib:screen-default-colormap screen-number) +default-background-color+))
       (border-color (xlib:alloc-color (xlib:screen-default-colormap screen-number) +default-border-color+))
       (xwin (window-xwin win))
       (px (xlib:create-pixmap :drawable xwin
                               :width (xlib:drawable-width xwin)
                               :height (xlib:drawable-height xwin)
                               :depth (xlib:drawable-depth xwin)))
       (gc (xlib:create-gcontext
            :drawable (window-xwin win)
            :font (when (typep (screen-font (current-screen)) 'xlib:font)
                    (screen-font (current-screen)))
            :foreground (alloc-color (current-screen) *mode-line-foreground-color*)
            :background (alloc-color (current-screen) *mode-line-background-color*)))
       (cc (screen-message-cc (current-screen))))
  (xlib:map-window (window-xwin win))
  (setf (xlib:window-background (window-xwin win)) 0)
  (set-window-geometry win :x 0 :y 0 :width 500 :height 500)
  (xlib:draw-rectangle px gc 0 0 300 300 t)
                                        ;(xlib:copy-area (window-xwin (current-window)) gc 0 0 30 30 (window-xwin win) 0 0 )
  (render-string "hiii" cc 0 0)
  (process-mapped-window (current-screen) xwin)
  )
(setq xwin (window-xwin win))

(setq px (xlib:create-pixmap :drawable xwin
                             :width (xlib:drawable-width xwin)
                             :height (xlib:drawable-height xwin)
                             :depth (xlib:drawable-depth xwin)))

(xlib:copy-area (window-xwin (third (group-windows (first (sort-groups (current-screen)))))) (xlib:create-gcontext
                    :drawable px
                    :font (when (typep (screen-font (current-screen)) 'xlib:font)
                            (screen-font (current-screen)))
                    :foreground (alloc-color (current-screen) *mode-line-foreground-color*)
                    :background (alloc-color (current-screen) *mode-line-background-color*))
                0 0 300 300 px 0 0)

(xlib::set-window-background xwin px)

(xlib:copy-area (window-xwin (third (group-windows (first (sort-groups (current-screen))))))
                (xlib:create-gcontext
                 :drawable xwin
                 :font (when (typep (screen-font (current-screen)) 'xlib:font)
                         (screen-font (current-screen)))
                 :foreground (alloc-color (current-screen) *mode-line-foreground-color*)
                 :background (alloc-color (current-screen) *mode-line-background-color*))
                0 0 500 500 xwin 0 0)

(xlib:draw-rectangle (window-xwin (first (group-windows (second (sort-groups (current-screen))))))
                     (xlib:create-gcontext
                      :drawable (window-xwin (first (group-windows (second (sort-groups (current-screen))))))
                      :font (when (typep (screen-font (current-screen)) 'xlib:font)
                              (screen-font (current-screen)))
                      :foreground (alloc-color (current-screen) *mode-line-foreground-color*)
                      :background (alloc-color (current-screen) *mode-line-background-color*))
                     0 0 100 100)

(windowlist)
(xlib:with-state (window-xwin win)
  (xlib:draw-rectangle (window-xwin win) (xlib:create-gcontext
                                          :drawable (window-xwin win)
                                          :font (when (typep (screen-font (current-screen)) 'xlib:font)
                                                  (screen-font (current-screen)))
                                          :foreground (alloc-color (current-screen) *mode-line-foreground-color*)
                                          :background (alloc-color (current-screen) *mode-line-background-color*))
                       0 0 100 200)

  (xlib:draw-rectangle px (xlib:create-gcontext
                           :drawable px
                           :font (when (typep (screen-font (current-screen)) 'xlib:font)
                                   (screen-font (current-screen)))
                           :foreground (alloc-color (current-screen) *mode-line-foreground-color*)
                           :background (alloc-color (current-screen) *mode-line-background-color*))
                       0 0 200 200))

(update-colors-all-screens)
