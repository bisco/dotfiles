Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key Ctrl+p -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key Ctrl+n -Function HistorySearchForward


# $PROFILEに追加

function prompt {
    $cwd = (Get-Location).Path

    # gitブランチ取得（branch-status-checkに相当）
    $branch = ""
    if (Test-Path ".git") {
        $b = git branch --show-current 2>$null
        $status = git status --porcelain 2>$null
        $dirty = if ($status) { "*" } else { "" }
        $branch = " ($b$dirty)"
    }

    # SSH接続判定（REMOTEHOST/SSH_CONNECTIONに相当）
    $prefix = ""
    if ($env:SSH_CONNECTION) {
        $prefix = "$env:USERNAME@$env:COMPUTERNAME "
    }

    # 色付きプロンプト
    Write-Host "${prefix}${cwd}${branch}" -ForegroundColor Cyan -NoNewline
    Write-Host ""  # 改行
    Write-Host ">" -ForegroundColor Cyan -NoNewline
    return " "  # promptの戻り値が末尾につく
}
