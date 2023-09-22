Enable-ADOptionalFeature -Confirm -Identity 'Recycle Bin Feature' -Scope 'ForestOrConfigurationSet' -Target (Get-ADDomain).Forest -Server ((HOSTNAME) + "." + (Get-ADDomain).Forest)

Enable-ADOptionalFeature "Recycle Bin Feature" -server ((Get-ADForest -Current LocalComputer).DomainNamingMaster) -Scope ForestOrConfigurationSet -Target (Get-ADForest -Current LocalComputer) 
