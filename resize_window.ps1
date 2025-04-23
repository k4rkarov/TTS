Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Win32 {
    [DllImport("user32.dll")]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);
    
    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);
    
    [DllImport("user32.dll")]
    public static extern int GetWindowText(IntPtr hWnd, System.Text.StringBuilder text, int count);
    
    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hWnd);
    
    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT rect);
    
    [DllImport("user32.dll")]
    public static extern bool MoveWindow(IntPtr hWnd, int x, int y, int nWidth, int nHeight, bool bRepaint);

    public struct RECT {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }
}
"@

$windows = @{}
$null = [Win32]::EnumWindows({ 
    param($hWnd, $lParam)
    if ([Win32]::IsWindowVisible($hWnd)) {
        $buffer = New-Object System.Text.StringBuilder 1024
        [Win32]::GetWindowText($hWnd, $buffer, $buffer.Capacity) | Out-Null
        $title = $buffer.ToString()
        if ($title -ne "") {
            $windows[$title] = $hWnd
        }
    }
    return $true
}, [IntPtr]::Zero)

if ($windows.Count -eq 0) {
    Write-Host "No visible windows found."
    exit
}

Write-Host "`nVisible windows:"
$windowTitles = $windows.Keys | Sort-Object
for ($i = 0; $i -lt $windowTitles.Count; $i++) {
    Write-Host "[$i] $($windowTitles[$i])"
}

$choice = Read-Host "`nEnter the number of the window you want to resize to 800x600"
if ($choice -notmatch '^\d+$' -or [int]$choice -ge $windowTitles.Count) {
    Write-Host "Invalid choice."
    exit
}

$selectedTitle = $windowTitles[$choice]
$hWnd = $windows[$selectedTitle]

# Get current position to keep the window in place (only change size)
[Win32+RECT]$rect = New-Object Win32+RECT
[Win32]::GetWindowRect($hWnd, [ref]$rect) | Out-Null

$x = $rect.Left
$y = $rect.Top

# Resize window
[Win32]::MoveWindow($hWnd, $x, $y, 816, 670, $true) | Out-Null

Write-Host "`nWindow '$selectedTitle' was successfully resized to 800x600!"

