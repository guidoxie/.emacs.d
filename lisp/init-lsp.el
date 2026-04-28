;; 现代化的极简补全前端
(use-package corfu
  :custom
  (corfu-auto t)                 ; 敲击代码时自动触发补全
  (corfu-auto-prefix 2)          ; 输入 2 个字符后触发
  (corfu-quit-no-match t)        ; 没匹配到就自动关闭菜单，保持视觉干净
  (corfu-preview-current nil)    ; 终端下关闭补全项的内联预览，防止画面闪烁
  :init
  (global-corfu-mode))

;; 终端悬浮窗的底层绘图依赖 (必须有)
(use-package popon
  :straight (popon :type git :repo "https://codeberg.org/akib/emacs-popon.git"))

;; 核心黑魔法：让 Corfu 的悬浮菜单在终端 (Ghostty) 中完美渲染
(use-package corfu-terminal
  :straight (corfu-terminal :type git :repo "https://codeberg.org/akib/emacs-corfu-terminal.git")
  :init
  (corfu-terminal-mode +1))


;; Golang 语法高亮与环境支持
(use-package go-mode
  :hook
  ;; 当打开 .go 文件时，自动唤起 Eglot 连接 gopls
  (go-mode . eglot-ensure)
  :config
  ;; 现代的保存自动格式化逻辑 (依托 LSP 能力)
  (defun eglot-format-buffer-on-save ()
    (add-hook 'before-save-hook #'eglot-format-buffer -1 t))
  (add-hook 'go-mode-hook #'eglot-format-buffer-on-save)

  ;; 保存时自动组织 Imports
  (defun eglot-organize-imports-on-save ()
    (add-hook 'before-save-hook
              (lambda () (call-interactively 'eglot-code-action-organize-imports))
              -1 t))
  (add-hook 'go-mode-hook #'eglot-organize-imports-on-save))

;; Python 现代开发环境
(use-package python
  :defer t
  :hook
  ;; 打开 .py 文件时自动唤起 Eglot (会自动寻找系统里的 pyright)
  (python-mode . eglot-ensure)
  ;; (如果你使用的是 Emacs 29+ 并且开启了 Tree-sitter，加上这行)
  (python-ts-mode . eglot-ensure)
  :custom
  ;; 如果你习惯在底部分屏开一个 REPL 交互式终端，推荐改成 ipython
  (python-shell-interpreter "ipython")
  (python-shell-interpreter-args "-i --simple-prompt")
  :config
  ;; 配合 Ruff 实现保存时极速自动格式化 (类似 Golang 的体验)
  (defun python-format-on-save ()
    (add-hook 'before-save-hook #'eglot-format-buffer -1 t))
  (add-hook 'python-mode-hook #'python-format-on-save))

;; Markdown 语法高亮
(use-package markdown-mode
  :mode ("\\.md\\'" . markdown-mode)
  :custom
  (markdown-command "multimarkdown"))

;; 环境管理，完美解决 Python 虚拟环境识别问题
(use-package envrc
  :init
  (envrc-global-mode))

(provide 'init-lsp)
