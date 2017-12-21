(defcommand class-windows (&optional class-name
                                     (fmt *window-format*)
                                     window-list) (:rest)
  (let* ((window-list (or window-list
                          (sort-windows-by-number
                           (group-windows (current-group)))))
         (class-list (remove-if-not (lambda (window)
                                     (equal (window-class window)
                                            class-name))
                                   window-list)))
    (if (null window-list)
        (message "No Managed Windows")
        (let ((window (select-window-from-menu class-list fmt)))
          (if window
              (group-focus-window (current-group) window)
              (throw 'error :abort))))))
