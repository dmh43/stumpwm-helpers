(defun get-keymaps-at-key (keymaps key)
  (dereference-kmaps
   (reduce
    (lambda (result map)
      (let* ((binding (find key (kmap-bindings map)
                            :key 'binding-key :test 'equalp))
             (command (when binding (binding-command binding))))
        (if command
            (setf result (cons command result))
            result)))
    keymaps
    :initial-value '())))

(defun get-keymaps-at-key-seq (keymaps key-seq)
  (if (= 1 (length key-seq))
      (get-keymaps-at-key keymaps (first key-seq))
      (get-keymaps-at-key-seq (get-keymaps-at-key keymaps (first key-seq)) (rest key-seq))))
