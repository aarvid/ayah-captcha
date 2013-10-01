;;;; ayah-captcha-demo.lisp

(in-package #:ayah-captcha-demo)

;;; "ayah-captcha-demo" goes here. Hacks and glory await!


(eval-when (:compile-toplevel :load-toplevel :execute)
  (setf ayah:*publisher-key* "your key here")
  (setf ayah:*scoring-key* "your key here"))


(defvar *hunchentoot-server* nil)

(defun start-demo-server (&optional (port 8080))
  "Start the server"
  (setf *hunchentoot-server*
        (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor
                                          :name 'ayah-demo-server
                                          :port port))))

(defun stop-demo-server ()
  "Stop the server"
  (when *hunchentoot-server*
    (hunchentoot:stop *hunchentoot-server*)))


(define-easy-handler (demo-home :uri "/"
                                :acceptor-names '(ayah-demo-server))
    ()
  (with-html-output-to-string (s nil :prologue t)
    (:html
     (:head
      (:title "Ayah Demo Home"))
     (:body
      (:div :id "page-header"
            (:a :id "home" :href "/" "Home"))
      (:div :id "content"
            (:h2 "A You A Human Lisp Interface Demo")
            (:form :name "demo-form"
                   :action "/submit-name" :method "post"
                   (:table
                    (:tr (:td "Name:")
                         (:td ((:input :type "text" :name "name" :value ""))))
                    (:tr (:td "Email:")
                         (:td ((:input :type "text" :name "email" :value ""))))
                    (:tr (:td)
                         (:td (:input :type "submit" :value "Submit"))))
                   (str (ayah:publisher-html))))))))


(define-easy-handler (submit-name
                      :uri "/submit-name"
                      :acceptor-names '(ayah-demo-server))
    (name email session_secret)
  (let ((passed-captcha (ayah:human-p session_secret)))
    (with-html-output-to-string (s nil :prologue t)
      (:html
       (:head
        (:title "Ayah Demo Submitted"))
     (:body
      (:div :id "page-header"
            (:a :id "home" :href "/" "Home"))
      (:div :id "content"
            (:h2 "A You A Human Lisp Interface Demo")
            (:p "Data Submitted: ")
            (:table
             (:tr (:td "Name:") (:td (str name)))
             (:tr (:td "Email:") (:td (str email)))
             (:tr (:td "Captcha:")
                  (:td (str (if passed-captcha "Passed" "Failed")))))))))))
