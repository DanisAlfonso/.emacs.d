;; init-custom.el --- Define customizations.	-*- lexical-binding: t -*-


;; Customization.
;;

;;; Code:

(eval-when-compile
  (require 'package))

(defgroup danis nil
  "DNR Emacs customization."
  :group 'convenience
  :link '(url-link :tag "Homepage" "https://github.com/DanisAlfonso/.emacs.d"))

(defcustom danis-logo (expand-file-name
                         (if (display-graphic-p) "logo.png" "banner.txt")
                         user-emacs-directory)
  "Set DNR logo. nil means official logo."
  :group 'danis
  :type 'string)

(defcustom danis-full-name user-full-name
  "Set user full name."
  :group 'danis
  :type 'string)

(defcustom danis-mail-address user-mail-address
  "Set user email address."
  :group 'danis
  :type 'string)

(defcustom danis-org-directory (expand-file-name "~/org")
  "Set org directory."
  :group 'danis
  :type 'string)

(defcustom danis-proxy "127.0.0.1:1087"
  "Set HTTP/HTTPS proxy."
  :group 'danis
  :type 'string)

(defcustom danis-socks-proxy "127.0.0.1:1086"
  "Set SOCKS proxy."
  :group 'danis
  :type 'string)

(defcustom danis-server t
  "Enable `server-mode' or not."
  :group 'danis
  :type 'boolean)

(defcustom danis-icon t
  "Display icons or not."
  :group 'danis
  :type 'boolean)

;; Emacs Lisp Package Archive (ELPA)
;; @see https://github.com/melpa/melpa and https://elpa.emacs-china.org/.
(defcustom danis-package-archives-alist
  (let ((proto (if (gnutls-available-p) "https" "http")))
    `((melpa    . (("gnu"    . ,(format "%s://elpa.gnu.org/packages/" proto))
                   ("nongnu" . ,(format "%s://elpa.nongnu.org/nongnu/" proto))
                   ("melpa"  . ,(format "%s://melpa.org/packages/" proto))))))
  "A list of the package archives."
  :group 'danis
  :type '(alist :key-type (symbol :tag "Archive group name")
                :value-type (alist :key-type (string :tag "Archive name")
                                   :value-type (string :tag "URL or directory name"))))

(defcustom danis-package-archives 'melpa
  "Set package archives from which to fetch."
  :group 'danis
  :set (lambda (symbol value)
         (set symbol value)
         (setq package-archives
               (or (alist-get value danis-package-archives-alist)
                   (error "Unknown package archives: `%s'" value))))
  :type `(choice ,@(mapcar
                    (lambda (item)
                      (let ((name (car item)))
                        (list 'const
                              :tag (capitalize (symbol-name name))
                              name)))
                    danis-package-archives-alist)))

(defcustom danis-theme-alist
  '((default . doom-one)
    (pro     . doom-monokai-pro)
    (dark    . doom-vibrant)
    (light   . doom-one-light)
    (warm    . doom-solarized-light)
    (cold    . doom-palenight)
    (day     . doom-tomorrow-day)
    (night   . doom-tomorrow-night))
  "List of themes mapped to internal themes."
  :group 'danis
  :type '(alist :key-type (symbol :tag "Theme")
                :value-type (symbol :tag "Internal theme")))

(defcustom danis-auto-themes '(("8:00"  . doom-one-light)
				                 ("19:00" . doom-one))
  "List of themes mapped to the time they should be loaded.

The keywords `:sunrise' and `:sunset' can be used for the time
if the option `calendar-latitude' and option `calendar-longitude' are set.
For example:
  \\='((:sunrise . doom-one-light)
    (:sunset  . doom-one))"
  :group 'danis
  :type '(alist :key-type (string :tag "Time")
                :value-type (symbol :tag "Theme")))

(defcustom danis-system-themes '((light . doom-one-light)
				                   (dark  . doom-one))
  "List of themes related the system appearance.

It's only available on macOS currently."
  :group 'danis
  :type '(alist :key-type (symbol :tag "Appearance")
                :value-type (symbol :tag "Theme")))

(defcustom danis-theme 'default
  "The color theme."
  :group 'danis
  :type `(choice (const :tag "Auto" auto)
                 (const :tag "Random" random)
                 (const :tag "System" system)
                 ,@(mapcar
                    (lambda (item)
                      (let ((name (car item)))
                        (list 'const
                              :tag (capitalize (symbol-name name))
                              name)))
                    danis-theme-alist)
                 symbol))

(defcustom danis-completion-style 'childframe
  "Completion display style."
  :group 'danis
  :type '(choice (const :tag "Minibuffer" minibuffer)
                 (const :tag "Child Frame" childframe)))

(defcustom danis-dashboard (not (daemonp))
  "Display dashboard at startup or not.
If Non-nil, use dashboard, otherwise will restore previous session."
  :group 'danis
  :type 'boolean)

(defcustom danis-lsp 'eglot
  "Set language server.

`lsp-mode': See https://github.com/emacs-lsp/lsp-mode.
`eglot': See https://github.com/joaotavora/eglot.
nil means disabled."
  :group 'danis
  :type '(choice (const :tag "LSP Mode" lsp-mode)
                 (const :tag "Eglot" eglot)
                 (const :tag "Disable" nil)))

(defcustom danis-tree-sitter t
  "Enable tree-sitter or not.
Native tree-sitter is introduced in 29."
  :group 'danis
  :type 'boolean)

(defcustom danis-lsp-format-on-save nil
  "Auto format buffers on save."
  :group 'danis
  :type 'boolean)

(defcustom danis-lsp-format-on-save-ignore-modes
  '(c-mode c++-mode python-mode markdown-mode)
  "The modes that don't auto format and organize imports while saving the buffers.
`prog-mode' means ignoring all derived modes."
  :group 'danis
  :type '(repeat (symbol :tag "Major-Mode")))

(defcustom danis-chinese-calendar nil
  "Enable Chinese calendar or not."
  :group 'danis
  :type 'boolean)

(defcustom danis-player nil
  "Enable players or not."
  :group 'danis
  :type 'boolean)

(defcustom danis-prettify-symbols-alist
  '(("lambda" . ?λ)
    ("<-"     . ?←)
    ("->"     . ?→)
    ("->>"    . ?↠)
    ("=>"     . ?⇒)
    ("map"    . ?↦)
    ("/="     . ?≠)
    ("!="     . ?≠)
    ("=="     . ?≡)
    ("<="     . ?≤)
    (">="     . ?≥)
    ("=<<"    . (?= (Br . Bl) ?≪))
    (">>="    . (?≫ (Br . Bl) ?=))
    ("<=<"    . ?↢)
    (">=>"    . ?↣)
    ("&&"     . ?∧)
    ("||"     . ?∨)
    ("not"    . ?¬))
  "A list of symbol prettifications.
Nil to use font supports ligatures."
  :group 'danis
  :type '(alist :key-type string :value-type (choice character sexp)))

(defcustom danis-prettify-org-symbols-alist
  '(("[ ]"            . ?)
    ("[-]"            . ?)
    ("[X]"            . ?)

    (":PROPERTIES:"   . ?)
    (":ID:"           . ?🪪)
    (":END:"          . ?🔚)

    ("#+ARCHIVE:"     . ?📦)
    ("#+AUTHOR:"      . ?👤)
    ("#+CREATOR:"     . ?💁)
    ("#+DATE:"        . ?📆)
    ("#+DESCRIPTION:" . ?⸙)
    ("#+EMAIL:"       . ?📧)
    ("#+HEADERS"      . ?☰)
    ("#+OPTIONS:"     . ?⚙)
    ("#+SETUPFILE:"   . ?⚒)
    ("#+TAGS:"        . ?🏷)
    ("#+TITLE:"       . ?📓)

    ("#+BEGIN_SRC"    . ?✎)
    ("#+END_SRC"      . ?□)
    ("#+BEGIN_QUOTE"  . ?«)
    ("#+END_QUOTE"    . ?»)
    ("#+RESULTS:"     . ?💻))
  "A list of symbol prettifications for `org-mode'."
  :group 'danis
  :type '(alist :key-type string :value-type (choice character sexp)))

;; Load `custom-file'
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(provide 'init-custom)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-custom.el ends here
