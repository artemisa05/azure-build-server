properties {
    $config = $null
    $windowsAdminPassword = $null
}

$script:assertedProperties = $false

task default -depends Configure-Azure-Virtual-Machine

TaskSetup  {

    Assert-Properties
}

Task Configure-Azure-Virtual-Machine {

    if ((Find-Azure-Virtual-Machine) -eq $null)
    {
        Invoke-Task -taskName Create-Azure-Virtual-Machine
    }

    Install-Boxstarter-Package
}

Task Create-Azure-Virtual-Machine -depends Create-Azure-Service, Create-Azure-Storage-Account {

    if (Find-Azure-Virtual-Machine -ne $null)
    {
        return
    }

    Set-Current-Storage-Account

    Write-Host "Creating Azure Virtual Machine '$($config.azure.virtualMachine.name)'..."
    Write-Host

    New-AzureVMConfig -Name $config.azure.virtualMachine.name -InstanceSize $config.azure.virtualMachine.instanceSize -ImageName $config.azure.virtualMachine.imageName |
        Add-AzureProvisioningConfig –Windows -AdminUsername $config.azure.virtualMachine.adminUsername –Password $windowsAdminPassword |
        New-AzureVM -ServiceName $config.azure.service.name -AffinityGroup $config.azure.affinityGroup.name -WaitForBoot

    Write-Host
    Write-Host "Successfully created Azure Virtual Machine." -ForegroundColor Green
}

Task Create-Azure-Storage-Account -depends Create-Azure-Affinity-Group {

    if (Find-Azure-Storage-Account -ne $null)
    {
        return
    }

    Write-Host "Creating Azure Storage Account '$($config.azure.storageAccount.name)'..."
    Write-Host

    New-AzureStorageAccount -StorageAccountName $config.azure.storageAccount.name -AffinityGroup $config.azure.affinityGroup.name

    Write-Host
    Write-Host "Successfully created Azure Storage Account." -ForegroundColor Green
}

Task Create-Azure-Service -depends Create-Azure-Affinity-Group {

    if (Find-Azure-Service -ne $null)
    {
        return
    }

    Write-Host "Creating Azure Service '$($config.azure.service.name)'..."
    Write-Host

    New-AzureService -ServiceName $config.azure.service.name -AffinityGroup $config.azure.affinityGroup.name

    Write-Host
    Write-Host "Successfully created Azure Service." -ForegroundColor Green
}

Task Create-Azure-Affinity-Group {

    if (Find-Azure-Affinity-Group -ne $null)
    {
        return
    }

    Write-Host "Creating Azure Affinity Group '$($config.azure.affinityGroup.name)'..."
    Write-Host

    New-AzureAffinityGroup -Name $config.azure.affinityGroup.name -Location $config.azure.affinityGroup.location

    Write-Host "Successfully created Azure Affinity Group." -ForegroundColor Green
}

Task Show-Azure-Virtual-Machine-Images {

    Write-Host "Searching for Azure Virtual Machine Image Names..."

    $vms = Invoke-AzureCommand { Get-AzureVMImage -ErrorAction Continue }
    $imageFamily = "Windows Server 2012 R2 Datacenter"
    $serverVMs = $vms | 
        Where-Object { $_.PublisherName -eq "Microsoft Windows Server Group" -and $_.ImageFamily -eq $imageFamily } |
        Sort-Object { $_.PublishedDate } -Descending

    Write-Host "Azure Virtual Machines where ImageFamily is '$imageFamily'."
    Write-Host "---------------------------------------------------------------------------"
    $serverVMs

    Write-Host
    Write-Host "Image names for Azure Virtual Machines where ImageFamily is '$imageFamily'."
    Write-Host "---------------------------------------------------------------------------"
    $serverVMs | ForEach-Object { $_.ImageName }
}

FormatTaskName {
    param($taskName)
    Format-TaskName $taskName
}

Function Assert-Properties()
{
    if ($script:assertedProperties)
    {
        return
    }

    Format-TaskName "Assert-Properties"

    Assert-NotNullOrWhitespace $windowsAdminPassword "properties.`$windowsAdminPassword"

    Assert-NotNull $config "properties.`$config"

    Assert-NotNull $config.azure "properties.`$config.azure"

    Assert-NotNull $config.azure.affinityGroup "properties.`$config.azure.affinityGroup"
    Assert-NotNullOrWhiteSpace $config.azure.affinityGroup.name "properties.`$config.azure.affinityGroup.name"
    Assert-NotNullOrWhiteSpace $config.azure.affinityGroup.location "properties.`$config.azure.affinityGroup.location"

    Assert-NotNull $config.azure.service "properties.`$config.azure.service"
    Assert-NotNullOrWhiteSpace $config.azure.service.name "properties.`$config.azure.service.name"

    Assert-NotNull $config.azure.storageAccount "properties.`$config.azure.storageAccount"
    Assert-NotNullOrWhiteSpace $config.azure.storageAccount.name "properties.`$config.azure.storageAccount.name"

    Assert-NotNull $config.azure.virtualMachine "properties.`$config.azure.virtualMachine"
    Assert-NotNullOrWhiteSpace $config.azure.virtualMachine.name "properties.`$config.azure.virtualMachine.name"
    Assert-NotNullOrWhiteSpace $config.azure.virtualMachine.adminUsername "properties.`$config.azure.virtualMachine.adminUsername"
    Assert-NotNullOrWhiteSpace $config.azure.virtualMachine.imageName "properties.`$config.azure.virtualMachine.imageName"
    Assert-NotNullOrWhiteSpace $config.azure.virtualMachine.instanceSize "properties.`$config.azure.virtualMachine.instanceSize"

    Assert-NotNull $config.boxstarter "properties.`$config.boxstarter"
    Assert-NotNullOrWhiteSpace $config.boxstarter.packageUrl "properties.`$config.boxstarter.packageUrl"

    Assert-NotNull $config.psake "properties.`$config.psake"
    Assert-NotNullOrWhiteSpace $config.psake.version "properties.`$config.psake.version"

    $script:assertedProperties = $true
}

