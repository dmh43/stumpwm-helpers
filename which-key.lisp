(defun get-key-cmd-strs (bindings &optional colored?)
  (mapcan
   (lambda (binding)
     (concat
      (print-key (slot-value binding 'key))
      (string (slot-value binding 'command))))
   bindings))

(message-no-timeout "Prefix: ~a~%~{~a~^~%~}"
                    (print-key-seq `(,(kbd "C-t")))
                    (columnize (let ((maps (concatenate 'list (stumpwm::top-maps) '(stumpwm::*root-map*))))
                                 (mapcar (lambda (map)
                                           (get-key-cmd-strs (slot-value map 'bindings) t))
                                         (stumpwm::dereference-kmaps maps)))
                               2))

(defun get-keymaps-at-);;; TODO: this should be a 1 level of the below function

(defun get-keymaps-at-key-seq (keymaps key-seq)
  (reduce
   (lambda (result map)
     (let ((command (find key-seq (kmap-bindings map)
                          :key 'binding-key :test 'equalp)))
       (if command
           (setf result (cons command result))
           result)))
   keymaps
   :initial-value '()))

(get-keymaps-at-key-seq (dereference-kmaps (top-maps)) (kbd "C-t"))

(defun which-key-for-keymaps (key-seq keymaps)
  (let* ((screen (current-screen))
         (keymaps-at-key-seq (get-keymaps-at-key-seq keymaps key-seq))
         (data (mapcan (lambda (map)
                         (mapcar (lambda (b)
                                   (format nil "^5*~5a^n ~a"
                                           (print-key (binding-key b))
                                           (binding-command b)))
                                 (kmap-bindings map)))
                       keymaps-at-key-seq))
         (cols (ceiling (1+ (length data))
                        (truncate (- (head-height (current-head)) (* 2 (screen-msg-border-width screen)))
                                  (font-height (screen-font screen))))))
    (message-no-timeout "Prefix: ~a~%~{~a~^~%~}"
                        (print-key-seq key-seq)
                        (or (columnize data cols) '("(EMPTY MAP)")))))

(which-key-for-keymaps `(,(kbd "C-t")) (stumpwm::dereference-kmaps (stumpwm::top-maps)))

(apply 'display-bindings-for-keymaps (reverse `(,(kbd "C-h") ,(kbd "C-t")))
       (dereference-kmaps (concatenate 'list (top-maps) '(*menu-map*))))

(mapcan (lambda (map)
          (mapcar (lambda (b) (format nil "^5*~5a^n ~a" (print-key (binding-key b)) (binding-command b))) (kmap-bindings map)))
        `(,*root-map*))
(length (kmap-bindings *root-map*))
(top-maps)
