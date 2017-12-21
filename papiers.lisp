(defun get-names (papiers-result)
  (let* ((items (cl-ppcre:split "\\n" papiers-result))
         (filtered-items (remove-if-not (lambda (item) (cl-ppcre:scan "^#" item)) items)))
    (mapcar (lambda (item) (cadr (cl-ppcre:split "^# [0-9]+ : " item))) filtered-items)))

(defun get-paths (papiers-result)
  (let* ((items (cl-ppcre:split "\\n" papiers-result))
         (filtered-items (remove-if-not (lambda (item) (cl-ppcre:scan "^Source" item)) items)))
    (mapcar (lambda (item) (cadr (cl-ppcre:split "^Source +: +#[0-9]+: +" item))) filtered-items)))

(defun get-pdf-table (query)
  (let* ((result (run-shell-command (concatenate 'string "(cd /home/dany/Documents/Documentation; papiers search " query ")") t))
         (names (get-names result))
         (paths (get-paths result)))
    (mapcar 'list names paths)))

(defun select-pdf-from-menu (pdf-table)
  (select-from-menu (current-screen) pdf-table "Choose a PDF:"))

(defcommand papiers () ()
  (run-shell-command (format nil "~{~A~^ '~}'" `("xdg-open" ,(cadr (select-pdf-from-menu
                                                                    (get-pdf-table (read-one-line (current-screen) "Papiers Query: ")))))))
  nil)

(defcommand papiers-path () ()
  (run-shell-command (format nil "~{~A~^ '~' '~}" `("echo"
                                                      ,(cadr (select-pdf-from-menu
                                                              (get-pdf-table (read-one-line (current-screen) "Papiers Query: "))))
                                                      " | xclip -selection clipboard")))
  nil)
