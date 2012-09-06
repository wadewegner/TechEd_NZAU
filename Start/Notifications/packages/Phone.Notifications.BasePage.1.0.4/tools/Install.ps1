param($installPath, $toolsPath, $package, $project)

ForEach ($projectItem in $project.ProjectItems) 
{ 
    if ($projectItem.Name -eq "Content") 
    {
        ForEach ($resourceItem in $projectItem.ProjectItems) 
        {
            if ($resourceItem.Name -eq "appbar.delete.rest.png")
            {
                $resourceItem.Properties.Item("ItemType").Value = "Content";
            }
        }
    } 
}

$path = [System.IO.Path]
$readmeFile = $path::Combine($path::GetDirectoryName($project.FileName), "App_Readme\Phone.Notifications.BasePage.Readme.htm")
$DTE.ItemOperations.Navigate($readmeFile, [EnvDTE.vsNavigateOptions]::vsNavigateOptionsNewWindow)
