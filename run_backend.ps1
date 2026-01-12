# 进入项目根目录
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $scriptPath

$ErrorActionPreference = "Stop"

function Print-Color {
    param([string]$Message, [ConsoleColor]$Color = "Green")
    Write-Host ">> $Message" -ForegroundColor $Color
}

# 检查 uv 是否安装
if (-not (Get-Command "uv" -ErrorAction SilentlyContinue)) {
    Print-Color "Error: 未检测到 'uv' 命令。请先安装: pip install uv" "Red"
    exit 1
}

# 1. 检查并安装依赖
if (-not (Test-Path ".venv")) {
    Print-Color "正在创建虚拟环境..."
    uv venv
}

# 生效虚拟环境
. .venv/Scripts/Activate.ps1

# 4. 启动服务器
Print-Color "正在启动开发服务器 http://127.0.0.1:8000 ..." "Cyan"
uv run python manage.py runserver 0.0.0.0:8000
