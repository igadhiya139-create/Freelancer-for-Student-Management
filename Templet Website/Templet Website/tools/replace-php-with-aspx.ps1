# Run from repository root (PowerShell)
$backup = ".\replace-backup"
New-Item -ItemType Directory -Force -Path $backup | Out-Null

Get-ChildItem -Recurse -Include *.html,*.master,*.aspx | ForEach-Object {
  $text = Get-Content -Raw $_.FullName
  $new = $text -replace 'forms/contact\.php','forms/Contact.aspx' -replace 'forms/newsletter\.php','forms/Newsletter.aspx'
  if ($new -ne $text) {
    Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $backup $_.FullName.Replace((Get-Location).Path,'').TrimStart('\')) -Force
    Set-Content -LiteralPath $_.FullName -Value $new -Force
    Write-Host "Updated:" $_.FullName
  }
}