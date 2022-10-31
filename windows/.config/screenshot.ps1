[cmdletbinding()]
param(
  [string]$Width,
  [string]$Height,
  [String]$FileName = "Screenshot"
 
)
 
 
function Take-Screenshot{
[cmdletbinding()]
param(
 [Drawing.Rectangle]$bounds, 
 [string]$path
) 
   $bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height
   $graphics = [Drawing.Graphics]::FromImage($bmp)
   $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)
   $bmp.Save($path)
   $graphics.Dispose()
   $bmp.Dispose()
}
 
#Function to get the primary monitor resolution.
 
function Get-ScreenResolution {
 $Screens = [system.windows.forms.screen]::AllScreens
 foreach ($Screen in $Screens) {
  $DeviceName = $Screen.DeviceName
  $Width  = $Screen.Bounds.Width
  $Height  = $Screen.Bounds.Height
  $IsPrimary = $Screen.Primary
  $OutputObj = New-Object -TypeName PSobject
  $OutputObj | Add-Member -MemberType NoteProperty -Name DeviceName -Value $DeviceName
  $OutputObj | Add-Member -MemberType NoteProperty -Name Width -Value $Width
  $OutputObj | Add-Member -MemberType NoteProperty -Name Height -Value $Height
  $OutputObj | Add-Member -MemberType NoteProperty -Name IsPrimaryMonitor -Value $IsPrimary
  $OutputObj
 }
}
$Filepath = join-path $HOME\wallpaper_engine "wallpaper"
 
[void] [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [Reflection.Assembly]::LoadWithPartialName("System.Drawing")
 
if(!($width -and $height)) {
 
 $screen = Get-ScreenResolution | ? {$_.IsPrimaryMonitor -eq $true}
 $Width = $screen.Width
 $Height = $screen.height
}
 
$bounds = [Drawing.Rectangle]::FromLTRB(0, 0, $Screen.Width, $Screen.Height)
 
$shell = New-Object -ComObject "Shell.Application"

function Show-Process($Process, [Switch]$Maximize){
  $sig = '
    [DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")] public static extern int SetForegroundWindow(IntPtr hwnd);
  '
  if ($Maximize) { $Mode = 3 } else { $Mode = 4 }
  $type = Add-Type -MemberDefinition $sig -Name WindowAPI -PassThru
  $hwnd = $process.MainWindowHandle
  $null = $type::ShowWindowAsync($hwnd, $Mode)
  $null = $type::SetForegroundWindow($hwnd)
}

function Get-Wallpaper {
  $shell.minimizeall() 
  Get-ChildItem -Path $HOME\wallpaper_engine -Include *.* -File -Recurse | ForEach-Object { $_.Delete()}
  Start-Sleep -Seconds 0.8
  Take-Screenshot -Bounds $bounds -Path "$Filepath.png"
  $shell.undominimizeall()
  wal -e -q -i $HOME\wallpaper_engine\wallpaper.png 
}