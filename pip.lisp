(defun ac (color)
  (xlib:alloc-color (xlib:screen-default-colormap screen-number) color))

(defvar screen-number (first (xlib:display-roots *display*)))

(setq geany (first (group-windows (first (sort-groups (current-screen))))))

(setq win (xwin-to-window (xlib:create-window
                             :parent (screen-root (current-screen))
                             :x 0 :y 0 :width 500 :height 500
                             :background 50
                             :border-width 1
                             :colormap (xlib:screen-default-colormap screen-number)
                             :border (xlib:alloc-color (xlib:screen-default-colormap screen-number) +default-border-color+)
                             :event-mask '(:exposure))))

(setq xwin (window-xwin win))

(setf (xlib:drawable-height xwin) 500)

(setf (xlib:drawable-width xwin) 500)

(xlib:map-window (window-xwin win))

(process-mapped-window (current-screen) xwin)

(setq px (xlib:create-pixmap :drawable xwin
                             :width (xlib:drawable-width xwin)
                             :height (xlib:drawable-height xwin)
                             :depth (xlib:drawable-depth xwin)))

(xlib:copy-area (window-xwin geany)
                (xlib:create-gcontext
                 :drawable px
                 :font (when (typep (screen-font (current-screen)) 'xlib:font)
                         (screen-font (current-screen)))
                 :foreground (alloc-color (current-screen) *mode-line-foreground-color*)
                 :background (alloc-color (current-screen) *mode-line-background-color*))
                0 0 500 500 px 0 0)

(xlib::set-window-background xwin px)

(pull-hidden-next)
(gnext)
