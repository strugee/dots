;;;; Emacs startup
; Alex Jordan
; 17 July 2013

; PKGBUILD mode
(autoload 'pkgbuild-mode "pkgbuild-mode.el" "PKGBUILD mode." t)
(setq auto-mode-alist (append '(("/PKGBUILD$" . pkgbuild-mode)) auto-mode-alist))

; Main ELPA repository for Emacs versions where this isn't included by default
(when (< emacs-major-version 24)
	(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
; MEPLA
(require 'package)
(add-to-list 'package-archives
	'("melpa" . "http://melpa.milkbox.net/packages/") t)

; Bug fix from the MELPA home page
(defadvice package-compute-transaction
	(before package-compute-transaction-reverse (package-list requirements) activate compile)
		"reverse the requirements"

		(setq requirements (reverse requirements))
		(print requirements))
