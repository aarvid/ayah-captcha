;;;; ayah-captcha-demo.asd

(asdf:defsystem "ayah-captcha-demo"
  :serial t
  :description "Describe ayah-captcha-demo here"
  :author "andy peterson <andy.arvid@gmail.com"
  :license "MIT"
  :depends-on ("ayah-captcha" "hunchentoot" "cl-who")
  :components ((:file "package")
               (:file "ayah-captcha-demo")))

