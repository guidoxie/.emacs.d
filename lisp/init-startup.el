;; 设置系统编码
(prefer-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

;; 全局开启原生行号显示
(global-display-line-numbers-mode t)

;; 关闭欢迎界面
(setq inhibit-startup-screen t)
;; 关闭了 Emacs 默认生成 ~ 后缀备份文件的行为
(setq make-backup-files nil)


;; 拦截复制：将 Emacs 的 kill-ring 内容发送给 Mac 的 pbcopy
(defun mac-terminal-copy (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

;; 拦截粘贴：从 Mac 的 pbpaste 获取内容给 Emacs
(defun mac-terminal-paste ()
  (shell-command-to-string "pbpaste"))

;; 替换 Emacs 默认的跨程序复制粘贴接管函数
(setq interprogram-cut-function 'mac-terminal-copy)
(setq interprogram-paste-function 'mac-terminal-paste)


;; ==========================================
;; 统一管理备份文件和自动保存文件 (带自动建目录防御)
;; ==========================================
(let ((backup-dir (locate-user-emacs-file "tmp/backups/"))
      (auto-save-dir (locate-user-emacs-file "tmp/auto-saves/"))
      (auto-save-list-dir (locate-user-emacs-file "tmp/auto-save-list/")))
  
  ;; 1. 启动时防御：如果目录不存在，自动执行类似 mkdir -p 的操作
  (unless (file-exists-p backup-dir) (make-directory backup-dir t))
  (unless (file-exists-p auto-save-dir) (make-directory auto-save-dir t))
  (unless (file-exists-p auto-save-list-dir) (make-directory auto-save-list-dir t))
  
  ;; 2. 集中存放备份文件 (例如 init.el~)
  (setq make-backup-files t)
  (setq backup-directory-alist `(("." . ,backup-dir)))
  
  ;; 3. 集中存放自动保存文件 (例如 #init.el#)
  (setq auto-save-default t)
  (setq auto-save-file-name-transforms `((".*" ,auto-save-dir t)))
  
  ;; 4. 集中存放自动保存列表文件
  (setq auto-save-list-file-prefix (concat auto-save-list-dir ".saves-")))


;; 关闭不必要的自动生成列表文件
(setq auto-save-list-file-prefix nil)


;; 安装插件管理工具，定义 bootstrap-version 防止重复下载
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq package-enable-at-startup nil)

;; 安装 use-package 本身
(straight-use-package 'use-package)

;; 核心魔法：让所有的 (use-package ...) 默认使用 straight.el 去接管下载和安装
(setq straight-use-package-by-default t)

;; 智能行首与行尾跳转 (Move Where I Mean)
(use-package mwim
  :bind
  (("C-a" . mwim-beginning-of-code-or-line)
   ("C-e" . mwim-end-of-code-or-line)))

;; ==========================================
;; 开启全局自动热重载 (打通外部 AI 与终端)
;; ==========================================
(use-package autorevert
  :straight nil   ; 声明这是 Emacs 内置模块，不需要去网盘拉取源码
  :hook (after-init . global-auto-revert-mode)
  :custom
  ;; 【核心细节】不仅仅刷新代码文件，也让 Dired 目录树、Magit 状态面板自动刷新
  (global-auto-revert-non-file-buffers t)
  ;; 静默刷新：当 AI 改了代码时，默默在后台更新，不要在底部弹消息烦人
  (auto-revert-verbose nil))

(provide 'init-startup)
