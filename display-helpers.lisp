(defvar *external-display-enabled* nil)

(defcommand toggle-display () ()
  (if *external-display-enabled*
      (run-shell-command "xrandr --output VGA1 --off --output LVDS1 --below VGA1 --auto")
      (run-shell-command "xrandr --output VGA1 --primary --auto --output LVDS1 --below VGA1 --auto"))
  (setf *external-display-enabled* (not *external-display-enabled*)))
