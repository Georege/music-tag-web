# 进入项目根目录
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $scriptPath

$ErrorActionPreference = "Stop"

function Print-Color {
    param([string]$Message, [ConsoleColor]$Color = "Green")
    Write-Host ">> $Message" -ForegroundColor $Color
}

# 进入根目录下的web目录下

cd web

# 安装依赖
npm install

# 开发模式
npm run dev

# 生产构建
npm run build