(defvar layouts '(("QWERTY" . ("setxkbmap us -option ctrl:nocaps"))
                  ("Colemak" . ("setxkbmap us -variant colemak -option ctrl:nocaps altwin:meta_alt"))))

(defun select-layout-from-menu ()
  (select-from-menu (current-screen) layouts "Select a layout"))

(defcommand layout-switcher () ()
  (run-shell-command (cadr (select-layout-from-menu))))
