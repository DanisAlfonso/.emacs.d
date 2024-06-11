;;; custom.el --- user customization file    -*- lexical-binding: t no-byte-compile: t -*-
;;; Commentary:
;;;       Add or change the configurations in custom.el, then restart Emacs.
;;;       Put your own configurations in custom-post.el to override default configurations.
;;; Code:

;; (setq danis-logo nil)                        ; Logo file or nil (official logo)
;; (setq danis-full-name "user name")           ; User full name
;; (setq danis-mail-address "user@email.com")   ; Email address
;; (setq danis-proxy "127.0.0.1:7890")          ; HTTP/HTTPS proxy
;; (setq danis-socks-proxy "127.0.0.1:7890")    ; SOCKS proxy
;; (setq danis-server nil)                      ; Enable `server-mode' or not: t or nil
;; (setq danis-icon nil)                        ; Display icons or not: t or nil
;; (setq danis-package-archives 'melpa)         ; Package repo: melpa, emacs-cn, bfsu, netease, sjtu, tencent, tuna or ustc
;; (setq danis-theme 'auto)                     ; Color theme: auto, random, system, default, pro, dark, light, warm, cold, day or night
;; (setq danis-completion-style 'minibuffer)    ; Completion display style: minibuffer or childframe
;; (setq danis-dashboard nil)                   ; Display dashboard at startup or not: t or nil
;; (setq danis-lsp 'lsp-mode)                   ; Set LSP client: lsp-mode, eglot or nil
;; (setq danis-lsp-format-on-save t)            ; Auto format buffers on save: t or nil
;; (setq danis-lsp-format-on-save-ignore-modes '(c-mode c++-mode python-mode markdown-mode)) ; Ignore format on save for some languages
;; (setq danis-tree-sitter nil)                 ; Enable tree-sitter or not: t or nil. Only available in 29+.
;; (setq danis-chinese-calendar t)              ; Support Chinese calendar or not: t or nil
;; (setq danis-player t)                        ; Enable players or not: t or nil
;; (setq danis-prettify-symbols-alist nil)      ; Alist of symbol prettifications. Nil to use font supports ligatures.
;; (setq danis-prettify-org-symbols-alist nil)  ; Alist of symbol prettifications for `org-mode'

;; For Emacs devel
;; (setq package-user-dir (locate-user-emacs-file (format "elpa-%s" emacs-major-version)))
;; (setq desktop-base-file-name (format ".emacs-%s.desktop" emacs-major-version))
;; (setq desktop-base-lock-name (format ".emacs-%s.desktop.lock" emacs-major-version))

;; Fonts
(defun danis-setup-fonts ()
  "Setup fonts."
  (when (display-graphic-p)
    ;; Set default font
    (cl-loop for font in '("Jetbrains Mono"
                           "SF Mono" "Hack" "Source Code Pro" "Menlo"
                           "Monaco" "DejaVu Sans Mono" "Consolas")
             when (font-installed-p font)
             return (set-face-attribute 'default nil
                                        :family font
                                        :height (cond (sys/macp 130)
                                                      (sys/win32p 110)
                                                      (t 100))))

    ;; Set mode-line font
    ;; (cl-loop for font in '("Menlo" "SF Pro Display" "Helvetica")
    ;;          when (font-installed-p font)
    ;;          return (progn
    ;;                   (set-face-attribute 'mode-line nil :family font :height 120)
    ;;                   (when (facep 'mode-line-active)
    ;;                     (set-face-attribute 'mode-line-active nil :family font :height 120))
    ;;                   (set-face-attribute 'mode-line-inactive nil :family font :height 120)))

    ;; Specify font for all unicode characters
    (cl-loop for font in '("Segoe UI Symbol" "Symbola" "Symbol")
             when (font-installed-p font)
             return (if (< emacs-major-version 27)
                        (set-fontset-font "fontset-default" 'unicode font nil 'prepend)
                      (set-fontset-font t 'symbol (font-spec :family font) nil 'prepend)))

    ;; Emoji
    (cl-loop for font in '("Noto Color Emoji" "Apple Color Emoji" "Segoe UI Emoji")
             when (font-installed-p font)
             return (cond
                     ((< emacs-major-version 27)
                      (set-fontset-font "fontset-default" 'unicode font nil 'prepend))
                     ((< emacs-major-version 28)
                      (set-fontset-font t 'symbol (font-spec :family font) nil 'prepend))
                     (t
                      (set-fontset-font t 'emoji (font-spec :family font) nil 'prepend))))

(danis-setup-fonts)
(add-hook 'window-setup-hook #'danis-setup-fonts)
(add-hook 'server-after-make-frame-hook #'danis-setup-fonts)

;; Mail
;; (setq message-send-mail-function 'smtpmail-send-it
;;       smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
;;       smtpmail-auth-credentials '(("smtp.gmail.com" 587
;;                                    user-mail-address nil))
;;       smtpmail-default-smtp-server "smtp.gmail.com"
;;       smtpmail-smtp-server "smtp.gmail.com"
;;       smtpmail-smtp-service 587)

;; Misc.
;; (setq confirm-kill-emacs 'y-or-n-p)

;; Enable proxy
;; (proxy-http-enable)
;; (proxy-socks-enable)

;; Display on the specified monitor
;; (when (and (> (length (display-monitor-attributes-list)) 1)
;;            (> (display-pixel-width) 1920))
;;   (set-frame-parameter nil 'left 1920))

;; (put 'cl-destructuring-bind 'lisp-indent-function 'defun)
;; (put 'pdf-view-create-image 'lisp-indent-function 'defun)
;; (put 'treemacs-create-theme 'lisp-indent-function 'defun)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; custom.el ends here