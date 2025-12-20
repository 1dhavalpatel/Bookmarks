# Simple HTTP Server using PowerShell and .NET
param([int]$Port = 8081)

Write-Host "Starting HTTP Server on port $Port..." -ForegroundColor Green
Write-Host "Navigate to: http://localhost:$Port/DP_PromptLibrary.html" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()

# Open browser automatically
Start-Process "http://localhost:$Port/DP_PromptLibrary.html"

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $localPath = $request.Url.LocalPath.TrimStart('/')
        if ($localPath -eq '') { $localPath = 'DP_PromptLibrary.html' }
        
        $filePath = Join-Path $PWD $localPath
        
        if (Test-Path $filePath) {
            $content = Get-Content $filePath -Raw -Encoding UTF8
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
            
            # Set content type based on file extension
            $extension = [System.IO.Path]::GetExtension($filePath)
            switch ($extension) {
                '.html' { $response.ContentType = 'text/html; charset=utf-8' }
                '.json' { $response.ContentType = 'application/json; charset=utf-8' }
                '.css'  { $response.ContentType = 'text/css; charset=utf-8' }
                '.js'   { $response.ContentType = 'application/javascript; charset=utf-8' }
                default { $response.ContentType = 'text/plain; charset=utf-8' }
            }
            
            $response.ContentLength64 = $buffer.Length
            $response.StatusCode = 200
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
        } else {
            $response.StatusCode = 404
            $errorMessage = "File not found: $localPath"
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($errorMessage)
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
        }
        
        $response.OutputStream.Close()
    }
} finally {
    $listener.Stop()
    Write-Host "Server stopped." -ForegroundColor Red
}