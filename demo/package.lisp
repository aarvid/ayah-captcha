;;;; package.lisp

(in-package :cl-user)

(defpackage #:ayah-captcha-demo
  (:use #:cl #:hunchentoot #:cl-who)
  (:export #:start-demo-server
           #:stop-demo-server))

