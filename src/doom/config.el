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

(use-package! evil-ghostel
  :after (ghostel evil)
  :hook (ghostel-mode . evil-ghostel-mode))

(use-package! lsp-bridge
  :config
  (setq lsp-bridge-nix-lsp-server "nil"
        lsp-bridge-python-multi-lsp-server "ty_ruff")

  (add-to-list 'lsp-bridge-default-mode-hooks 'zig-ts-mode-hook)

  (global-lsp-bridge-mode)

  (map! :map lsp-bridge-mode-map
        :n "K" #'lsp-bridge-popup-documentation

        :leader
        :desc "Code actions" "c a" #'lsp-bridge-code-action
        :desc "Rename symbol" "c r" #'lsp-bridge-rename))

(after! acm
  (map! :map acm-mode-map
        "RET" nil

        :i
        "C-n" #'acm-select-next
        "C-p" #'acm-select-prev
        "C-k" #'acm-complete))

(use-package! apheleia
  :defer t
  :init
  (setq apheleia-log-only-errors t)
  :config
  (dolist (entry '((astro-ts-mode . biome)
                   (css-ts-mode . biome)
                   (js-ts-mode . biome)
                   (json-ts-mode . biome)
                   (python-ts-mode . ruff)
                   (rjsx-mode . biome)
                   (tsx-ts-mode . biome)
                   (typescript-ts-mode . biome)))
    (setf (alist-get (car entry) apheleia-mode-alist)
          (cdr entry))))

(after! flycheck
  (global-flycheck-lsp-mode 1))

(setq projectile-project-search-path '(("~/dev" . 2)))

(use-package! leetcode
  :config
  (setq leetcode-prefer-language "python3"
        leetcode-save-solutions t
        leetcode-directory "~/dev/leetcode/solutions"))

(use-package! astro-ts-mode
  :mode "\\.astro\\'")

(use-package! typst-ts-mode
  :mode "\\.typ\\'"
  :config
  (setq typst-ts-indent-offset 2)

  (map! :map typst-ts-mode-map
        :localleader
        :desc "Typst preview" "p" #'typst-preview-mode
        :desc "Typst compile" "c" #'typst-ts-compile
        :desc "Typst watch" "w" #'typst-ts-watch-mode))

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
        :desc "Typst preview send position" "s" #'typst-preview-send-position))

(setq rmh-elfeed-org-files (list (expand-file-name "elfeed.org" org-directory)))
