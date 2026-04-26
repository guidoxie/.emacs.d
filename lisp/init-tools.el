;; 垂直显示的补全界面底座
(use-package vertico
  :init
  (vertico-mode)
  :config
  ;; 让当前选择项的上下滚动循环
  (setq vertico-cycle t))


;; 强大的无序模糊匹配引擎
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))


;; 在搜索列表中显示详细的注解信息
(use-package marginalia
  :init
  (marginalia-mode))

;; 实用的搜索增强命令集合
(use-package consult
  :bind
  (;; ==========================================
   ;; [核心平替] 直接覆盖你已经形成肌肉记忆的按键
   ;; ==========================================
   ("C-s" . consult-line)           ;; 替换原生搜索：从逐字匹配升级为全屏预览 + 模糊匹配
   ("C-x b" . consult-buffer)       ;; 替换原生切换：支持预览，且能同时搜 Buffer 和最近文件
   ("M-y" . consult-yank-pop)       ;; 替换原生粘贴：告别盲目按 M-y，直接弹出剪贴板历史菜单
   ("M-g g" . consult-goto-line)    ;; 替换原生跳行：输入行号时，背景会实时滚动到那一行预览
   ("M-g M-g" . consult-goto-line)  ;; (兼容跳行的另一种按法)
   ("C-x r b" . consult-bookmark)   ;; 替换原生书签：支持过滤和预览
   ("M-g i" . consult-imenu)        ;; 替换原生大纲：极速跳转到函数、变量定义

   ;; ==========================================
   ;; [进阶扩充] 统一放在 M-s (Search) 前缀下
   ;; ==========================================
   ("M-s g" . consult-ripgrep)      ;; 跨文件全文搜索 (依赖系统安装了 rg)
   ("M-s f" . consult-find)))       ;; 跨文件找文件名 (依赖系统安装了 fd 或 find)



(provide 'init-tools)


