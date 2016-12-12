(defun get-keymaps-at-key (keymaps key)
  (reduce
   (lambda (result map)
     (let* ((binding (find key (kmap-bindings map)
                          :key 'binding-key :test 'equalp))
           (command (when binding (binding-command binding))))
       (if command
           (setf result (cons command result))
           result)))
   keymaps
   :initial-value '()))

(defun get-keymaps-at-key-seq (keymaps key-seq)
  (if (= 1 (length key-seq))
      (get-keymaps-at-key (dereference-kmaps keymaps) (first key-seq))
      (get-keymaps-at-key-seq (get-keymaps-at-key (dereference-kmaps keymaps) (first key-seq)) (rest key-seq))))

;; (get-keymaps-at-key-seq (top-maps) `(,(kbd "C-t") ,(kbd "g")))

;; (apply 'display-bindings-for-keymaps (reverse `(,(kbd "C-t") ,(kbd "g")))
;;        (dereference-kmaps (get-keymaps-at-key-seq (dereference-kmaps (top-maps)) `(,(kbd "C-t") ,(kbd "g")))))
