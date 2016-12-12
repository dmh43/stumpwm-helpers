;; Example usage:
;; (defun key-press-hook (key key-seq cmd)
;;   (declare (ignore key))
;;   (unless (eq *top-map* *resize-map*)
;;     (let ((*message-window-gravity* :bottom-right)
;;           (maps (get-keymaps-at-key-seq (dereference-kmaps (top-maps))
;;                                         (reverse key-seq))))
;;       (if (remove-if-not 'kmap-p maps)
;;           (apply 'display-bindings-for-keymaps (reverse (cdr key-seq)) maps)
;;           (message "Key sequence: ~a" (print-key-seq (reverse key-seq)))))))

;; (defmacro replace-hook (hook fn)
;;   `(remove-hook ,hook ,fn)
;;   `(add-hook ,hook ,fn))

;; (replace-hook *key-press-hook* 'key-press-hook)

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
