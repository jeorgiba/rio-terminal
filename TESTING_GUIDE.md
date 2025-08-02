# Rio Terminal Testing Guide

## 🙏 Credits

**Rio Terminal** - A hardware-accelerated GPU terminal emulator  
**Original Author**: Raphael Amorim <rapha850@gmail.com>  
**Original Repository**: https://github.com/raphamorim/rio  
**License**: MIT  
**Documentation**: https://rioterm.com

*This testing guide is created for the amazing Rio terminal project.*

## 0. Getting Started (First Time Use)

### If you see the "Quit Rio?" dialog:
- **Press Escape** to continue using Rio
- **Press Enter** to quit Rio

### First Commands to Try:
```powershell
# Basic directory listing
Get-ChildItem

# Check your current location
Get-Location

# Test colors and emojis
Write-Host "🚀 Welcome to Rio Terminal!" -ForegroundColor Green
```

## Quick Start Commands

### Essential Test Commands:
```powershell
# 1. Welcome message
echo "Hello Rio Terminal!"

# 2. Colorful output
Write-Host "🔴 Red Test" -ForegroundColor Red
Write-Host "🟢 Green Test" -ForegroundColor Green  
Write-Host "🔵 Blue Test" -ForegroundColor Blue

# 3. Performance test
1..20 | ForEach-Object { "Rio line $_ - smooth rendering test" }

# 4. Unicode and emoji test
echo "Rio supports: 🚀 ⚡ 💻 🎯 ✅ 🔥 🌟 📱 🖥️ ⌨️"

# 5. System info
Get-ComputerInfo | Select-Object WindowsProductName, TotalPhysicalMemory

# 6. Process monitoring
Get-Process rio -ErrorAction SilentlyContinue

# 7. File operations
Get-ChildItem | Where-Object { $_.Extension -eq ".md" }

# 8. Directory navigation
Set-Location .\docs; Get-ChildItem; Set-Location ..
```

## 1. Functional Testing (Manual)

### Basic Terminal Functions
1. **Text Input/Output**: Type commands and verify output
2. **Color Support**: Run `Get-ChildItem` (colorized output)
3. **Unicode Support**: Type emojis and special characters
4. **Scrolling**: Generate long output with `Get-Process`

### Advanced Features Testing
```powershell
# Test terminal resizing
Get-Process | Format-Table -AutoSize

# Test long outputs
1..100 | ForEach-Object { "Line $_" }

# Test colors
Write-Host "Red Text" -ForegroundColor Red
Write-Host "Green Text" -ForegroundColor Green
```

### Development Commands:
```powershell
# Rust/Cargo commands
cargo --version
rustc --version
rustup show

# Git operations  
git status
git log --oneline -10
git branch

# File exploration
Get-ChildItem -Recurse -Name "*.rs" | Select-Object -First 10
Get-ChildItem -Recurse -Name "*.toml"

# Project structure
tree /F /A | Select-Object -First 20

# Search in files
Select-String -Path "*.md" -Pattern "Rio" | Select-Object -First 5
```

### Performance Testing Commands:
```powershell
# Rapid output test
for ($i=1; $i -le 50; $i++) { 
    Write-Host "Performance test line $i - $(Get-Date)" -ForegroundColor (Get-Random -InputObject @("Red","Green","Blue","Yellow","Cyan","Magenta"))
}

# Memory usage monitoring
while ($true) { 
    Get-Process rio -ErrorAction SilentlyContinue | Format-Table ProcessName, WorkingSet, CPU -AutoSize
    Start-Sleep 2
    if ((Read-Host "Continue? (y/n)") -eq "n") { break }
}

# Large file operations
Get-ChildItem C:\Windows\System32 | Sort-Object Length -Descending | Select-Object -First 20

# Network testing
Test-NetConnection google.com -Port 80
```

## 2. Performance Testing

### Memory Usage
- Open Task Manager
- Monitor Rio's memory consumption
- Run: `Get-Process rio`

### Rendering Performance
```powershell
# Generate rapid output
for ($i=1; $i -le 1000; $i++) { 
    Write-Host "Performance test line $i" 
}
```

