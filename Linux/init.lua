-- 这是一个用lua写的neovim配置文件
-- 你可以用--来注释一行

-- 设置一些全局变量
local o = vim.o -- 全局选项
local wo = vim.wo -- 窗口选项
local bo = vim.bo -- 缓冲区选项

-- 设置一些基本的选项
o.encoding = "utf-8" -- 设置编码为utf-8
o.termguicolors = true -- 开启24位颜色支持
o.number = true -- 显示行号
o.relativenumber = true -- 显示相对行号
o.wrap = false -- 不自动换行
o.tabstop = 4 -- 制表符占4个空格
o.shiftwidth = 4 -- 缩进占4个空格
o.expandtab = true -- 用空格代替制表符
o.smartindent = true -- 智能缩进
o.ignorecase = true -- 忽略大小写
o.smartcase = true -- 在有大写字母时区分大小写
o.incsearch = true -- 增量搜索
o.hlsearch = true -- 高亮搜索结果

-- 定义一个函数来加载插件
local function load_plugins()
  local packer = require("packer")
  packer.startup(function(use)
    use "wbthomason/packer.nvim" -- 插件管理器
    use "neovim/nvim-lspconfig" -- LSP配置
    use "hrsh7th/nvim-cmp" -- 自动补全插件
    use "nvim-treesitter/nvim-treesitter" -- 语法高亮插件
    use "hoob3rt/lualine.nvim" -- 状态栏插件
    use "kyazdani42/nvim-tree.lua" -- 文件树插件
    use "kyazdani42/nvim-web-devicons" -- 图标插件
    use "norcalli/nvim-colorizer.lua" -- 颜色显示插件
    use "folke/tokyonight.nvim" -- 主题插件
  end)
end

-- 调用加载插件的函数
load_plugins()

-- 设置主题为tokyonight，并启用italic样式
vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_functions = true
vim.cmd("colorscheme tokyonight")

-- 设置状态栏为lualine，并使用tokyonight主题和图标
require("lualine").setup({
  options = {
    theme = "tokyonight",
    icons_enabled = true,
  },
})

-- 设置文件树为nvim-tree，并绑定快捷键<leader>e来打开或关闭它
require("nvim-tree").setup({})
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", {noremap = true})

-- 设置语法高亮为treesitter，并启用所有支持的语言和功能
require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  highlight = {
    enable = true,
  },
})

-- 设置颜色显示为colorizer，并启用所有支持的文件类型和模式
require("colorizer").setup({"*"}, {
  RGB = true,
  RRGGBB = true,
  RRGGBBAA = true,
  rgb_fn = true,
  hsl_fn = true,
  css = true,
  css_fn = true,
})

-- 设置LSP为lspconfig，并配置一些常用的语言服务器，比如lua和python
local lspconfig = require("lspconfig")
local servers = {"pyright",