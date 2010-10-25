;; -*- coding: utf-8 -*-
;;; customization
(setq custom-file (expand-file-name "01-my-custom.el" my-config-dir))

;; (setq debug-on-error t)

;;{{{ Generic Settings
;; syntax highlight
(cond ((fboundp 'global-font-lock-mode)
       ;; Turn on font-lock in all modes that support it
       (global-font-lock-mode t)
       ;; Maximum colors
       (setq font-lock-maximum-decoration t)
       (setq scalable-fonts-allowed t)))
(setq font-lock-maximum-size
      (quote ((t . 1280000) (c-mode . 256000) (c++-mode . 256000))))
(setq default-directory "~/")
;; echo key strokes quickly
(setq echo-keystrokes 0.1)
;; auto fill : M-q
(setq default-justification 'full)
(setq adaptive-fill-mode nil)
(setq default-fill-column 72)

(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq column-number-mode t)
(setq ring-bell-function 'ignore)
;; (setq visible-bell t)

(setq truncate-partial-width-windows nil)

;; highlight trailing whitespace
(setq show-trailing-whitespace t)

;; no trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Wrap too long lines
(toggle-truncate-lines nil)
(setq hscroll-margin 1)
(setq hscroll-step 1)

;; delete whole line
(setq-default kill-whole-line t)
(setq kill-ring-max 50)
;; indent without tab '\t' but white space
(setq-default indent-tabs-mode nil)
(setq default-tab-width 4)
(setq tab-stop-list nil)
(setq display-time-mail-file "~/.emacs.d/mail")

;; chinese charactor at the end of sentences
(setq sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*"
      sentence-end-double-space nil)
;; scroll-margin, which conflict with pager-mode, thus set to zero
(setq scroll-margin 0
      scroll-conservatively 10000)
;; show matching parentheses
(show-paren-mode t)
(setq show-paren-style 'parentheses)

(mouse-avoidance-mode 'animate)
(auto-image-file-mode t)
;; Highlight selected regions in Gnu Emacs
(transient-mark-mode t)
;; Make typing overwrite text selection
(setq delete-selection-mode t)
;; Store all backup files into a separated directories
(setq make-backup-files t
      version-control t
      kept-new-versions 3
      delete-old-versions t
      kept-old-versions 2
      dired-kept-versions 1
      backup-by-copying t)
;;; DO NOT depends on the backup, it is not really useful
(add-to-list 'backup-directory-alist
             (cons "." (expand-file-name "backup" my-temp-dir)))
(setq auto-save-list-file-prefix (expand-file-name "emacs-autosave-" my-temp-dir))

(setq completion-ignore-case t
      read-file-name-completion-ignore-case t)
;; use clipboard
(setq x-select-enable-clipboard t)

(deh-section "ediff"
  (setq diff-switches "-ubB"
        ediff-split-window-function 'split-window-horizontally
        ediff-window-setup-function 'ediff-setup-windows-plain))

;; diary, todo, calendar
(deh-section "calendar"
  (setq diary-file "~/.emacs.d/diary")
  (setq todo-file-do "~/.emacs.d/todo-do")
  (setq todo-file-done "~/.emacs.d/todone-done")
  (setq todo-file-top "~/.emacs.d/todone-top")
  (add-hook 'initial-calendar-window-hook (lambda () (toggle-truncate-lines 1)))
  ;; calendar
  ;; for calendar-sunrise-sunset
  (setq calendar-longitude 114
        calendar-latitude 22.3
        calendar-location-name "Beijing"))

;; set my file register
(deh-section "register"
  (set-register ?. '(file . "~/.emacs.d/config/"))
  (set-register ?t '(file . "~/temp/"))
  (set-register ?p '(file . "~/projects/"))
  (set-register ?d '(file . "~/Downloads/")))

;; prevent no response if click the memu in File
(fset 'print-buffer 'ignore)
(setq lpr-command "")
(setq printer-name "")

;; abbrevation setting
(setq abbrev-file-name (expand-file-name "emacs.abbrev_defs" my-temp-dir))
(if (file-exists-p abbrev-file-name)
    (read-abbrev-file abbrev-file-name))
(setq save-abbrevs t)
(put 'define-abbrev-table 'lisp-indent-function 1)
;;}}}

;;{{{ Customized keywords
(dolist (mode '(c-mode c++-mode java-mode lisp-mode emacs-lisp-mode
                       php-mode lisp-interaction-mode sh-mode sgml-mode))
  (font-lock-add-keywords
   mode
   '(("\\<\\(FIXME\\|TODO\\|BUG\\|HACK\\|WORKAROUND\\):" 1 font-lock-warning-face prepend)
     ("\\<\\(DONE\\|NOTE\\):" 1 font-lock-doc-face t)
     ;; highlight too long lines
     ;; ("^[^\n]\\{120\\}\\(.*\\)$" 1 font-lock-warning-face t)
     ;; highlight parentheses
     ("(\\|)\\|\\[\\|]\\|<\\|>\\|{\\|}" . font-lock-builtin-face)
     ;; hightlight numbers
     ("\\<[0-9]*\\.?[0-9]+\\>" . font-lock-constant-face))))
;;}}}

;; Turn on the features disabled default
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'scroll-left 'disabled nil)
(put 'erase-buffer 'disabled nil)
(put 'LaTeX-hide-environment 'disabled nil)

;; Prevent annoying active process message when kill emacs
(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  "Prevent annoying \"Active processes exist\" query when you quit Emacs."
  (flet ((process-list ())) ad-do-it))

;; Auto indent pasted content
(dolist (command '(yank yank-pop))
  (eval
   `(defadvice ,command (after indent-region activate)
      (and (not current-prefix-arg)
           (member major-mode
                   '(emacs-lisp-mode python-mode c-mode c++-mode latex-mode
                     js-mode php-mode plain-tex-mode))
           (let ((mark-even-if-inactive transient-mark-mode))
             (indent-region (region-beginning) (region-end) nil))))))

;; Workaround. Indeed, I wanna disable tramp!
(setq tramp-default-method "ftp")

(custom-set-variables
 '(confirm-kill-emacs (quote y-or-n-p))
 '(cperl-invalid-face nil)
 '(desktop-globals-to-save (quote (sql-mysql-schema bibus-formats desktop-missing-file-warning search-ring regexp-search-ring register-alist windata-named-winconf)))
 '(folding-folding-on-startup nil)
 '(outline-minor-mode-prefix "")
 '(tooltip-use-echo-area nil)
 '(view-read-only t)
 '(woman-cache-filename "~/.wmncach.el")
 '(woman-manpath (quote ("/usr/man" "/usr/share/man" "/usr/X11R6/man" "/usr/local/man" "/home/ywb/proj/perl/man" "/usr/share/man/zh_TW" "/usr/share/man/zh_CN"))))
