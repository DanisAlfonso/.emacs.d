;; init-hydra.el --- Initialize hydra configurations.	-*- lexical-binding: t -*-

;; Copyright (C) 2019-2024 Vincent Zhang

;; Nice looking hydras.
;;

;;; Code:

(use-package hydra
  :hook (emacs-lisp-mode . hydra-add-imenu)
  :init
  (when (childframe-completion-workable-p)
    (setq hydra-hint-display-type 'posframe)

    (with-eval-after-load 'posframe
      (defun hydra-set-posframe-show-params ()
        "Set hydra-posframe style."
        (setq hydra-posframe-show-params
              `(:left-fringe 8
                :right-fringe 8
                :internal-border-width 2
                :internal-border-color ,(face-background 'posframe-border nil t)
                :background-color ,(face-background 'tooltip nil t)
                :foreground-color ,(face-foreground 'tooltip nil t)
                :lines-truncate t
                :poshandler posframe-poshandler-frame-center-near-bottom)))
      (hydra-set-posframe-show-params)
      (add-hook 'after-load-theme-hook #'hydra-set-posframe-show-params t))))

(use-package pretty-hydra
  :custom (pretty-hydra-default-title-body-format-spec " %s%s")
  :bind ("<f6>" . toggles-hydra/body)
  :hook (emacs-lisp-mode . (lambda ()
                             (add-to-list
                              'imenu-generic-expression
                              '("Hydras"
                                "^.*(\\(pretty-hydra-define\\) \\([a-zA-Z-]+\\)"
                                2))))
  :init
  (cl-defun pretty-hydra-title (title &optional icon-type icon-name
                                      &key face height v-adjust)
    "Add an icon in the hydra title."
    (let ((face (or face `(:inherit highlight :reverse-video t)))
          (height (or height 1.2))
          (v-adjust (or v-adjust 0.0)))
      (concat
       (when (and (icons-displayable-p) icon-type icon-name)
         (let ((f (intern (format "nerd-icons-%s" icon-type))))
           (when (fboundp f)
             (concat
              (apply f (list icon-name :face face :height height :v-adjust v-adjust))
              " "))))
       (propertize title 'face face))))

  ;; Global toggles
  (with-no-warnings
    (pretty-hydra-define toggles-hydra (:title (pretty-hydra-title "Toggles" 'faicon "nf-fa-toggle_on")
                                        :color amaranth :quit-key ("q" "C-g"))
      ("Basic"
       (("n" (cond ((fboundp 'display-line-numbers-mode)
                    (display-line-numbers-mode (if display-line-numbers-mode -1 1)))
                   ((fboundp 'gblobal-linum-mode)
                    (global-linum-mode (if global-linum-mode -1 1))))
         "line number"
         :toggle (or (bound-and-true-p display-line-numbers-mode)
                     (bound-and-true-p global-linum-mode)))
        ("a" global-aggressive-indent-mode "aggressive indent" :toggle t)
        ("d" global-hungry-delete-mode "hungry delete" :toggle t)
        ("e" electric-pair-mode "electric pair" :toggle t)
        ("c" flyspell-mode "spell check" :toggle t)
        ("s" prettify-symbols-mode "pretty symbol" :toggle t)
        ("l" global-page-break-lines-mode "page break lines" :toggle t)
        ("b" display-battery-mode "battery" :toggle t)
        ("i" display-time-mode "time" :toggle t)
        ("m" doom-modeline-mode "modern mode-line" :toggle t))
       "Highlight"
       (("h l" global-hl-line-mode "line" :toggle t)
        ("h p" show-paren-mode "paren" :toggle t)
        ("h s" symbol-overlay-mode "symbol" :toggle t)
        ("h r" rainbow-mode "rainbow" :toggle t)
        ("h w" (setq-default show-trailing-whitespace (not show-trailing-whitespace))
         "whitespace" :toggle show-trailing-whitespace)
        ("h d" rainbow-delimiters-mode "delimiter" :toggle t)
        ("h i" highlight-indent-guides-mode "indent" :toggle t)
        ("h t" global-hl-todo-mode "todo" :toggle t))
       "Program"
       (("f" flymake-mode "flymake" :toggle t)
        ("O" hs-minor-mode "hideshow" :toggle t)
        ("u" subword-mode "subword" :toggle t)
        ("W" which-function-mode "which function" :toggle t)
        ("E" toggle-debug-on-error "debug on error" :toggle (default-value 'debug-on-error))
        ("Q" toggle-debug-on-quit "debug on quit" :toggle (default-value 'debug-on-quit))
        ("v" global-diff-hl-mode "gutter" :toggle t)
        ("V" diff-hl-flydiff-mode "live gutter" :toggle t)
        ("M" diff-hl-margin-mode "margin gutter" :toggle t)
        ("D" diff-hl-dired-mode "dired gutter" :toggle t))
       "Theme"
       (("t a" (danis-load-theme 'auto) "auto"
         :toggle (eq danis-theme 'auto) :exit t)
        ("t m" (danis-load-theme 'random) "random"
         :toggle (eq danis-theme 'random) :exit t)
        ("t s" (danis-load-theme 'system) "system"
         :toggle (eq danis-theme 'system) :exit t)
        ("t d" (danis-load-theme 'default) "default"
         :toggle (danis-theme-enable-p 'default) :exit t)
        ("t p" (danis-load-theme 'pro) "pro"
         :toggle (danis-theme-enable-p 'pro) :exit t)
        ("t k" (danis-load-theme 'dark) "dark"
         :toggle (danis-theme-enable-p 'dark) :exit t)
        ("t l" (danis-load-theme 'light) "light"
         :toggle (danis-theme-enable-p 'light) :exit t)
        ("t w" (danis-load-theme 'warm) "warm"
         :toggle (danis-theme-enable-p 'warm) :exit t)
        ("t c" (danis-load-theme 'cold) "cold"
         :toggle (danis-theme-enable-p 'cold) :exit t)
        ("t y" (danis-load-theme 'day) "day"
         :toggle (danis-theme-enable-p 'day) :exit t)
        ("t n" (danis-load-theme 'night) "night"
         :toggle (danis-theme-enable-p 'night) :exit t)
        ("t o" (danis-load-theme
                (intern (completing-read "Load custom theme: "
                                         (mapcar #'symbol-name
				                                 (custom-available-themes)))))
         "others"
         :toggle (not (or (rassoc (car custom-enabled-themes) danis-theme-alist)
                          (rassoc (cadr custom-enabled-themes) danis-theme-alist)))
         :exit t))
       "Package Archive"
       (("p m" (danis-set-package-archives 'melpa t)
         "melpa" :toggle (eq danis-package-archives 'melpa) :exit t)
        ("p c" (danis-set-package-archives 'emacs-cn t)
         "emacs-cn" :toggle (eq danis-package-archives 'emacs-cn) :exit t)
        ("p b" (danis-set-package-archives 'bfsu t)
         "bfsu" :toggle (eq danis-package-archives 'bfsu) :exit t)
        ("p n" (danis-set-package-archives 'netease t)
         "netease" :toggle (eq danis-package-archives 'netease) :exit t)
        ("p s" (danis-set-package-archives 'sjtu t)
         "sjtu" :toggle (eq danis-package-archives 'sjtu) :exit t)
        ("p t" (danis-set-package-archives 'tuna t)
         "tuna" :toggle (eq danis-package-archives 'tuna) :exit t)
        ("p u" (danis-set-package-archives 'ustc t)
         "ustc" :toggle (eq danis-package-archives 'ustc) :exit t)
        ("p T" (danis-test-package-archives) "speed test" :exit t))))))

(provide 'init-hydra)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-hydra.el ends here
