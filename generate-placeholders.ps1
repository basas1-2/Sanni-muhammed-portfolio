# ============================================
# Generates placeholder images + CV for portfolio
# Run:  powershell -ExecutionPolicy Bypass -File generate-placeholders.ps1
# ============================================

Add-Type -AssemblyName System.Drawing

$assetsDir = Join-Path $PSScriptRoot "assets"
if (-not (Test-Path $assetsDir)) {
    New-Item -ItemType Directory -Path $assetsDir | Out-Null
}

function New-PlaceholderImage {
    param(
        [string]$FileName,
        [string]$Title,
        [string]$Subtitle,
        [int]$Width,
        [int]$Height
    )

    $bmp = New-Object System.Drawing.Bitmap($Width, $Height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    # Background gradient
    $rect = New-Object System.Drawing.Rectangle(0, 0, $Width, $Height)
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rect,
        [System.Drawing.Color]::FromArgb(219, 234, 254),
        [System.Drawing.Color]::FromArgb(207, 250, 254),
        45
    )
    $g.FillRectangle($brush, $rect)
    $brush.Dispose()

    # Browser top bar
    $barBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 41, 59))
    $barHeight = [Math]::Max(28, [int]($Height * 0.08))
    $g.FillRectangle($barBrush, 0, 0, $Width, $barHeight)
    $barBrush.Dispose()

    # Traffic light dots
    $dotRadius = [Math]::Max(4, [int]($barHeight * 0.22))
    $dotY = ($barHeight / 2) - $dotRadius
    $dotColors = @(
        [System.Drawing.Color]::FromArgb(255, 95, 87),
        [System.Drawing.Color]::FromArgb(254, 188, 46),
        [System.Drawing.Color]::FromArgb(40, 200, 64)
    )
    for ($i = 0; $i -lt 3; $i++) {
        $dotBrush = New-Object System.Drawing.SolidBrush($dotColors[$i])
        $dotX = ($dotRadius * 2 + 6) * $i + 10
        $g.FillEllipse($dotBrush, $dotX, $dotY, $dotRadius * 2, $dotRadius * 2)
        $dotBrush.Dispose()
    }

    # Title
    $titleFontSize = [Math]::Max(14, [int]($Height * 0.045))
    $titleFont = New-Object System.Drawing.Font("Segoe UI", $titleFontSize, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
    $titleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(71, 85, 105))
    $titleSize = $g.MeasureString($Title, $titleFont)
    $g.DrawString($Title, $titleFont, $titleBrush, ($Width - $titleSize.Width) / 2, ($Height / 2) - ($titleSize.Height / 2))
    $titleBrush.Dispose()
    $titleFont.Dispose()

    # Subtitle
    $subFontSize = [Math]::Max(10, [int]($Height * 0.028))
    $subFont = New-Object System.Drawing.Font("Segoe UI", $subFontSize, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
    $subBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(148, 163, 184))
    $subSize = $g.MeasureString($Subtitle, $subFont)
    $g.DrawString($Subtitle, $subFont, $subBrush, ($Width - $subSize.Width) / 2, ($Height / 2) + $titleSize.Height * 0.6)
    $subBrush.Dispose()
    $subFont.Dispose()

    # Bottom hint text
    $hintFontSize = [Math]::Max(9, [int]($Height * 0.022))
    $hintFont = New-Object System.Drawing.Font("Segoe UI", $hintFontSize, [System.Drawing.FontStyle]::Italic, [System.Drawing.GraphicsUnit]::Pixel)
    $hintBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(148, 163, 184))
    $hintText = "Placeholder - replace with screenshot"
    $hintSize = $g.MeasureString($hintText, $hintFont)
    $g.DrawString($hintText, $hintFont, $hintBrush, ($Width - $hintSize.Width) / 2, $Height - $hintSize.Height - 12)
    $hintBrush.Dispose()
    $hintFont.Dispose()

    $path = Join-Path $assetsDir $FileName
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Created: $path"
}

# --- Project placeholders (desktop 800x500, mobile 300x600) ---
$projects = @(
    @{ Name = "exit-request"; Title = "Exit Request System" },
    @{ Name = "smartprep"; Title = "SmartPrep" },
    @{ Name = "e-learning"; Title = "E-Learning LMS" },
    @{ Name = "tatt"; Title = "TATT Event Planner" }
)

foreach ($p in $projects) {
    New-PlaceholderImage -FileName "$($p.Name)-desktop.png" -Title "DESKTOP VIEW" -Subtitle $p.Title -Width 800 -Height 500
    New-PlaceholderImage -FileName "$($p.Name)-mobile.png" -Title "MOBILE VIEW" -Subtitle $p.Title -Width 300 -Height 600
}

# --- Valid placeholder PDF CV ---
$fonts = "Helvetica"
$content1 = "BT /F1 18 Tf 60 730 Td (SANNI MUHAMMED ARAFAT) Tj ET`n"
$content2 = "BT /F1 12 Tf 60 700 Td (Full-Stack Software Developer) Tj ET`n"
$content3 = "BT /F1 12 Tf 60 670 Td (This is a placeholder CV. Replace with your actual CV file.) Tj ET`n"
$content4 = "BT /F1 12 Tf 60 645 Td (Email: sannimuhammedarafat1@gmail.com) Tj ET`n"
$stream = $content1 + $content2 + $content3 + $content4

$obj1 = "1 0 obj`n<< /Type /Catalog /Pages 2 0 R >>`nendobj`n"
$obj2 = "2 0 obj`n<< /Type /Pages /Kids [3 0 R] /Count 1 >>`nendobj`n"
$obj3 = "3 0 obj`n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Resources << /Font << /F1 5 0 R >> >> /Contents 4 0 R >>`nendobj`n"
$obj4 = "4 0 obj`n<< /Length $($stream.Length) >>`nstream`n$stream`nendstream`nendobj`n"
$obj5 = "5 0 obj`n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>`nendobj`n"

$pdf = "%PDF-1.4`n"
$offsets = @()
foreach ($obj in @($obj1, $obj2, $obj3, $obj4, $obj5)) {
    $offsets += $pdf.Length
    $pdf += $obj
}

$xrefOffset = $pdf.Length
$xref = "xref`n0 6`n0000000000 65535 f `n"
foreach ($offset in $offsets) {
    $xref += ("{0:D10}" -f $offset) + " 00000 n `n"
}
$xref += "trailer`n<< /Size 6 /Root 1 0 R >>`nstartxref`n$xrefOffset`n%%EOF"
$pdf += $xref

$pdfPath = Join-Path $assetsDir "placeholder-cv.pdf"
[System.IO.File]::WriteAllText($pdfPath, $pdf)
Write-Host "Created: $pdfPath"

Write-Host ""
Write-Host "All placeholder assets generated successfully!"

