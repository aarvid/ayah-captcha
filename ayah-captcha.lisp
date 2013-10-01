;;;; ayah-captcha.lisp

(in-package #:ayah-captcha)


(defvar *web-service-host* "ws.areyouahuman.com"
  "The default web service host for the areyouahuman play-thru captcha.")

(defvar *publisher-key* "5CA1AB1E00000000000000000000000000000000000"
  "Identifies you and your application to the areyouahuman web service.")

(defvar *scoring-key* "B01DFACE00000000000000000000000000000000000"
  "Used to retrieve pass or fail results from areyouahuman web service.")


(defun publisher-script-url (&key (publisher-key *publisher-key*)
                                  (host *web-service-host*))
  "Returns URL for script to be loaded within the form."
  (format nil "https://~a/ws/script/~a"
          host (drakma:url-encode publisher-key :utf-8)))

(defun publisher-html (&key (publisher-key *publisher-key*)
                            (host *web-service-host*))
  "Returns HTML snippet to be inserted within the html form to display
play-thru content. Will pass the parameter session_secret on submit to be
passed onto the function human-p"
  (format nil
          "<div id=\"AYAH\"></div><script type=\"text/javascript\" src=~s></script>"
          (publisher-script-url :host host :publisher-key publisher-key)))

(defun scoring-url (&key (host *web-service-host*))
  "Returns the URL for an http-request post to obtain the scoring result."
  (format nil "https://~a/ws/scoreGame" host))

(defun human-p (session-secret &key (scoring-key *scoring-key*)
                                    (host *web-service-host*))
  "session-secret should be the value of the parameter session_secret
submitted by the form containing publisher-html. Returns boolean value
indicating whether the client passed the captcha test. "
  (multiple-value-bind (json status-code headers)
      (drakma:http-request (scoring-url :host host)
                           :method :post
                           :parameters `(("session_secret" . ,session-secret)
                                         ("scoring_key" . ,scoring-key))
                           :external-format-out :utf-8)
    #+nil (hunchentoot:log-message* :info "~s~%~s~%~s~%" json status-code headers)
    (when (and (= 200 status-code)
               (string-equal "text/json" (cdr (assoc :content-type headers))))
      (= 1 (cdr (assoc :status--code (json:decode-json-from-string json)))))))

(defun record-conversation-url (session-secret &key (host *web-service-host*))
  (format nil "https://~a/ws/recordConversation/~a"
          host (drakma:url-encode session-secret :utf-8)))

(defun record-conversation-html (session-secret &key (host *web-service-host*))
  "Returns the HTML snippet needed to be embedded in the confirmation page
after a form submission. Once the code loads on the page it will record
a conversion with our system.
    session-secret
       Pass in the value of the hidden input field with id='session_secret'
"
  (format nil
          "<iframe style=\"border: none;\" height=\"0\" width=\"0\" src=~s></iframe>"
          (record-conversation-url session-secret :host host)))

