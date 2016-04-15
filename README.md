# Getting Started

* Install ChefDK
* Clone or download the repository

### Windows
* Edit the .kitchen.windows.yml to point the parent.vhd to a vhd of a Windows Server 2012 R2 image that you have.
* Edit the .kitchen.windows.yml to replace the password with the proper one for your image.
* From PowerShell, change directories into the cloned or downloaded copy of this repository
* run
```powershell
chef shell-init powershell | invoke-expression
gem install kitchen-dsc
gem install kitchen-pester
$env:KITCHEN_LOCAL_YAML='.kitchen.windows.yml'
kitchen test
```
### Mac
* 
* From Terminal, change directories into the cloned or downloaded copy of this repository
* run
```
eval (chef shell-init bash)
gem install kitchen-dsc
gem install kitchen-pester
$env:KITCHEN_LOCAL_YAML='.kitchen.mac.yml'
kitchen test
```
