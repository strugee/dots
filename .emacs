;;;; Emacs startup
; Alex Jordan
; 17 July 2013

; This is here instead of in Emacs Builtins to avoid a jarring frame maximization halfway through init
; Note that this only handles the initial frame - new frames are handled farther down with a proper library, after the package system has bootstrapped
(if (eq system-type 'windows-nt)
  (w32-send-sys-command 61488)
  (if (eq system-type 'darwin)
      (toggle-frame-fullscreen)
    (toggle-frame-maximized)))

; This has to be here instead of in Emacs Builtins so that we can load package.el on Emacs 23 systems, in order to properly bootstrap the package manager.
(add-to-list 'load-path "~/.emacs.d/lisp")

;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; COMPATIBILITY NOTES
;
;;;;;;;;;;;;;;;;;;;;;;;;;;

; Emacs 24

; Compatible out-of-the-box.

; Emacs 23

; Requires installation of package.el in the appropriate load-path directory. ./configctl will take care of this.
; May cause problems with deftheme in the future. Works currently.
; On Debian, emacs-23 throws error "package emacs-24 is not available". Needs further debugging.

;;;;;;;;;;;;;;;
;
; PACKAGES
;
;;;;;;;;;;;;;;;

(require 'package)

; Main ELPA repository for Emacs versions where this isn't included by default
(when (< emacs-major-version 24)
	(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

; MEPLA
(add-to-list 'package-archives
	'("melpa" . "http://melpa.milkbox.net/packages/") t)

; Bug fix from the MELPA home page
(if (version< emacs-version "24.4")
    (defadvice package-compute-transaction
	(before package-compute-transaction-reverse (package-list requirements) activate compile)
		"reverse the requirements"

		(setq requirements (reverse requirements))
		(print requirements)))

(package-initialize)

; Ensure that the proper packages are installed
(defun ensure-packages (package-list)
  "Ensures packages in list are installed locally"
  (unless (file-exists-p package-user-dir)
    (package-refresh-contents))
  (dolist (package package-list)
    (unless (package-installed-p package)
      (package-install package))))

(ensure-packages '(solarized-theme markdown-mode stupid-indent-mode pkgbuild-mode nyan-mode 2048-game apache-mode display-theme less-css-mode know-your-http-well lua-mode lorem-ipsum list-processes+ melpa-upstream-visit mediawiki grunt hardcore-mode hackernews ham-mode list-packages-ext eide powershell annoying-arrows-mode json-mode jade-mode editorconfig magit magit-gh-pulls magit-tramp org-magit gist git-commit-mode git-link git-messenger gitattributes-mode gitconfig gitconfig-mode github-browse-file github-clone gitignore-mode nyan-prompt bug-reference-github xkcd telepathy znc todotxt frame-cmds maxframe))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; EMACS BUILT-IN CUSTOMIZATIONS
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Save all tempfiles in $TMPDIR/emacs$UID/
(defconst emacs-tmp-dir (format "%s/%s%s/" temporary-file-directory "emacs" (user-uid)))
(setq backup-directory-alist
	`((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms
	`((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix
	emacs-tmp-dir)

;; Unicode
(prefer-coding-system 'utf-8)
; Request UTF-8 paste data
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

(server-start)

;;;;;;;;;;
;
; ERC
;
;;;;;;;;;;

; See also CUSTOM

(require 'erc)

; SSL/TLS support
(require 'tls)

; Traditional ERC
(defun start-erc()
  "Start to waste time on IRC with ERC."
  (interactive)
  (erc-tls :server "irc.oftc.net" :port 6697
	   :nick "strugee" :full-name "Alex Jordan")
  (erc-tls :server "chat.freenode.net" :port 6697
	   :nick "strugee" :full-name "Alex Jordan")
  (erc-tls :server "irc.mozilla.org" :port 6697
	   :nick "strugee" :full-name "Alex Jordan")
  ; For shame, GNOME! No TLS?
  (erc :server "irc.gnome.org" :port 6667
       :nick "strugee" :full-name "Alex Jordan")
  (setq erc-autojoin-channels-alist '(("oftc.net" "#emacs" "#debian" "#debian-devel" "#debian-mozilla" "#debian-gnome" "#debian-next" "#debian-offtopic")
				      ("freenode.net" "#libreplanet-wa" "#archlinux" "#archlinux-offtopic" "#archlinux-newbies" "#steevie" "#plan9" "#gnome" "#whatwg")
				      ("mozilla.org" "#introduction" "#seattle" "#qa" "#developers" "#firefox" "#bugzilla" "#mozwebqa" "#js" "#webcompat" "#planning" "#fx-team" "#contributors" "#ux" "#labs" "#identity" "#webdev" "#www" "#devtools" "#build")
				      ("gnome.org" "#gnome" "#gnome-hackers" "#gnome-shell" "#gnome-design" "#gnome-love" "#webhackers" "#sysadmin"  "#gtk"))))

; ZNC-based ERC
(require 'znc)

; Control character handling customizations

(setq erc-beep-p 't)
(setq erc-interpret-mirc-color 't)

; Only add stuff to the modeline if nick or keywords are mentioned

(setq erc-track-exclude-types '("JOIN" "PART" "QUIT" "NICK" "MODE"))
(setq erc-track-use-faces t)
(setq erc-track-faces-priority-list
      '(erc-current-nick-face erc-keyword-face))
(setq erc-track-priority-faces-only 'all)

; Allow cycling through unvisited channels

(defvar erc-channels-to-visit nil
  "Channels that have not yet been visited by erc-next-channel-buffer")
(defun erc-next-channel-buffer ()
  "Switch to the next unvisited channel. See erc-channels-to-visit"
  (interactive)
  (when (null erc-channels-to-visit)
    (setq erc-channels-to-visit 
	  (remove (current-buffer) (erc-channel-list nil))))
  (let ((target (pop erc-channels-to-visit)))
    (if target 
	(switch-to-buffer target))))

; Beep when nick or keywords are mentioned

(add-hook 'erc-text-matched-hook 'erc-beep-on-match)
(setq erc-beep-match-types '(current-nick keyword))

; TODO: Beep when a private message is received

;;;;;;;;;;;;;
;
; EShell
;
;;;;;;;;;;;;;

;(add-hook 'eshell-load-hook 'nyan-prompt-enabled)

;;;;;;;;;;;;;;;;;;
;
; MAJOR MODES
;
;;;;;;;;;;;;;;;;;;

; PKGBUILD mode
(autoload 'pkgbuild-mode "pkgbuild-mode.el" "PKGBUILD mode." t)
(setq auto-mode-alist (append '(("/PKGBUILD$" . pkgbuild-mode)) auto-mode-alist))

; Python mode
(add-hook 'python-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode t)
	    (setq python-indent 8)
	    (setq tab-width 8)))

(autoload 'todotxt "todotxt.el" "A major mode for editing todo.txt files" t)
(set-variable 'todotxt-file "/home/alex/ownCloud/todo/todo.txt")
(global-set-key (kbd "C-x t") 'todotxt)

; TODO:
; apache-mode
; less-css-mode
; markdown-mode
; mediawiki
; lua-mode
; powershell-mode
; json-mode

;;;;;;;;;;;;;;;;;;
;
; MINOR MODES
;
;;;;;;;;;;;;;;;;;;

; package-list-packages improvements
; (add-hook 'package-menu-mode-hook (lambda () (list-packages-ext-mode 1))
(add-hook 'find-file-hook 'bug-reference-github-set-url-format)

;(setq too-hardcore-backspace t)
;(setq too-hardcore-return t)
;(require 'hardcore-mode)
;(global-hardcore-mode)

; TODO:
; display-theme-mode
(require 'nyan-mode)
(nyan-mode)
; markdown-mode+
; stupid-indent-mode
; ham-mode
; list-processes+
; list-packages-ext
; rainbow-delimiters-mode
; annoying-arrows-mode

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; UTILITIES & LIBRARIES
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; TODO:
; sudo-ext
(autoload '2048-game "2048-game" "play 2048 in Emacs" t)
(autoload 'apt-utils "apt-utils" "Emacs interface to APT (Debian package management)" t)
(autoload 'know-your-http-well "know-your-http-well" "Look up the meaning of HTTP headers, methods, relations, status codes" t)
(autoload 'lorem-ipsum "lorem-ipsum" "Insert dummy pseudo Latin text." t)
; melpa-upstream-visit
; mediawiki
(autoload 'grunt "grunt" "Some glue to stick Emacs and Gruntfiles together" t)
(autoload 'hackernews "hackernews" "Access the hackernews aggregator from Emacs" t)
; eide
; powershell
(autoload 'editorconfig "editorconfig" "EditorConfig Emacs extension" t)
; magit-*
(autoload 'xkcd "xkcd" "Major mode for viewing xkcd (http://xkcd.com/) comics." t)
; TODO: do something with this
;(require telepathy-autoloads)
(autoload 'frame-cmds "frame-cmds" "Frame and window commands (interactive functions)." t)
; FIXME: this frame stuff isn't working for some reason
(autoload 'maxframe "maxframe" "maximize the emacs frame based on display size" t)
(add-hook 'before-make-frame-hook 'maximize-frame)

;;;;;;;;;;;;;
;
; CUSTOM
;
; Themes, ERC, Magit
;
;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (solarized-dark)))
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(erc-modules
   (quote
    (autojoin button completion fill irccontrols list match menu move-to-prompt netsplit networks noncommands notifications readonly ring services stamp track)))
 '(erc-nick "strugee")
 '(erc-notifications-mode t)
 '(erc-user-full-name "Alex Jordan")
 '(magit-repo-dirs ~/Development)
 '(magit-use-overlays nil)
 '(znc-servers
   (quote
    (("strugee.net" 7000 t
      ((freenode "alex" "TODO_secure_this")
       (moznet "alex.moznet" "TODO_secure_this")
       (oftc "alex.oftc" "TODO_secure_this")
       (gimpnet "alex.gimpnet" "TODO_secure_this")))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
