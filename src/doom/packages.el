(package! catppuccin-theme)
(package! rainbow-delimiters)

(package! ghostel)
(package! evil-ghostel)

(package! lsp-bridge
  :recipe (:host github
           :repo "manateelazycat/lsp-bridge"
           :branch "master"
           :files ("*.el" "*.py" "acm" "core" "langserver" "multiserver" "resources")
           :build (:not compile)))

(package! astro-ts-mode
  :recipe (:build (:not autoloads)))
(package! typst-ts-mode
  :recipe (:host codeberg :repo "meow_king/typst-ts-mode"))

(package! leetcode)
(package! typst-preview
  :recipe (:host github :repo "havarddj/typst-preview.el"))
