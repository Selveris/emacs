;;; Basic QOL

;; Make native compilation silent.
(when (native-comp-available-p)
  (setq native-comp-async-report-warnings-errors 'silent))

;; better handling of long lines
(global-so-long-mode 1)

;;; Packages

(setq package-archives
      '(("gnu-elpa" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")))
;; Highest number gets priority (what is not mentioned has priority 0)
(setq package-archive-priorities
      '(("gnu-elpa" . 3)
        ("melpa" . 2)
        ("nongnu" . 1)))

;; These are for Emacs 31.
;; (setq package-review-policy
;;       (delq nil
;;             (append
;;              (mapcar
;;               (lambda (package)
;;                 (list 'not 'package package))
;;               prot-emacs-my-packages)
;;              (mapcar
;;               (lambda (archive)
;;                 (let ((archive-name (car archive)))
;;                   (unless (string= archive-name "gnu-elpa-devel")
;;                     (cons 'archive archive-name))))
;;               package-archives))))

;; (setq package-review-diff-command
;;       (cons diff-command
;;             '("-u"
;;               "-x" "'*.elc'"
;;               "-x" "'*-autoloads.el'"
;;               "-x" "'*-pkg.el'"
;;               "-x" "'*.info'"
;;               "-x" "'*.texi'"
;;               "-x" "'*.txt'"
;;               "-x" "'*.md'"
;;               "-x" "'*.org'")))

;;; Load modules and macros

;; load custom-macros file first as modules require some of them
(load (expand-file-name "custom-macros.el" user-emacs-directory) nil t)

;; add custom-modules directory to load path
(mapc
 (lambda (string)
   (add-to-list 'load-path (locate-user-emacs-file string)))
 '("modules" "lisp"))

(require 'my-theme)
(require 'my-essentials)
(require 'my-minibuffer)
(require 'my-completion)
(require 'my-prog-essentials)
(require 'my-langs)
(require 'my-ai)

;;; Backup files
(defconst emacs-tmp-dir (expand-file-name (format "emacs%d" (user-uid)) temporary-file-directory))
(setq
   backup-by-copying t ; Avoid symlinks
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t
   auto-save-list-file-prefix emacs-tmp-dir
   auto-save-file-name-transforms `((".*" ,emacs-tmp-dir t))  ; Change autosave dir to tmp
   backup-directory-alist `((".*" . ,emacs-tmp-dir))
   lock-file-name-transforms `(("\\`/.*/\\([^/]+\\)\\'" "/tmp/\\1" t)))

;;; Custom-File

;; Offload the custom-file to a separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(load custom-file nil t) ; Do LAST to prevent overwrite
