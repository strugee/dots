;;;; Emacs startup
; Alex Jordan
; 17 July 2013

; This has to be here instead of in Emacs Builtins so that we can load package.el on Emacs 23 systems, in order to properly bootstrap the package manager.
(add-to-list 'load-path "~/.emacs.d/lisp")

;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; COMPATIBILITY NOTES
;
;;;;;;;;;;;;;;;;;;;;;;;;;;

; Emacs 25

; Compatible out-of-the-box.

; Emacs 24

; Compatible out-of-the-box. May need manual .emacs intervention when adding packages.

; Emacs 23

; Requires installation of package.el in the appropriate load-path directory. ./configctl will take care of this.
; May cause problems with deftheme in the future. Works currently.
; On Debian, emacs-23 throws error "package emacs-24 is not available". Needs further debugging.

;;;;;;;;;;;;;;;;;;;;;;;;
;
; UTILITY FUNCTIONS
;
;;;;;;;;;;;;;;;;;;;;;;;;

(defun local-config-val-p (val)
  "See if VAL is present in the local-config file."
  (member (concat "emacs-" val)
	  (let ((filename (expand-file-name "~/configs/local-config")))
	    (if (file-exists-p filename)
		(with-temp-buffer (insert-file-contents filename)
				  (split-string (buffer-string) "\n" t))
	      (list)))))

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
	'("melpa" . "https://melpa.org/packages/") t)

; Bug fix from the MELPA home page
(if (version< emacs-version "24.4")
    (defadvice package-compute-transaction
	(before package-compute-transaction-reverse (package-list requirements) activate compile)
		"reverse the requirements"

		(setf requirements (reverse requirements))
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

(ensure-packages '(solarized-theme markdown-mode stupid-indent-mode pkgbuild-mode nyan-mode 2048-game apache-mode display-theme less-css-mode know-your-http-well lua-mode lorem-ipsum melpa-upstream-visit mediawiki grunt hardcore-mode hackernews ham-mode list-packages-ext eide powershell annoying-arrows-mode json-mode jade-mode editorconfig magit magit-gh-pulls gist git-link git-messenger gitattributes-mode gitconfig gitconfig-mode github-browse-file github-clone gitignore-mode bug-reference-github xkcd telepathy znc todotxt maxframe js2-mode smart-tabs-mode spaceline window-numbering coffee-mode yaml-mode sed-mode livescript-mode erlang forth-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; EMACS BUILT-IN CUSTOMIZATIONS
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Save all tempfiles in $TMPDIR/emacs$UID/
(defconst emacs-tmp-dir
  (format "%s/%s%s/" temporary-file-directory "emacs" (user-uid)))
(setf backup-directory-alist
	`((".*" . ,emacs-tmp-dir)))
(setf auto-save-file-name-transforms
	`((".*" ,emacs-tmp-dir t)))
(setf auto-save-list-file-prefix
	emacs-tmp-dir)

;; Unicode
(prefer-coding-system 'utf-8)
; Request UTF-8 paste data
(setf x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

(server-start)

; Don't break hard-tabs into spaces on DEL
(setf backward-delete-char-untabify-method nil)

; Disable VC
(setf vc-handled-backends nil)

(if (eq system-type 'darwin)
    (add-to-list 'exec-path "/usr/local/bin"))

; Maximize all frames
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-to-list 'window-system-default-frame-alist
	     '(ns (fullscreen . fullscreen)))

;; Handle stale desktop lockfiles... because Emacs is too dumb to do this itself :/
;; *sigh*

(defun process-p (pid)
  "If pid is the process ID of a running process, return t, else nil.
If pid is nil, return nil."
  (when pid
    (= (call-process "ps" nil nil nil "-p"
		     (number-to-string pid)) 0)))

;; Emacs doesn't set this itself half the time and I can't figure out why or when
(setf desktop-dirname "~/.emacs.d/")

(require 'desktop)
(unless (process-p (desktop-owner))
  (desktop-release-lock))

; Session restore
(desktop-save-mode 1)
(setf desktop-auto-save-timeout 30)
(savehist-mode)

(setq epg-gpg-program "qubes-gpg")

;;;;;;;;;;;;;
;
; MODELINE
;
;;;;;;;;;;;;;

(require 'spaceline-config)
(spaceline-emacs-theme)

(setf powerline-default-separator 'wave)
(setf spaceline-window-numbers-unicode t)

(setf spaceline-erc-track-p nil)

(require 'nyan-mode)
(nyan-mode)

;;;;;;;;;;;;;;;;;
;
; DEFAULT FRAMES
;
;;;;;;;;;;;;;;;;;

(defconst irc-frame
  (make-frame)
  "Live frame intended to hold windows with ERC buffers")

; IRC frame windows - top-bottom first, then right-left
(split-window (frame-root-window irc-frame) nil 'below)
(dolist (window (window-list irc-frame))
  (split-window window nil 'right))

;;;;;;;;;;
;
; ERC
;
;;;;;;;;;;

; See also CUSTOM

(require 'erc)

; SSL/TLS support
(require 'tls)

(setf erc-modules
      (quote
       (autojoin button completion fill irccontrols list log match menu move-to-prompt netsplit networks noncommands notifications readonly ring stamp track)))
(setf erc-nick "strugee")
(setf erc-notifications-mode t)
(setf erc-user-full-name "AJ Jordan")

; Control character handling customizations

(setf erc-beep-p 't)
(setf erc-interpret-mirc-color 't)

; Only add stuff to the modeline if nick or keywords are mentioned

(setf erc-track-exclude-types '("JOIN" "PART" "QUIT" "NICK" "MODE"
				"324" "329" "332" "333" "353" "477"))
(setf erc-track-use-faces t)
(setf erc-track-faces-priority-list
      '(erc-current-nick-face erc-keyword-face))
(setf erc-track-priority-faces-only nil)

; Make private messages more urgent

(defadvice erc-track-find-face (around erc-track-find-face-promote-query activate)
  (if (erc-query-buffer-p)
      (setf ad-return-value (intern "erc-current-nick-face"))
    ad-do-it))

; Bury new IRC buffers

(setf erc-join-buffer 'bury)

; Reuse existing buffers on reconnect
(setf erc-reuse-buffers t)

; Load old logs from disk
(setf erc-log-insert-log-on-open t)

; Allow cycling through unvisited channels

(defvar erc-channels-to-visit nil
  "Channels that have not yet been visited by erc-next-channel-buffer")
(defun erc-next-channel-buffer ()
  "Switch to the next unvisited channel. See erc-channels-to-visit"
  (interactive)
  (when (null erc-channels-to-visit)
    (setf erc-channels-to-visit
	  (remove (current-buffer) (erc-channel-list nil))))
  (let ((target (pop erc-channels-to-visit)))
    (if target
	(switch-to-buffer target))))

; Beep when nick or keywords are mentioned
; TODO: this doesn't catch "strugee's"

(add-hook 'erc-text-matched-hook 'erc-beep-on-match)
(setf erc-beep-match-types '(current-nick keyword))

; TODO: Beep when a private message is received

; Traditional ERC
(defun start-erc()
  "Start to waste time on IRC with ERC."
  (interactive)
  (erc-tls :server "irc.oftc.net" :port 6697
	   :nick "strugee" :full-name "AJ Jordan")
  (erc-tls :server "chat.freenode.net" :port 6697
	   :nick "strugee" :full-name "AJ Jordan")
  (erc-tls :server "irc.mozilla.org" :port 6697
	   :nick "strugee" :full-name "AJ Jordan")
  (erc-tls :server "irc.gnome.org" :port 6697
       :nick "strugee" :full-name "AJ Jordan")
  (setf erc-autojoin-channels-alist '(("oftc.net" "#emacs" "#debian" "#debian-devel" "#debian-mozilla" "#debian-gnome" "#debian-next" "#debian-offtopic")
				      ("freenode.net" "#libreplanet-wa" "#archlinux" "#archlinux-offtopic" "#archlinux-newbies" "#steevie" "#plan9" "#gnome" "#whatwg" "#pump.io" "#conservancy" "#stratic")
				      ("mozilla.org" "#introduction" "#seattle" "#qa" "#developers" "#firefox" "#bugzilla" "#mozwebqa" "#js" "#webcompat" "#planning" "#fx-team" "#contributors" "#ux" "#labs" "#identity" "#webdev" "#www" "#devtools" "#build")
				      ("gnome.org" "#gnome" "#gnome-hackers" "#gnome-shell" "#gnome-design" "#gnome-love" "#webhackers" "#sysadmin"  "#gtk"))))

; ZNC-based ERC
(require 'znc)

(unless (or (string-equal system-name "steevie.strugee.net") (local-config-val-p "no-znc"))
    (setf znc-password
	  (let ((secret
		 (plist-get
		  (nth 0
		       (let ((auth-source-creation-defaults '(user "alex"))
			     (auth-source-creation-prompts
			      '((password . "Enter ZNC password for %h:%p: "))))
			 (auth-source-search :max 1
					     :host "znc.strugee.net"
					     :port 7000
					     :type 'netrc
					     :require '(:secret)
					     :create t)))
		  :secret)))
	    (if (functionp secret)
		(funcall secret)
	      secret)))

    (setf znc-servers
	  `(("znc.strugee.net" 7000 t
	     ((freenode "alex" ,znc-password)
	      (oftc "alex" ,znc-password)
	      (gimpnet "alex" ,znc-password)
	      (W3C "alex" ,znc-password)))))
    ;; TODO don't blindly swallow all errors
    ;; Instead we want to check if the error message exactly equals "znc.strugee.net/7000 nodename nor servname provided, or not known"
    (condition-case nil
	(znc-all)
      (error (message "ZNC initialization failure due to network connectivity problem"))))

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
(setf auto-mode-alist (append '(("/PKGBUILD$" . pkgbuild-mode)) auto-mode-alist))

; Python mode
(add-hook 'python-mode-hook 'guess-style-guess-tabs-mode)
(add-hook 'python-mode-hook (lambda ()
			      (when indent-tabs-mode
				(guess-style-guess-tab-width))))

; HTML mode
(add-hook 'html-mode-hook
	  (lambda()
            (setf sgml-basic-offset 8)
            (setf indent-tabs-mode t)))

; todotxt mode
(autoload 'todotxt "todotxt.el" "A major mode for editing todo.txt files" t)
(set-variable 'todotxt-file "/home/alex/ownCloud/todo/todo.txt")
(global-set-key (kbd "C-x t") 'todotxt)

; js2-mode
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
; TODO: reorganize so that this isn't so out of place
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'interpreter-mode-alist '("node" . js2-mode))
(setf js2-include-node-externs t)
(smart-tabs-advice js2-indent-line js2-basic-offset)

; org-mode
(setf org-log-done t)

; git-commit-mode
(global-git-commit-mode)

(setf auto-mode-alist
      (append  '(("\\.st\\'" . smalltalk-mode))
	       auto-mode-alist))

(autoload 'smalltalk-mode "gnu-smalltalk/smalltalk-mode" "" t)

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

(smart-tabs-insinuate 'c 'javascript)

; package-list-packages improvements
; (add-hook 'package-menu-mode-hook (lambda () (list-packages-ext-mode 1))
(add-hook 'find-file-hook 'bug-reference-github-set-url-format)

;(setf too-hardcore-backspace t)
;(setf too-hardcore-return t)
;(require 'hardcore-mode)
;(global-hardcore-mode)

(global-linum-mode)

; TODO:
; display-theme-mode
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
(load "magit-autoloads")
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
; Themes, Magit
;
;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(solarized-dark))
 '(custom-safe-themes
   '("fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default))
 '(epg-gpg-program "qubes-gpg" t)
 '(magit-repository-directories '("~/Development"))
 '(magit-use-overlays nil)
 '(package-selected-packages
   '(forth-mode erlang achievements livescript-mode sed-mode znc xkcd window-numbering todotxt telepathy sudo-ext stupid-indent-mode smart-tabs-mode powershell pkgbuild-mode org-magit nyan-prompt nyan-mode muttrc-mode melpa-upstream-visit maxframe markdown-mode+ magit-tramp magit-gh-pulls magit-filenotify lua-mode lorem-ipsum list-processes+ list-packages-ext less-css-mode know-your-http-well json-mode js2-mode jade-mode hardcore-mode ham-mode hackernews grunt gitignore-mode github-clone github-browse-file gitconfig-mode gitconfig gitattributes-mode git-messenger git-link gist frame-cmds eide editorconfig-core editorconfig display-theme coffee-mode bug-reference-github bbcode-mode apache-mode annoying-arrows-mode 2048-game)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
