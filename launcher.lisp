;; lsdesktopf is available here: https://github.com/AndyCrowd/list-desktop-files
(defun parse-program-table (response)
  (let* ((program-list (cl-ppcre:split "\\n" response))
         (valid-programs (remove-if (lambda (entry) (cl-ppcre:scan "^#" entry)) program-list))
         (table (mapcar (lambda (entry)
                          (let ((pair (cl-ppcre:split " *# *" entry)))
                            `(,(concatenate 'string (nth 1 pair) " " (car pair)) ,(car pair))))
                        valid-programs)))
    (remove-duplicates table :test (lambda (pair1 pair2) (string= (cadr pair1) (cadr pair2))))))

(defun cache-program-table (cache-path)
  (with-open-file (s cache-path :direction :output :if-exists :supersede)
    (write-string (run-shell-command "lsdesktopf" t) s)))

(defun get-program-table (cache-path)
  (with-open-file (s cache-path :if-does-not-exist nil)
    (if (streamp s)
        (let ((program-table (make-string (file-length s))))
          (read-sequence program-table s)
          (parse-program-table program-table))
        (progn
          (cache-program-table cache-path)
          (get-program-table cache-path)))))

(defun select-program-from-menu (program-table)
  (select-from-menu (current-screen) program-table "Run a program:"))

(defun drop-file-specifier (desktop-entry)
  (cl-ppcre:scan-to-strings "[^ ]+" desktop-entry))

(defcommand launcher () (:rest)
  (run-shell-command (drop-file-specifier
                      (cadr (select-program-from-menu (get-program-table #P"~/deskcache")))))
  (sb-thread:make-thread (lambda () (cache-program-table #P"~/deskcache")))
  nil)
