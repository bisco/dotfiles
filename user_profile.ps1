Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key Ctrl+p -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key Ctrl+n -Function HistorySearchForward


# $PROFILEに追加

function Get-BranchColor {
    $output = git status --porcelain=v1 --untracked-files=normal 2>$null

    if (-not $?) {
        return "Gray"
    }

    if ([string]::IsNullOrEmpty($output)) {
        return "Green"     # Clean
    }
    elseif ($output -match '(^|\n)\?\? ') {
        return "Yellow"    # Untracked
    }
    elseif ($output -match 'M|A|D|R|C') {
        return "Red"       # Modified/Staged
    }
    else {
        return "Cyan"      # その他
    }
}

function Get-BranchHash {
    git rev-parse --short HEAD 2>$null
}


function prompt {
    $cwd = (Get-Location).Path

    $prefix = "PS "
    if ($env:SSH_CONNECTION) {
        $prefix = "$env:USERNAME@$env:COMPUTERNAME "
    }

    Write-Host "${prefix}${cwd}" -ForegroundColor Cyan -NoNewline

    $branch = git branch --show-current 2>$null
    if ($LASTEXITCODE -eq 0 -and $branch) {

        $hash = Get-BranchHash
        $color = Get-BranchColor

        Write-Host " (" -ForegroundColor DarkGray -NoNewline
        Write-Host "$branch@$hash" -ForegroundColor $color -NoNewline
        Write-Host ")" -ForegroundColor DarkGray -NoNewline
    }

    Write-Host ""
    Write-Host ">" -ForegroundColor Cyan -NoNewline
    return " "
}
