;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Macro to shoot out error in case a library is not available
(defmacro with-library-for-all (symbol &rest body)
  `(condition-case nil
       (progn
         (require ',symbol)
         ,@body)

     (error (message (format "ERROR: I guess we don't have %s available. Check emacs_all_config.el" ',symbol))
            nil)))
(put 'with-library-for-all 'lisp-indent-function 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Undo tree mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-library-for-all undo-tree
  (global-undo-tree-mode)
  )

;; NOTEs:
;;
;; C-_ M-_ : do/undo
;; C-x u   : open undo tree, navigate with arrows

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set ibuffer autorefresh (emacs >= 22)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'ibuffer-mode-hook (lambda () (ibuffer-auto-mode 1)))
(global-set-key (kbd "C-x i") 'ibuffer) ;; Use Ibuffer for Buffer List (kbd "C-x C-b")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Show matching parenthesis (build-in emacs) - requested from Mustafa
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(show-paren-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Show filename - requested from Mustafa
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when mswindows-p
  (setq frame-title-format "%b")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Magit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(with-library-for-all magit
  (when mswindows-p
    (add-to-list 'exec-path "c:/Program Files (x86)/Git/bin")
    )
;;  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Scroll set up modifying scroll-conservatively variable
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Scroll up to this many lines, to bring point back on screen
;;
;; If the value is greater than 100, redisplay will never recenter point,
;;    but will always scroll just enough text to bring point into view, even
;;    if you move far away.
;;
;;    A value of zero means always recenter point if it moves off screen.
(setq scroll-conservatively most-positive-fixnum)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setup scratch buffer message
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Setup scratch message with "useful" informations,
;; such as a reminder of the most important shortcuts
;;
;; (setq initial-scratch-message "\
;; # Open buffer list: C-x C-b
;; # Open buffer by name: C-x b
;; # Switch frame: C-x o
;; # Kill buffer: C-x k
;; # Indent lines: C-x tab arrow
;; # Open file C-x C-f
;; # M-x replace-string <ENTER> <searchstr> <ENTER> <replstr>
;; # C-a beginning of line
;; # C-e end of line
;; # C-v page forward
;; # M-v page backward
;; # S-Arrow go to next window
;; # 
;; # ---ETAGS---
;; # Go to source code root
;; # Create file with all tags: find . -regex \".*\(h$\|cpp$\)\" > files.txt
;; # Create TAGS: path/to/etags.exe - < files.txt
;; # Make TAGS acrtive in file: M-x visit-tags-table
;; # Search functions: M-x find-tag
;; ")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Add golden ratio mode down here?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



