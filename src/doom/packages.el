(package! catppuccin-theme)
(package! ghostel)
(package! rainbow-delimiters)
(package! leetcode)
(package! lsp-bridge
        :recipe (:host github
                 :repo "manateelazycat/lsp-bridge"
                 :branch "master"
                 :files ("*.el" "*.py" "acm" "core" "langserver" "multiserver" "resources")
                 :build (:not compile)))
(package! markdown-mode)
(package! yasnippet)
(package! typst-ts-mode
  :recipe (:host codeberg :repo "meow_king/typst-ts-mode"))
(package! typst-preview
  :recipe (:host github :repo "havarddj/typst-preview.el"))
