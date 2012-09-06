param($installPath, $toolsPath, $package, $project)

ForEach ($projectItem in $project.ProjectItems) 
{ 
    if ($projectItem.Name -eq "Resources") 
    {
        ForEach ($resourceItem in $projectItem.ProjectItems) 
        {
            if ($resourceItem.Name -eq "WindowsAzureLogo.png")
            {
                $resourceItem.Properties.Item("ItemType").Value = "EmbeddedResource";
            }
            if ($resourceItem.Name -eq "WindowsPhoneLogo.png")
            {
                $resourceItem.Properties.Item("ItemType").Value = "EmbeddedResource";
            }
            if ($resourceItem.Name -eq "AzureBackground.png")
            {
                $resourceItem.Properties.Item("ItemType").Value = "EmbeddedResource";
            }
            if ($resourceItem.Name -eq "DefaultBackground.png")
            {
                $resourceItem.Properties.Item("ItemType").Value = "EmbeddedResource";
            }
        }
    } 
}

$path = [System.IO.Path]
$readmeFile = $path::Combine($path::GetDirectoryName($project.FileName), "App_Readme\WindowsPhone.Notifications.ManagementUI.Sample.Readme.htm")
$DTE.ItemOperations.Navigate($readmeFile, [EnvDTE.vsNavigateOptions]::vsNavigateOptionsNewWindow)