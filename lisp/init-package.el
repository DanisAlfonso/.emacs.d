;;; init-package.el --- Initialize package configurations.	-*- lexical-binding: t -*-


;; Emacs Package management configurations.
;;

;;; Code:

(eval-when-compile
  (require 'init-const)
  (require 'init-custom)
  (require 'init-funcs))

;; At first startup
(when (and (file-exists-p danis-custom-example-file)
           (not (file-exists-p custom-file)))
  (copy-file danis-custom-example-file custom-file)

  ;; Test and select the fastest package archives
  (message "Testing connection... Please wait a moment.")
  (set-package-archives (danis-test-package-archives 'no-chart)))

;; Load `custom-file'
(and (file-readable-p custom-file) (load custom-file))

;; Load custom-post file
(defun load-custom-post-file ()
  "Load custom-post file."
  (cond ((file-exists-p danis-custom-post-org-file)
         (and (fboundp 'org-babel-load-file)
              (org-babel-load-file danis-custom-post-org-file)))
        ((file-exists-p danis-custom-post-file)
         (load danis-custom-post-file))))
(add-hook 'after-init-hook #'load-custom-post-file)

;; HACK: DO NOT save `package-selected-packages' to `custom-file'
;; @see https://github.com/jwiegley/use-package/issues/383#issuecomment-247801751
(defun my-package--save-selected-packages (&optional value)
  "Set `package-selected-packages' to VALUE but don't save to option `custom-file'."
  (when value
    (setq package-selected-packages value))
  (unless after-init-time
    (add-hook 'after-init-hook #'my-package--save-selected-packages)))
(advice-add 'package--save-selected-packages :override #'my-package--save-selected-packages)

;; Set ELPA packages
(set-package-archives danis-package-archives nil nil t)

;; Initialize packages
(unless (bound-and-true-p package--initialized) ; To avoid warnings in 27
  (setq package-enable-at-startup nil)          ; To prevent initializing twice
  (package-initialize))

;; More options
(setq package-install-upgrade-built-in t)

;; Setup `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Should set before loading `use-package'
(setq use-package-always-ensure t
      use-package-always-defer t
      use-package-expand-minimally t
      use-package-enable-imenu-support t)

;; Required by `use-package'
(use-package diminish :ensure t)

;; Update GPG keyring for GNU ELPA
(use-package gnu-elpa-keyring-update)

;; Update packages
(unless (fboundp 'package-upgrade-all)
  (use-package auto-package-update
    :init
    (setq auto-package-update-delete-old-versions t
          auto-package-update-hide-results t)
    (defalias 'package-upgrade-all #'auto-package-update-now)))

(provide 'init-package)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-package.el ends here
