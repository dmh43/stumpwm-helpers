;; lsdesktopf is available here: https://github.com/AndyCrowd/list-desktop-files
(defun get-program-table ()
  (let* ((response (run-shell-command "lsdesktopf" t))
         (program-list (cl-ppcre:split "\\n" response))
         (valid-programs (remove-if (lambda (entry) (cl-ppcre:scan "^#" entry)) program-list))
         (table (mapcar (lambda (entry)
                          (let ((pair (cl-ppcre:split " *# *" entry)))
                            `(,(concatenate 'string (nth 1 pair) " " (car pair)) ,(car pair))))
                        valid-programs)))
    (remove-duplicates table :test (lambda (pair1 pair2) (string= (cadr pair1) (cadr pair2))))))

(defun select-program-from-menu (program-table)
  (select-from-menu (current-screen) program-table "Run a program:"))

(defcommand launcher () (:rest)
  (run-shell-command (cadr (select-program-from-menu (get-program-table)))))