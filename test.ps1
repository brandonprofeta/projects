param(
    [Parameter(Mandatory)]
    [string]$PdfPath,

    [int]$PageCount = 88,

    [string]$OutputFolder = ".\PdfPages"
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

New-Item -ItemType Directory -Force -Path $OutputFolder | Out-Null

$PdfPath = (Resolve-Path $PdfPath).Path

Write-Host "PDF Path: [$PdfPath]"
Start-Process -FilePath "msedge.exe" -ArgumentList @("""$PdfPath""")

Start-Sleep -Seconds 5

for ($page = 1; $page -le $PageCount; $page++) {

    Write-Host "Capturing page $page"

    $bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds

    $bitmap = New-Object System.Drawing.Bitmap `
        $bounds.Width, `
        $bounds.Height

    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)

    $graphics.CopyFromScreen(
        $bounds.Location,
        [System.Drawing.Point]::Empty,
        $bounds.Size
    )

    $file = "C:\Users\brandon.profeta\Desktop\PdfPages\page_{0:D3}.png" -f $page

   Write-Host "OutputFolder: [$OutputFolder]"
   Write-Host "File: [$file]"
   Write-Host "File Type: $($file.GetType().FullName)"
   $testFile = "$env:USERPROFILE\Desktop\test_capture.png"
Write-Host "Saving to: $testFile"

$bitmap.Save($file)

    $graphics.Dispose()
    $bitmap.Dispose()

    [System.Windows.Forms.SendKeys]::SendWait("{PGDN}")

    Start-Sleep -Milliseconds 1000
}