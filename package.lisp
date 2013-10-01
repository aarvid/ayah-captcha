;;;; package.lisp

(in-package :cl-user)

(defpackage #:ayah-captcha
  (:nicknames #:ayah)
  (:use #:cl)
  (:export
   #:*web-service-host*
   #:*publisher-key*
   #:*scoring-key*
   #:publisher-html
   #:human-p
   #:record-conversation-html))

