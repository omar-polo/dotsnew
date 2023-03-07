;; get rid of custom from my init file
(setq custom-file "~/.emacs.d/emacs-custom.el")
(load custom-file)

(setq-default abbrev-mode t)
(setq abbrev-file-name
      (expand-file-name "~/dotsnew/emacs/abbrev_defs"))

(defconst op/backup-dir
  (expand-file-name "backups" user-emacs-directory))
(unless (file-exists-p op/backup-dir)
  (make-directory op/backup-dir))
(setq backup-directory-alist `(("." . ,op/backup-dir)))

(setq use-dialog-box nil
      x-stretch-cursor t
      require-final-newline t
      visible-bell nil
      load-prefer-newer t
      tab-bar-show 1
      enable-recursive-minibuffers t
      imenu-auto-rescan 1
      use-short-answers t
      next-error-message-highlight t
      read-minibuffer-restore-windows nil
      isearch-allow-motion t
      calc-make-windows-dedicated t
      user-mail-address "op@omarpolo.com")

(setq completion-ignore-case t
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t)

;; I don't like how compile uses `make -k' by default, I want to stop
;; on errors / warnings.
(setq compile-command "make")

;; "diff refinement", i.e. highlighting the changes in a more granular
;; way, is quite awful to have it enabled by default.  sometimes is
;; useful, but for me it's more of a visual noise most of the times.
(setq diff-refine nil)

;; disable also the syntax highlighting in the diff buffers
(setq diff-font-lock-syntax nil)

(define-key global-map (kbd "C-x C-b") #'ibuffer)
(define-key global-map (kbd "M-g i") #'imenu)

(defun op/imenu ()
  "Just like `imenu', but always flattened!"
  (interactive ))

;; mg-like
(define-key minibuffer-mode-map (kbd "C-w") #'backward-kill-word)

;; niceties for the standard completion
(setq completion-auto-help 'always
      completion-auto-select 'second-tab
      completions-max-height 10
      completions-format 'horizontal
      completions-header-format ""
      completion-show-help nil)

(define-key minibuffer-local-map (kbd "C-p") #'minibuffer-previous-completion)
(define-key minibuffer-local-map (kbd "C-n") #'minibuffer-next-completion)

(define-key completion-in-region-mode-map (kbd "C-p")
            #'minibuffer-previous-completion)
(define-key completion-in-region-mode-map (kbd "C-n")
            #'minibuffer-next-completion)

(define-key completion-in-region-mode-map (kbd "M-RET")
            #'minibuffer-choose-completion)

(defun op/reverse-other-window ()
  "Like `other-window', but reverse."
  (interactive "")
  (other-window -1))
(define-key global-map (kbd "C-x O") #'op/reverse-other-window)

(define-key global-map (kbd "C-x v f") #'vc-pull)

(setq uniquify-buffer-name-style 'forward
      uniquify-strip-common-suffix t)

(setq-default scroll-up-aggressively 0.0
              scroll-down-aggressively 0.0
              scroll-preserve-screen-position t
              next-screen-context-lines 1)

(define-key global-map (kbd "M-Z") #'zap-up-to-char)

(require 'whitespace)
(setq whitespace-style '(face trailing)
      backward-delete-char-untabify-method  'hungry
      tab-always-indent 'complete
      tab-width 8
      sentence-end-double-space t)
(setq-default indent-tabs-mode t)

(defun op/enable-tabs ()
  "Enable `indent-tabs-mode' in the current buffer."
  (interactive)
  (setq-local indent-tabs-mode t))

(defun op/disable-tabs ()
  "Disable `indent-tabs-mode' in the current buffer."
  (interactive)
  (setq-local indent-tabs-mode nil))

(add-hook 'conf-mode-hook #'op/enable-tabs)
(add-hook 'text-mode-hook #'op/enable-tabs)
(add-hook 'prog-mode-hook #'op/enable-tabs)
(add-hook 'prog-mode-hook #'whitespace-mode)
(add-hook 'text-mode-hook #'whitespace-mode)

(dolist (hook '(emacs-lisp-mode-hook
		clojure-mode-hook
		clojurescript-mode-hook
		clojurec-mode-hook
		scss-mode-hook))
  (add-hook hook #'op/disable-tabs))

(with-eval-after-load 'log-edit
  (add-hook 'log-edit-mode #'auto-fill-mode))

;; free the c-z binding
(define-key global-map (kbd "C-z") nil)
(define-key global-map (kbd "C-z V") #'variable-pitch-mode)
(define-key global-map (kbd "C-z n") #'display-line-numbers-mode)

(define-key global-map (kbd "M-SPC") #'cycle-spacing)
(define-key global-map (kbd "M-u")   #'upcase-dwim)
(define-key global-map (kbd "M-l")   #'downcase-dwim)
(define-key global-map (kbd "M-c")   #'capitalize-dwim)

(let ((font
       ;; "-misc-fixed-medium-r-semicondensed--13-120-75-75-c-60-iso10646-1"
       "JuliaMono 8"
       ))
  (set-frame-font font nil t)
  (add-to-list 'default-frame-alist `(font . ,font)))

;; fix the emojis too
(set-fontset-font t 'emoji '("Noto Emoji" . "iso10646-1")
                  nil 'prepend)

;; some cool stuff
(save-place-mode +1)
(savehist-mode +1)
(setq history-delete-duplicates t
      history-length 1000
      savehist-save-minibuffer-history t)
(electric-pair-mode +1)

(define-key global-map (kbd "M-/") #'hippie-expand)
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-all-abbrevs
        try-expand-list
        try-expand-line
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))

(setq isearch-lazy-count t
      search-whitespace-regexp ".*?"
      isearch-allow-scroll 'unlimited)

(defun op/buffer-to-side-window (place)
        "Place the current buffer in the side window at PLACE."
        (interactive (list (intern
                            (completing-read "Which side: "
                                             '(top left right bottom)))))
        (let ((buf (current-buffer)))
          (display-buffer-in-side-window
           buf `((window-height . 0.15)
                 (side . ,place)
                 (slot . -1)
                 (window-parameters . ((no-delete-other-windows . t)))))
          (delete-window)))

(defun op/visit-new-migration-file (name)
  "Visit a new SQL migration file named after NAME."
  (interactive "Mname: ")
  (let* ((name (replace-regexp-in-string " " "-" (string-trim name)))
         (f (format "%s-%s.sql"
                    (format-time-string "%Y%m%d%H%M")
                    name)))
    (find-file f)))

(defun op/fill-or-unfill (fn &optional justify region)
  "Meant to be an adviced :around `fill-paragraph'.
      FN is the original `fill-column'.  If `last-command' is
      `fill-paragraph', unfill it, fill it otherwise.  Inspired from a
      post on endless parentheses.  Optional argument JUSTIFY and
      REGION are passed to `fill-paragraph'."
  (let ((fill-column
         (if (eq last-command 'fill-paragraph)
             (progn (setq this-command nil)
                    (point-max))
           fill-column)))
    (funcall fn justify region)))
(advice-add 'fill-paragraph :around #'op/fill-or-unfill)

(defmacro op/deftranspose (name scope key doc)
  "Macro to produce transposition functions.
NAME is the function's symbol.  SCOPE is the text object to
operate on.  Optional DOC is the function's docstring.

Transposition over an active region will swap the object at
mark (region beginning) with the one at point (region end).

It can optionally define a key for the defined function in the
`global-map' if KEY is passed.

Originally from protesilaos' dotemacs."
  (declare (indent defun))
  `(progn
     (defun ,name (arg)
       ,doc
       (interactive "p")
       (let ((x (intern (format "transpose-%s" ,scope))))
         (if (use-region-p)
             (funcall x 0)
           (funcall x arg))))
     ,(when key
        `(define-key global-map (kbd ,key) #',name))))

(op/deftranspose op/transpose-lines "lines" "C-x C-t"
  "Transpose lines or swap over active region.")

(op/deftranspose op/transpose-paragraphs "paragraphs" "C-S-t"
  "Transpose paragraph or swap over active region.")

(op/deftranspose op/transpose-sentences "sentences" "C-x M-t"
  "Transpose sentences or swap over active region.")

(op/deftranspose op/transpose-sexps "sexps" "C-M-t"
  "Transpose sexps or swap over active region.")

(op/deftranspose op/transpose-words "words" "M-t"
  "Transpose words or swap over active region.")

(defun op/narrow-or-widen-dwim (p)
  "Widen if the buffer is narrowed, narrow-dwim otherwise.
Dwim means: region, org-src-block, org-subtree or defun,
whichever applies first.  Narrowing to org-src-blocks actually
calls `org-edit-src-code'.

With prefix P, don't widen, just narrow even if buffer is already
narrowed.  With P being -, narrow to page instead of to defun.

Taken from endless parentheses."
  (interactive "P")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
        ((region-active-p)
         (narrow-to-region (region-beginning)
                           (region-end)))
        ((derived-mode-p 'org-mode)
         ;; `org-edit-src-code' isn't a real narrowing
         (cond ((ignore-errors (org-edit-src-code) t))
               ((ignore-errors (org-narrow-to-block) t))
               (t (org-narrow-to-subtree))))
        ((eql p '-) (narrow-to-page))
        (t (narrow-to-defun))))

(define-key global-map (kbd "C-c w") #'op/narrow-or-widen-dwim)

(with-eval-after-load 'dired
  (add-hook 'dired-mode-hook #'dired-hide-details-mode)
  (add-hook 'dired-mode-hook #'dired-omit-mode)

  (define-key dired-mode-map (kbd "C-c w") #'wdired-change-to-wdired-mode)

  (require 'dired-x)
  (setq dired-listing-switches "-lahF"
        dired-dwim-target t
        dired-deletion-confirmer #'y-or-n-p
        dired-do-revert-buffer t))

;; just like telescope!
(with-eval-after-load 'diff-mode
  (define-key diff-mode-map (kbd "M-SPC") #'scroll-down-command))

(with-eval-after-load 'elisp-mode
  (add-hook 'emacs-lisp-mode-hook #'checkdoc-minor-mode)
  (add-hook 'emacs-lisp-mode-hook #'prettify-symbols-mode)
  (let ((map emacs-lisp-mode-map))
    (define-key map (kbd "C-c C-k") #'eval-buffer)
    (define-key map (kbd "C-c k")   #'op/ert-all)
    (define-key map (kbd "C-c C-z") #'op/ielm-repl)))

(with-eval-after-load 'help
  (add-hook 'help-mode-hook #'visual-line-mode))

;; add melpa
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; packages that i want to be installed
(dolist (pkg '(vc-got eglot sly cider go-mode web-mode lua-mode
                      markdown-mode yaml-mode gemini-mode
                      form-feed shackle puni orderless))
  (unless (package-installed-p pkg)
    (message "Installing %s" pkg)
    (package-install pkg)))

(global-form-feed-mode +1)

(add-hook 'text-mode-hook #'puni-mode)
(add-hook 'prog-mode-hook #'puni-mode)
(define-key puni-mode-map (kbd "C-)") #'puni-slurp-forward)
(define-key puni-mode-map (kbd "C-(") #'puni-barf-forward)

;;(setq completion-styles '(basic substring initials flex partial-completion))
(setq completion-styles '(orderless basic)
      completion-category-overrides '((file (styles basic partial-completion))))

(setq completions-detailed t)

(with-eval-after-load 'cider
  (define-key cider-repl-mode-map (kbd "C-c M-o") #'cider-repl-clear-buffer))

(with-eval-after-load 'go-mode
  (add-hook 'go-mode-hook #'subword-mode))

(with-eval-after-load 'tcl
  (setq-default tcl-indent-level 8))

(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "<f1>") #'eglot-code-actions)
  (define-key eglot-mode-map (kbd "<f2>") #'eglot-format)
  (add-to-list 'eglot-ignored-server-capabilites
               :documentHighlightProvider)
  (add-to-list 'eglot-server-programs
               '(c-mode . ("clangd" "--header-insertion=never"))))

(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(with-eval-after-load 'web-mode
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-style-padding 0
        web-mode-enable-engine-detection t)
  (add-hook 'web-mode-hook #'op/disable-tabs)

  ;; fix .dir-locals.el
  (defun op/web-mode-fix-dir-locals ()
    (when (derived-mode-p major-mode 'web-mode)
      (web-mode-guess-engine-and-content-type)))
  (add-hook 'hack-local-variables-hook #'op/web-mode-fix-dir-locals)

  (setq web-mode-enable-auto-pairing nil))

(with-eval-after-load 'css-mode
  (add-hook 'css-mode-hook #'op/disable-tabs))

(with-eval-after-load 'flymake
  (define-key prog-mode-map (kbd "C-c ! n") #'flymake-goto-next-error)
  (define-key prog-mode-map (kbd "C-c ! p") #'flymake-goto-prev-error))

(with-eval-after-load 'cc-mode
  (setq c-basic-offset 8
        c-default-style "K&R")
  (dolist (hook '(c-mode-hook c++-mode-hook))
    (add-hook hook #'abbrev-mode)
    (add-hook hook #'subword-mode))
  (defun op/c-indent ()
    (interactive)
    (c-set-offset 'arglist-intro '+)
    (c-set-offset 'arglist-cont-nonempty '*)
    (c-set-offset 'label 1))
  (add-hook 'c-mode-hook #'op/c-indent)
  ;; TODO: improve it!
  (defun op/c-add-include (path &optional localp)
    "Include PATH at the start of the file.
       If LOCALP is non-nil, the include will be \"local\"."
    (interactive "Mheader to include: \nP")
    (save-excursion
      (let ((re (if localp
                    "^#[ \t]*include[ \t]*\""
                  "^#[ \t]*include[ \t]*<"))
            (ignore-re "^#include \"compat.h\"")
            start)
        (goto-char (point-min))
        (while (not (or (and (looking-at re)
                             (not (looking-at ignore-re)))
                        (eobp)))
          (forward-line))
        (when (eobp)
          (error "Don't know where to insert the header"))
        (open-line 1)
        (insert "#include " (if localp "\"\"" "<>"))
        (backward-char)
        (insert path)
        (move-beginning-of-line 1)
        (setq start (point))
        (forward-line)
        (while (and (looking-at re)
                    (not (eobp)))
          (forward-line))
        (sort-lines nil start (point)))))
  (define-key c-mode-map (kbd "C-c C-a") #'op/c-add-include))

(with-eval-after-load 'perl-mode
  (setq perl-indent-level 8))

(with-eval-after-load 'sh-script
  (setq sh-basic-offset 8
        sh-indent-after-loop-construct 8
        sh-indent-after-continuation nil))



(setq eshell-hist-ignoredups t)

(defun op/eshell-bufname (dir)
  (concat "*eshell " (expand-file-name dir) "*"))

(defun op/eshell (arg)
  "Run or jump to eshell in current project.
If called with prefix argument ARG always create a new eshell
buffer."
  (interactive "P")
  (let* ((proj (project-current))
         (dir (if (and proj (not arg))
                  (project-root proj)
                default-directory))
         (default-directory dir)
         (eshell-buffer-name (let ((name (op/eshell-bufname dir)))
                               (if arg
                                   (generate-new-buffer name)
                                 name))))
    (eshell)))
(define-key global-map (kbd "C-c e") #'op/eshell)

(with-eval-after-load 'eshell
  (setq eshell-save-history-on-exit t
        eshell-history-size 1024

        eshell-compl-dir-ignore
        "\\`\\(\\.\\.?\\|CVS\\|\\.svn\\|\\.git\\|\\.got\\)/\\'")

  (defun op/eshell-after-cd (&rest _)
    (rename-buffer (op/eshell-bufname default-directory) t))

  (advice-add #'eshell/cd :after #'op/eshell-after-cd))

(with-eval-after-load 'esh-mode
  (defun op/clear-eshell ()
    (interactive "")
    (let ((inhibit-read-only t))
      (erase-buffer)
      (eshell-send-input)))

  (define-key eshell-command-map (kbd "M-o") #'op/clear-eshell))


;; sndio.el
(unless (package-installed-p 'sndio)
  (package-install-file "~/w/sndio.el/sndio.el"))


;; saturn
(unless (package-installed-p 'saturn)
  (package-install-file "~/w/saturn/GUI/saturn.el"))


;; emacs-pq
(add-to-list 'load-path "~/build/emacs-libpq/")
(unless (package-installed-p 'pq)
  (package-install-file "~/build/emacs-libpq/pq.el"))


;; plass
(unless (package-installed-p 'plass)
  (ignore-errors
    (package-install-file "~/w/plass/extra/plass.el")))

(with-eval-after-load 'plass
  (setq plass-filter "!2fa"
        plass-totp-filter "2fa"))



(setq shackle-default-rule nil
      shackle-rules
      (let ((repls "\\*\\(cider-repl\\|sly-mrepl\\|ielm\\)")
            (godot "\\*godot - .*\\*")
            (vcs   "\\*\\(Flymake\\|Package-Lint\\|vc-\\(git\\|got\\) :\\).*")
            (elfeed "\\*elfeed-entry\\*")
            (vmd    "\\*vmd console .*"))
        `(("*Async Shell Command*" :ignore t)
          (,repls :regexp t
                  :align below
                  :size 0.3)
          (,godot :regexp t
                  :align t
                  :size 0.3)
          (occur-mode :select t
                      :align right
                      :size 0.3)
          (diff-mode :select t)
          (help-mode :select t
                     :align left
                     :size 0.3)
          (,vcs :regexp t
                :align above
                :size 0.15
                :select t)
          (,elfeed :regexp t
                   :align t
                   :select t
                   :size 0.75)
          (,vmd :regexp t
                :align below
                :select t
                :size 0.3))))
(shackle-mode +1)

;; (setq display-buffer-alist nil)
