;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Macro to shoot out error in case a library is not available
(defmacro with-library-for-vhdl (symbol &rest body)
  `(condition-case nil
       (progn
         (require ',symbol)
         ,@body)

     (error (message (format "ERROR: I guess we don't have %s available. Check emacs_vhdl_code_config.el" ',symbol))
            nil)))
(put 'with-library-for-vhdl 'lisp-indent-function 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ctags/etags management for VHDL (requires exuberant ctags in path)
;; ctags.el --- Exuberant Ctags utilities for Emacs

;; eventually add etags-update.el: a global minor mode that updates TAGS when saving a file.

;; -- ;; (add-hook 'vhdl-mode-hook
;; -- ;; 	  ;; code to be executed only in vhdl-mode
;; -- ;; 	  (
	   
	   ;; The following code is taken from: 
	   ;; URL: https://bitbucket.org/semente/ctags.el
	   (defvar ctags-command "ctags -e -R --languages=vhdl")

	   (defun ctags ()
	     (call-process-shell-command ctags-command nil "*Ctags*"))


	   (defun ctags-find-tags-file ()
	     "Recursively searches each parent directory for a file named
              TAGS and returns the path to that file or nil if a tags file is
              not found or if the buffer is not visiting a file."
	     (progn
	       (defun find-tags-file-r (path)
		 "Find the tags file from current to the parent directories."
		 (let* ((parent-directory (file-name-directory (directory-file-name path)))
			(tags-file-name (concat (file-name-as-directory path) "TAGS")))
		   (cond
		    ((file-exists-p tags-file-name) (throw 'found tags-file-name))
		    ((string= "/TAGS" tags-file-name) nil)
		    (t (find-tags-file-r parent-directory)))))

	       (if (buffer-file-name)
		   (catch 'found
		     (find-tags-file-r (file-name-directory buffer-file-name)))
		 nil)))

	   (defun ctags-set-tags-file ()
	     "Uses `ctags-find-tags-file' to find a TAGS file. If found,
              set 'tags-file-name' with its path or set as nil."
	     (setq-default tags-file-name (ctags-find-tags-file)))

	   (defun ctags-create-tags-table ()
	     (interactive)
	     (let* ((current-directory default-directory)
		    (top-directory (read-directory-name
				    "Top of source tree: " default-directory))
		    (file-name (concat (file-name-as-directory top-directory) "TAGS")))
	       (cd top-directory)
	       (if (not (= 0 (ctags)))
		   (message "Error creating %s!" file-name)
		 (setq-default tags-file-name file-name)
		 (message "Table %s created and configured." tags-file-name))
	       (cd current-directory)))

	   (defun ctags-update-tags-table ()
	     (interactive)
	     (let ((current-directory default-directory))
	       (if (not tags-file-name)
		   (message "Tags table not configured.")
		 (cd (file-name-directory tags-file-name))
		 (if (not (= 0 (ctags)))
		     (message "Error updating %s!" tags-file-name)
		   (message "Table %s updated." tags-file-name))
		 (cd current-directory))))

	   (defun ctags-create-or-update-tags-table ()
	     "Create or update a tags table with `ctags-command'."
	     (interactive)
	     (if (not (ctags-set-tags-file))
		 (ctags-create-tags-table)
	       (ctags-update-tags-table)))


	   (defun ctags-search ()
	     "A wrapper for `tags-search' that provide a default input."
	     (interactive)
	     (let* ((symbol-at-point (symbol-at-point))
		    (default (symbol-name symbol-at-point))
		    (input (read-from-minibuffer
			    (if (symbol-at-point)
				(concat "Tags search (default " default "): ")
			      "Tags search (regexp): "))))
	       (if (and (symbol-at-point) (string= input ""))
		   (tags-search default)
		 (if (string= input "")
		     (message "You must provide a regexp.")
		   (tags-search input)))))
;; -- ;;    )
;; -- ;; 	  
;; -- ;;  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; speedbar in window

(with-library-for-vhdl sr-speedbar
  (sr-speedbar-open)
  (windmove-default-keybindings)
  (golden-ratio-mode)
  )

;; NOTEs:
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

