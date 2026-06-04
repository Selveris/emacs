;;; Macros

;;; install package `prot-emacs-install'

;; Sample
;; (prot-emacs-install modus-themes)
;; (prot-emacs-install modus-themes "~/Git/Projects/modus-themes")
;; (prot-emacs-install modus-themes :url "https://github.com/protesilaos/modus-themes.git" :branch "main")

(defmacro prot-emacs-install (package &rest vc-args)
  "Prepare to install PACKAGE.
PACKAGE is an unquoted symbol, referring to the name of the package.  If
VC-ARGS are nil, then install PACKAGE using `package-install'.

If VC-ARGS is non-nil, then check if their `car' is a directory.  If it
is, apply `package-vc-install-from-checkout' on VC-ARGS, else apply
`package-vc-install'.

At all times, do nothing if PACKAGE is already installled."
  (declare (indent 0))
  (unless (symbolp package)
    (error "The package `%s' is not a symbol" package))
  (cond
   ((and package vc-args)
    (let ((fn (if-let* ((first (car vc-args))
                        (_ (and (stringp first) (file-directory-p first))))
                  'package-vc-install-from-checkout
                'package-vc-install)))
      `(unless (package-installed-p ',package)
         (condition-case-unless-debug err
             (apply #',fn ',vc-args)
           (error (message "Failed `%s' with `%S': `%S'" ',fn ',vc-args (cdr err)))))))
   (package
    `(progn
       (unless (package-installed-p ',package)
         (unless package-archive-contents
           (package-refresh-contents))
         (condition-case-unless-debug nil
             (package-install ',package)
           (error (message "Cannot install `%s'; try `M-x package-refresh-contents' first" ',package))))))))

;;;; add or remove hooks `prot-emacs-hook'

;; Sample
;; (prot-emacs-hook
;;   (text-mode-hook prog-mode-hook)
;;   (test-fn-1 test-fn-2)
;;   :remove-them
;;   denote)
;; => (with-eval-after-load 'denote
;; =>   (remove-hook 'text-mode-hook #'test-fn-1)
;; =>   (remove-hook 'text-mode-hook #'test-fn-2)
;; =>   (remove-hook 'prog-mode-hook #'test-fn-1)
;; =>   (remove-hook 'prog-mode-hook #'test-fn-2))

(defmacro prot-emacs-hook (hooks functions &optional remove after)
  "For each HOOKS `add-hook' the FUNCTIONS.
With optional REMOVE as non-nil, then `remove-hook' the FUNCTIONS from
HOOKS.

With optional AFTER as the unquoted symbol of a feature, do so after the
given feature is available."
  (declare (indent 0))
  (cond
   ((symbolp hooks)
    (setq hooks (list hooks)))
   ((not (proper-list-p hooks))
    (error "The hooks are not a list: `%S'" hooks)))
  (cond
   ((symbolp functions)
    (setq functions (list functions)))
   ((not (proper-list-p functions))
    (error "The functions are not a list: `%S'" functions)))
  (let* ((fn (if remove 'remove-hook 'add-hook))
         (body (mapcar
                (lambda (h)
                  (mapcar
                   (lambda (f) `(,fn ',h #',f))
                   functions))
                hooks))
         (hooks nil))
    (dolist (element body)
      (dolist (hook element)
        (push hook hooks)))
    (setq hooks (nreverse hooks))
    (cond
     (after
      `(with-eval-after-load ',after ,@hooks))
     ((length> hooks 1)
      `(progn ,@hooks))
     (t
      (car hooks)))))

;;;; set keybind `prot-emacs-keybind'

;; Sample
;; (prot-emacs-keybind global-map
;;   "C-z" nil
;;   "C-x b" #'switch-to-buffer
;;   "C-x C-c" nil
;; ;; Notice the -map as I am binding keymap here, not a command:
;;   "C-c b" beframe-prefix-map
;;   "C-x k" #'kill-buffer)


(defmacro prot-emacs-keybind (keymap &rest definitions)
  "Expand key binding DEFINITIONS for the given KEYMAP.
DEFINITIONS is a sequence of string and command pairs."
  (declare (indent 1))
  (unless (zerop (% (length definitions) 2))
    (error "Uneven number of key+command pairs"))
  (let ((keys (seq-filter #'stringp definitions))
        ;; We do accept nil as a definition: it unsets the given key.
        (commands (seq-remove #'stringp definitions)))
    `(when-let* (((keymapp ,keymap))
                 (map ,keymap))
       ,@(mapcar
          (lambda (pair)
            (let* ((key (car pair))
                   (command (cdr pair)))
              (unless (and (null key) (null command))
                `(define-key map (kbd ,key) ,command))))
          (cl-mapcar #'cons keys commands)))))

;;;; configure package `prot-emacs-configure'

(defmacro prot-emacs-configure (&rest body)
  "Evaluate BODY and catch any errors."
  (declare (indent 0))
  `(condition-case err
       (progn ,@body)
     ((error user-error quit)
      (message "Failed to configure package starting with `%S' because of `%S'" (car ',body) (cdr err)))))
