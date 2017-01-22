(ql:quickload :cffi)

(defvar *SIGINT* 2)

(defmacro set-signal-handler (signo &body body)
  (let ((handler (gensym "HANDLER")))
    `(progn
       (cffi:defcallback ,handler :void ((signo :int))
         (declare (ignore signo))
         ,@body)
       (cffi:foreign-funcall "signal" :int ,signo :pointer (cffi:callback ,handler)))))


(set-signal-handler *SIGINT*
  (with-open-file (str "~/stump.log"
                       :direction :output
                       :if-exists :supersede
                       :if-does-not-exist :create)
    (format str "~A" (prin1-to-string stumpwm::*last-unhandled-error*))))
