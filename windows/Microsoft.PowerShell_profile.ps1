Invoke-Expression (&starship init powershell) *>&1
Import-Module -Name Terminal-Icons
Import-Module $HOME\.config\winwal.psm1
Import-Module $HOME\.config\screenshot.ps1

Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

function pywal_to_starship {
	Update-WalTerminal *>&1;
	bash ~/winwaltostarship.sh;
	bash ~/waltostarship.sh;
}

function update_pywal_to_starship{
	Update-WalTheme *>&1;
	bash ~/winwaltostarship.sh;
	bash ~/waltostarship.sh;
}

function screenshot_to_pywal_to_starship{
	Get-Wallpaper;
	pywal_to_starship;
}


Set-Alias -Name Pywal-Starship -Value pywal_to_starship
Set-Alias -Name Wallpaper-Starship -Value update_pywal_to_starship
Set-Alias -Name Screenshot-Starship -Value screenshot_to_pywal_to_starship


