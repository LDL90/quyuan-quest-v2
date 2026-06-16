# 屈原端午探秘 - GitHub部署脚本
# 使用方法：在PowerShell中运行此脚本

$repoName = "quyuan-quest-v2"
$token = Read-Host "请输入你的GitHub Token (ghp_...)" -AsSecureString
$plainToken = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($token))

Write-Host "正在部署到 GitHub..." -ForegroundColor Cyan

# 读取文件内容
$content = Get-Content -Raw -Path "index.html"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($content)
$base64 = [Convert]::ToBase64String($bytes)

# 创建/更新文件
$body = @{
    message = "Update: Qu Yuan Quest v2"
    content = $base64
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "https://api.github.com/repos/ldl90/$repoName/contents/index.html" -Method Put -Headers @{
        Authorization = "token $plainToken"
        Accept = "application/vnd.github+json"
    } -Body $body
    
    Write-Host "✅ 部署成功！" -ForegroundColor Green
    Write-Host ""
    Write-Host "访问地址：" -ForegroundColor Yellow
    Write-Host "  https://ldl90.github.io/quyuan-quest-v2/" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "GitHub文件：" -ForegroundColor Yellow
    Write-Host "  $($response.content.html_url)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ 部署失败: $_" -ForegroundColor Red
}

# 清理敏感信息
$plainToken = $null
