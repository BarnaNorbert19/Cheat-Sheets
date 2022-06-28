# Install oh-my-posh
```powershell
Install-Module oh-my-posh -Scope CurrentUser
```
# Install profile
Open the profile file via an enviromental variable
```powershell
code $profile
```
Choose a theme from [ohmyposh's website](https://ohmyposh.dev/docs/themes "ohmyposh's website") and download the json file
Add the following line (you need to edit it with the choosen theme file) to the profile we opened earlier
```powershell
oh-my-posh.exe init pwsh --config "PROFILE FILE PATH HERE" | Invoke-Expression
```
