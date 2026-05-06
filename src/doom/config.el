;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Neal Wang"
      user-mail-address "nealwang.sh@protonmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Cascadia Code NF" :size 18 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Cascadia Code NF" :size 18))

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'catppuccin)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(defun my/evil-toggle-relative-lines ()
  "Toggle between relative and absolute line numbers based on Evil state."
  (setq display-line-numbers-type
        (if (memq evil-state '(normal visual motion))
            'relative
          t))
  (display-line-numbers-mode 1))

;; Hook into Evil state changes
(add-hook 'evil-normal-state-entry-hook #'my/evil-toggle-relative-lines)
(add-hook 'evil-visual-state-entry-hook #'my/evil-toggle-relative-lines)
(add-hook 'evil-insert-state-entry-hook #'my/evil-toggle-relative-lines)
(add-hook 'evil-motion-state-entry-hook #'my/evil-toggle-relative-lines)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(add-to-list 'default-frame-alist '(alpha-background . 90))

(use-package! gptel
  :config
  (setq auth-sources '("~/.authinfo"))

  ;; Gemini backend
  (defvar gptel-gemini-backend
    (gptel-make-gemini "Gemini"
      :key (lambda () (auth-source-pick-first-password :host "api.generativelanguage.googleapis.com"))
      :stream t
      :models '(gemini-3.1-flash-lite-preview
                gemini-2.5-flash)))

  ;; Register all backends
  (setq gptel-backends (list gptel-gemini-backend))

  ;; Set the initial global defaults
  (setq-default gptel-model 'gemini-3.1-flash-lite-preview
                gptel-backend gptel-gemini-backend))

(use-package! leetcode
  :config
  (setq leetcode-prefer-language "python3"
        leetcode-save-solutions t
        leetcode-directory "~/dev/leetcode/solutions"))
