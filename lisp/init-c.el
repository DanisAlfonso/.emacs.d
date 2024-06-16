;; init-c.el --- Initialize c configurations.	-*- lexical-binding: t -*-

;; C/C++ configuration.
;;

;;; Code:

(eval-when-compile
  (require 'init-custom))

;; C/C++ Mode
(use-package cc-mode
  :ensure nil
  :bind (:map c-mode-base-map
         ("<f12>" . compile))
  :init (setq-default c-basic-offset 4))

(when (danis-treesit-available-p)
  (use-package c-ts-mode
    :init (setq c-ts-mode-indent-offset 4)))

(provide 'init-c)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-c.el ends here
