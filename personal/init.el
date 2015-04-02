(message "Loading personal settings")

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


;; ============= Emacs Settings 
(setq default-frame-alist
      '((top . 20) (left . 40)
        (width . 150) (height . 75)))

(setq initial-frame-alist '((top . 10) (left . 30)))

(set-face-attribute 'default nil :height 165)

;; Shut up emacs!
;;(setq visible-bell 1)
(setq ring-bell-function 'ignore)

;; Smooth scrolling
(setq scroll-step            1
      scroll-conservatively  10000)

;; Status Line
(nyan-mode)

(setq-default mode-line-format
  (list
    ;; the buffer name; the file name as a tool tip
    '(:eval (propertize "%b " 'face 'font-lock-keyword-face
        'help-echo (buffer-file-name)))

    ;; line and column
    "(" ;; '%02' to set to 2 chars at least; prevents flickering
      (propertize "%02l" 'face 'font-lock-type-face) ","
      (propertize "%02c" 'face 'font-lock-type-face) 
    ") "

    ;; relative position, size of file
    '(:eval (list (nyan-create))) 

    ;; the current major mode for the buffer.
    "["

    '(:eval (propertize "%m" 'face 'font-lock-string-face
              'help-echo buffer-file-coding-system))
    "] "


    "[" ;; insert vs overwrite mode, input-method in a tooltip
    '(:eval (propertize (if overwrite-mode "Ovr" "Ins")
              'face 'font-lock-preprocessor-face
              'help-echo (concat "Buffer is in "
                           (if overwrite-mode "overwrite" "insert") " mode")))

    ;; was this buffer modified since the last save?
    '(:eval (when (buffer-modified-p)
              (concat ","  (propertize "Mod"
                             'face 'font-lock-warning-face
                             'help-echo "Buffer has been modified"))))

    ;; is this buffer read-only?
    '(:eval (when buffer-read-only
              (concat ","  (propertize "RO"
                             'face 'font-lock-type-face
                             'help-echo "Buffer is read-only"))))  
    "] "

    ;; add the time, with the date and the emacs uptime in the tooltip
    '(:eval (propertize (format-time-string "%H:%M")
              'help-echo
              (concat (format-time-string "%c; ")
                      (emacs-uptime "Uptime:%hh"))))
    " --"
    ;; i don't want to see minor-modes; but if you want, uncomment this:
    ;; minor-mode-alist  ;; list of minor modes
    "%-" ;; fill with '-'
    ))

;; Line Numbers

(global-linum-mode t)

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
(define-key global-map (kbd "C-x f") 'ido-find-file) ;; Because I trigger it accidently all the time

(define-key global-map (kbd "s-P") 'cider-send-and-evaluate-sexp)

(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(global-set-key (kbd "C-c b") 'switch-to-previous-buffer)


(message "Personal settings loaded.")