### Fun Commands to Try:
```powershell
# ASCII Art Banner
Write-Host @"
██████╗ ██╗ ██████╗     ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗     
██╔══██╗██║██╔═══██╗    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║     
██████╔╝██║██║   ██║       ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║     
██╔══██╗██║██║   ██║       ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║     
██║  ██║██║╚██████╔╝       ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗
╚═╝  ╚═╝╚═╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝
"@ -ForegroundColor Cyan

# Rainbow text
$colors = @("Red","Yellow","Green","Cyan","Blue","Magenta")
$text = "Rio Terminal - GPU Accelerated Performance!"
for ($i = 0; $i -lt $text.Length; $i++) {
    Write-Host $text[$i] -ForegroundColor $colors[$i % $colors.Length] -NoNewline
}
Write-Host ""

# System information display
Write-Host "`n🖥️  System Information:" -ForegroundColor Yellow
Write-Host "OS: $(Get-CimInstance Win32_OperatingSystem | Select-Object -ExpandProperty Caption)"
Write-Host "CPU: $(Get-CimInstance Win32_Processor | Select-Object -ExpandProperty Name)"
Write-Host "RAM: $([math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB, 2)) GB"
Write-Host "Rio Process Count: $(Get-Process rio -ErrorAction SilentlyContinue | Measure-Object | Select-Object -ExpandProperty Count)"

# File type analysis
Write-Host "`n📁 Project File Analysis:" -ForegroundColor Green
$files = Get-ChildItem -Recurse -File
$groups = $files | Group-Object Extension | Sort-Object Count -Descending | Select-Object -First 10
$groups | ForEach-Object { Write-Host "$($_.Name): $($_.Count) files" -ForegroundColor Cyan }

# Network connectivity test
Write-Host "`n🌐 Network Test:" -ForegroundColor Magenta
@("google.com", "github.com", "rioterm.com") | ForEach-Object {
    $result = Test-NetConnection $_ -Port 80 -InformationLevel Quiet
    $status = if ($result) { "✅ Online" } else { "❌ Offline" }
    Write-Host "$_`: $status"
}
```

### Practical Daily Commands:
```powershell
# Quick project overview
Get-ChildItem | Measure-Object | Select-Object Count
Get-ChildItem -Recurse -File | Measure-Object Length -Sum | ForEach-Object { "Total Size: $([math]::Round($_.Sum/1MB, 2)) MB" }

# Git workflow
git status --short
git log --oneline -5
git branch --list

# Development environment check
$env:PATH -split ";" | Where-Object { $_ -like "*rust*" -or $_ -like "*cargo*" }
Get-Command cargo, rustc, git -ErrorAction SilentlyContinue | Format-Table Name, Version

# Quick file search
Get-ChildItem -Recurse -Name | Where-Object { $_ -like "*test*" } | Select-Object -First 10
Get-ChildItem -Recurse -Name "*.rs" | Select-Object -First 5

# Disk usage by directory
Get-ChildItem | Where-Object { $_.PSIsContainer } | ForEach-Object { 
    $size = (Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
    [PSCustomObject]@{
        Folder = $_.Name
        SizeMB = [math]::Round($size/1MB, 2)
    }
} | Sort-Object SizeMB -Descending
```

## 3. Configuration Testing

### Create Test Config
Create `%USERPROFILE%\AppData\Roaming\rio\config.toml`:

```toml
# Test configuration
cursor = "▇"
blinking-cursor = true

[colors]
background = "#0F0908"
foreground = "#F2F2F2"

[fonts]
family = "JetBrains Mono"
size = 14
```

### Keyboard Shortcuts Testing
- Ctrl+C (copy)
- Ctrl+V (paste) 
- Ctrl+Shift+T (new tab, if supported)

## 4. Integration Testing

### Shell Integration
```powershell
# Test different shells
cmd
pwsh
powershell
```

### File Operations
```powershell
# Test file operations
Get-Content .\README.md
notepad test.txt
```

## 5. Error Testing

### Invalid Commands
```powershell
# Test error handling
nonexistentcommand
```

### Resource Limits
```powershell
# Test with large outputs
Get-ChildItem C:\ -Recurse -ErrorAction SilentlyContinue
```

## 6. Visual Testing

### Graphics and Rendering
- Check font rendering clarity
- Verify smooth scrolling
- Test window resizing
- Check for visual artifacts

### Accessibility
- Test with high contrast themes
- Verify text scaling
- Check color contrast

## Expected Behaviors

✅ **Should Work:**
- Fast text rendering
- Smooth scrolling
- Proper color display
- Responsive resizing
- Unicode/emoji support

❌ **Known Issues to Report:**
- Any crashes
- Performance degradation
- Rendering glitches
- Configuration not loading

## Reporting Issues

If you find bugs:
1. Note Rio version: `rio --version`
2. System info: `Get-ComputerInfo`
3. Steps to reproduce
4. Expected vs actual behavior