Function Find-Azure-Affinity-Group()
{
    if ($script:affinityGroup -ne $null)
    {
        return $script:affinityGroup
    }

    Write-Host "Searching for Azure Affinity Group '$($config.azure.affinityGroup.name)'..."
    $script:affinityGroup = Invoke-AzureCommand { Get-AzureAffinityGroup -Name $config.azure.affinityGroup.name -ErrorAction Continue }

    if ($script:affinityGroup -ne $null)
    {
        Write-Host "Found Azure Affinity Group." -ForegroundColor Green
    }
    else
    {
        Write-Host "Cannot find Azure Affinity Group." -ForegroundColor Magenta
    }
    
    return $script:affinityGroup
}

Function Find-Azure-Service()
{
    if ($script:service -ne $null)
    {
        return $script:service
    }

    Write-Host "Searching for Azure Service '$($config.azure.service.name)'..."
    $script:service = Invoke-AzureCommand { Get-AzureService -ServiceName $config.azure.service.name -ErrorAction Continue }

    if ($script:service -ne $null)
    {
        Write-Host "Found Azure Service." -ForegroundColor Green
    }
    else
    {
        Write-Host "Cannot find Azure Service." -ForegroundColor Magenta
    }

    return $script:service
}

Function Find-Azure-Storage-Account()
{
    if ($script:storageAccount -ne $null)
    {
        return $script:storageAccount
    }

    Write-Host "Searching for Azure Storage Account '$($config.azure.storageAccount.name)'..."
    $script:storageAccount = Invoke-AzureCommand { Get-AzureStorageAccount -StorageAccountName $config.azure.storageAccount.name -ErrorAction Continue }

    if ($script:storageAccount -ne $null)
    {
        Write-Host "Found Azure Storage Account." -ForegroundColor Green
    }
    else
    {
        Write-Host "Cannot find Azure Storage Account." -ForegroundColor Magenta
    }
    
    return $script:storageAccount
}

Function Find-Azure-Virtual-Machine()
{
    if ($script:virtualMachine -ne $null)
    {
        return $script:virtualMachine
    }

    Write-Host "Searching for Azure Virtual Machine '$($config.azure.virtualMachine.name)'..."
    $script:virtualMachine = Invoke-AzureCommand { Get-AzureVM -ServiceName $config.azure.service.name -Name $config.azure.virtualMachine.name -ErrorAction Continue -WarningAction SilentlyContinue }

    if ($script:virtualMachine -ne $null)
    {
        Write-Host "Found Azure Virtual Machine." -ForegroundColor Green
    }
    else
    {
        Write-Host "Cannot find Azure Virtual Machine." -ForegroundColor Magenta
    }

    return $script:virtualMachine
}

Function Format-TaskName($taskName)
{
    Write-Host
    Write-Host $taskName.Replace("-", " ").Replace("If It Cannot Be Found", "if it cannot be found") -ForegroundColor Yellow
    Write-Host "----------------------------------------------------------------------" -ForegroundColor Yellow
}

Function Get-Windows-Admin-Credentials()
{
    $securePassword = ConvertTo-SecureString -String $windowsAdminPassword -AsPlainText -Force
    $credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $config.azure.virtualMachine.adminUsername, $securePassword

    return $credentials
}

Function Install-Boxstarter-Package()
{
    $credentials = Get-Windows-Admin-Credentials
    $cloudServiceName = $config.azure.service.name

    $config.azure.virtualMachine.name |
        Enable-BoxstarterVM -provider Azure -CloudServiceName $cloudServiceName -Credential $credentials | 
        Install-BoxstarterPackage -PackageName $config.boxstarter.packageUrl
}

Function Set-Current-Storage-Account()
{
    Write-Host "Setting current storage account to '$($config.azure.storageAccount.name)'..."

    $currentAzureSubscription = Get-AzureSubscription | Where-Object { $_.IsCurrent }

    Set-AzureSubscription -SubscriptionName $currentAzureSubscription.SubscriptionName -CurrentStorageAccountName $config.azure.storageAccount.name
}