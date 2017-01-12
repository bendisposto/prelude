(message "Loading personal settings")


;; ============= Packages 
(prelude-require-packages 
  '(smart-mode-line))




;; ============= Clojure Stuff

;; prevent from infinite printing
(setq cider-repl-print-length 100) 
(add-to-list 'auto-mode-alist '("\\.boot\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.cljx\\'" . clojure-mode))
(add-hook 'cider-repl-mode-hook 'smartparens-mode)
(add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)

(defun cider-send-and-evaluate-sexp ()
   "Sends the s-expression located before the point or the active
region to the REPL and evaluates it. Then the Clojure buffer is
activated as if nothing happened."
   (interactive)
   (if (not (region-active-p))
       (cider-insert-last-sexp-in-repl)
     (cider-insert-in-repl
      (buffer-substring (region-beginning) (region-end)) nil))
   (cider-switch-to-repl-buffer)
   (cider-repl-closing-return)
   (cider-switch-to-last-clojure-buffer)
   (message ""))

 (add-hook 'clojure-mode-hook 'prettify-symbols-mode)


;; ============= Emacs Settings 

(setq prelude-whitespace nil)


(setq default-frame-alist
      '((top . 20) (left . 40)
        (width . 150) (height . 75)))

(setq initial-frame-alist '((top . 10) (left . 30)))

(set-face-attribute 'default nil :height 165)

;; Shut up emacs!
;;(setq visible-bell 1)
(setq ring-bell-function 'ignore)
(setq prelude-whitespace nil)

;; Smooth scrolling
(setq scroll-step            1
      scroll-conservatively  10000)

;; Status Line
(sml/setup)
(nyan-mode)

(defun esk-pretty-fn ()
   (font-lock-add-keywords nil `(("(\\(\\<fn\\>\\)"
                                   (0 (progn (compose-region (match-beginning 1)
                                                             (match-end 1)
                                                             "\u03BB"
                                                             'decompose-region)))))))




;; Line Numbers

(global-linum-mode t)

(defun new-shell ()
  "Create a new shell buffer"
  (interactive)
  (let ((currentbuf (get-buffer-window (current-buffer)))
        (newbuf     (generate-new-buffer-name "*shell*")))
   (generate-new-buffer newbuf)
   (set-window-dedicated-p currentbuf nil)
   (set-window-buffer currentbuf newbuf)
   (shell newbuf)))

;; ============= Key Bindings

(defun iwb ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))


(load-library "iso-insert")

(define-key global-map (kbd "M-a") 'insert-a-umlaut) 
(define-key global-map (kbd "M-o") 'insert-o-umlaut)
(define-key global-map (kbd "M-u") 'insert-u-umlaut)
(define-key global-map (kbd "M-A") 'insert-A-umlaut)
(define-key global-map (kbd "M-O") 'insert-O-umlaut)
(define-key global-map (kbd "M-U") 'insert-U-umlaut)

(define-key global-map (kbd "M-z") 'helm-M-x) ;; Because I trigger it accidently all the time
;(define-key global-map (kbd "s-3") 'smex) ;; eclipse style cmd-3 (MAC OS)
;(define-key global-map (kbd "s-1") 'dirtree) ;;
(define-key global-map (kbd "s-F") 'iwb)
(define-key global-map (kbd "C-x f") 'helm-find-files) ;; Because I trigger it accidently all the time

(define-key global-map (kbd "s-1") 'new-shell)
(define-key global-map (kbd "C-c C-c") 'cider-send-and-evaluate-sexp)

(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(global-set-key (kbd "C-c b") 'switch-to-previous-buffer)

(sp-pair "`" nil :actions :rem)




(message "Personal settings loaded.")
