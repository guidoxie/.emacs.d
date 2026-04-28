# My Emacs Configuration

一个现代化的 Emacs 配置，专注于 Go 和 Python 开发，针对 macOS 和终端使用进行了优化。

## 特性

- **LSP 开发体验** — 基于 Eglot，支持 Go (gopls) 和 Python (pyright)
- **现代补全系统** — Corfu + Vertico + Orderless，支持终端
- **智能搜索导航** — Consult 提供增强的搜索、跳转和缓冲区切换
- **macOS 集成** — 原生剪贴板支持 (pbcopy/pbpaste)
- **保存时自动格式化** — Go 和 Python 文件保存时自动格式化和整理 imports
- **环境管理** — envrc 支持 Python 虚拟环境自动切换

## 结构

```
~/.emacs.d/
├── init.el              # 入口文件
└── lisp/
    ├── init-startup.el  # 启动设置、包管理、备份策略
    ├── init-ui.el       # 主题和界面配置
    ├── init-tools.el    # 补全和搜索工具
    └── init-lsp.el      # LSP 和语言配置
```

## 包管理

使用 [straight.el](https://github.com/raxod502/straight.el) 管理包，配合 `use-package` 组织配置。首次启动会自动安装所有依赖。

## 主要快捷键

| 快捷键 | 功能 |
|--------|------|
| `C-s` | 增强搜索 (consult-line) |
| `C-x b` | 缓冲区切换 (consult-buffer) |
| `M-y` | 粘贴历史 (consult-yank-pop) |
| `M-s g` | Ripgrep 搜索 |
| `M-s f` | 文件搜索 (consult-find) |
| `M-g g` | 跳转行号 |
| `M-g i` | Imenu 导航 |
| `C-a` / `C-e` | 智能行首/行尾跳转 |

## 终端设置

使用 Ghostty 终端时，需要开启 Option 键作为 Meta 键：

编辑 Ghostty 配置文件（通常在 `~/.config/ghostty/config`），添加：

```
macos-option-as-alt = left
```

这样 `M-x`、`M-f` 等 Meta 组合键才能正常工作。

## 依赖安装

### Go LSP

```bash
go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest
```

### Python LSP

```bash
brew install pyright ruff direnv
```

### Python 项目虚拟环境（示例）

使用 [uv](https://github.com/astral-sh/uv) 管理项目依赖，配合 direnv 自动激活虚拟环境：

```bash
# 1. 初始化项目（uv 会秒建项目结构并生成 pyproject.toml）
uv init my_api_service
cd my_api_service

# 2. 添加业务依赖（uv 会极速解析依赖，并在当前目录自动生成一个隐式的 .venv）
uv add fastapi uvicorn redis

# 3. 让 direnv 接管这个 .venv
echo "source .venv/bin/activate" > .envrc
direnv allow
```

进入项目目录后，direnv 会自动激活虚拟环境，Eglot 的 pyright 会使用对应环境的包。

### 其他

- [ripgrep](https://github.com/BurntSushi/ripgrep) — 全文搜索
- [direnv](https://direnv.net/) — 环境变量管理

## 使用

```bash
git clone https://github.com/guidoxie/.emacs.d.git ~/.emacs.d
emacs  # 首次启动会自动安装所有包
```
