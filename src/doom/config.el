(setq doom-font (font-spec :family "Cascadia Code NF" :size 18)
      doom-variable-pitch-font (font-spec :family "Cascadia Code NF" :size 18))

(setq doom-theme 'catppuccin)

(setq display-line-numbers-type t)

(defun my/evil-toggle-relative-lines ()
  "Toggle between relative and absolute line numbers based on Evil state."
  (setq display-line-numbers-type
        (if (memq evil-state '(normal visual motion))
            'relative
          t))
  (display-line-numbers-mode 1))

(add-hook! '(evil-normal-state-entry-hook
             evil-visual-state-entry-hook
             evil-insert-state-entry-hook
             evil-motion-state-entry-hook)
           #'my/evil-toggle-relative-lines)

(setq-default fill-column 80)
(add-hook! 'prog-mode-hook #'display-fill-column-indicator-mode)
(add-hook! 'prog-mode-hook #'rainbow-delimiters-mode)

(setq org-directory "~/org/")

(add-to-list 'default-frame-alist '(alpha-background . 95))

(dolist (mode-hook '(typescript-mode-hook
                     typescript-ts-mode-hook
                     tsx-ts-mode-hook
                     js-mode-hook
                     js-ts-mode-hook
                     rjsx-mode-hook))
  (add-hook mode-hook #'lsp-deferred))
(setq lsp-tailwindcss-add-on-mode t)
(after! lsp-mode
  (setq lsp-tailwindcss-server-path
        (executable-find "tailwindcss-language-server"))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("pyrefly" "lsp"))
                    :major-modes '(python-mode python-ts-mode)
                    :priority -1
                    :server-id 'pyrefly-ls)))

(use-package! lsp-bridge
  :config
  (global-lsp-bridge-mode))

(use-package! apheleia
  :defer t
  :init
  (setq apheleia-log-only-errors t)
  :config
  (setf (alist-get 'biome apheleia-formatters)
        '("biome" "format" "--stdin-file-path" filepath))

  (dolist (entry '((css-mode . biome)
                   (css-ts-mode . biome)
                   (js-json-mode . biome)
                   (js-mode . biome)
                   (js-ts-mode . biome)
                   (json-mode . biome)
                   (json-ts-mode . biome)
                   (rjsx-mode . biome)
                   (typescript-mode . biome)
                   (typescript-ts-mode . biome)
                   (tsx-ts-mode . biome)))
    (setf (alist-get (car entry) apheleia-mode-alist)
          (cdr entry)))

  (apheleia-global-mode +1))

(after! flycheck
  (flycheck-define-checker biome
    "A JavaScript/TypeScript linter and formatter using Biome."
    :command ("biome" "check" "--formatter-enabled=false" "--stdin-file-path" source)
    :standard-input t
    :error-patterns
    ((error line-start (file-name) ":" line ":" column " " (message) line-end))
    :modes (js2-mode rjsx-mode tsx-ts-mode typescript-mode typescript-ts-mode))

  (add-to-list 'flycheck-checkers 'biome))

(setq projectile-project-search-path '(("~/dev" . 2)))

(use-package! leetcode
  :config
  (setq leetcode-prefer-language "python3"
        leetcode-save-solutions t
        leetcode-directory "~/dev/leetcode/solutions"))

(use-package! typst-ts-mode
  :mode "\\.typ\\'"
  :config
  (setq typst-ts-indent-offset 2)

  (map! :map typst-ts-mode-map
        :localleader
        "p" #'typst-preview-mode
        "c" #'typst-ts-compile
        "w" #'typst-ts-watch-mode))

(use-package! typst-preview
  :after typst-ts-mode
  :config
  (setq typst-preview-autostart t
        typst-preview-open-browser-automatically t
        typst-preview-browser "default"
        typst-preview-invert-colors "never"
        typst-preview-partial-rendering t)

  (map! :map typst-preview-mode-map
        :localleader
        "s" #'typst-preview-send-position))
