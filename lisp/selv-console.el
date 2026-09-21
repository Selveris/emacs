(defvar selv-console-window-height 0.30)

(defun selv-project-root ()
  (require 'project)
  (project-root (project-current t)))

(defun selv-project-name ()
  (file-name-nondirectory
   (directory-file-name (selv-project-root))))

(defun selv-console-buffer-name ()
  (format "*Console[%s]*" (selv-project-name)))

(defun selv-console-create-buffer ()
  (require 'eat)
  (let* ((project-root (selv-project-root))
         (eat-buffer-name (selv-console-buffer-name))
         (default-directory project-root)
	 (explicit-shell-file-name "/bin/bash")) ;got issues with fish

    (eat--1 nil nil #'ignore)))

(defun selv-console-buffer ()
  (or (get-buffer (selv-console-buffer-name))
      (selv-console-create-buffer)))

(defun selv-console-window ()
  (get-buffer-window (selv-console-buffer-name) t))

(defun selv-console-open ()
  (interactive)

  (let ((buf (selv-console-buffer)))
    (display-buffer-in-side-window
     buf
     `((side . bottom)
       (slot . 1)
       (window-height . ,selv-console-window-height)))))

(defun selv-console-close ()
  (interactive)

  (when-let ((window (selv-console-window)))
    (delete-window window)))

(defun selv-console-toggle ()
  (interactive)

  (if (selv-console-window)
      (selv-console-close)
    (selv-console-open)))

(defun selv-console-send-command (command)
  (interactive "sCommand: ")

  (let ((buf (selv-console-buffer)))
    (selv-console-open)

    (with-current-buffer buf
      ;; Optional: more Emacs-like navigation.
      ;; (when (fboundp 'eat-line-mode)
      ;;   (eat-line-mode))

      (eat-term-send-string
       eat-terminal
       (concat command "\n")))))

(provide 'selv-console)
