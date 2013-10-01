;;;; ayah-captcha.asd

(asdf:defsystem #:ayah-captcha
  :serial t
  :version "0.1"
  :description "A simple interface to the API of the play-thru captcha of areYouAHuman.com"
  :author "Andy Peterson <andy.arvid@gmail.com>"
  :license "MIT"
  :depends-on (#:drakma #:cl-json)
  :components ((:file "package")
               (:file "ayah-captcha")))

