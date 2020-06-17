#########################################################################
#                        Add shared_assemblies                          #
#########################################################################

[Void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 
[Void][System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll') 
[Void][System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')      
[Void][System.Reflection.Assembly]::LoadFrom('assembly\ControlzEx.dll')     
[Void][System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.Core.dll') 
[Void][System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.dll') 
[Void][System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.Entypo.dll') 
[Void][System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.Unicons.dll') 
[Void][System.Reflection.Assembly]::LoadFrom('assembly\Microsoft.Xaml.Behaviors.dll') 
[Void][System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.PicolIcons.dll') 
[Void][System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.FontAwesome.dll') 
[Void][System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.SimpleChildWindow.dll') 
[Void][System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.Zondicons.dll') 
[Void][System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.RPGAwesome.dll') 


#########################################################################
#                        Load Main Panel                                #
#########################################################################

$Global:pathPanel= split-path -parent $MyInvocation.MyCommand.Definition
#$pathPanel = "C:\Users\Administrator\Documents\ADDS_2"
function LoadXaml ($filename){
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}
$XamlMainWindow=LoadXaml($pathPanel+"\main.xaml")
$reader = (New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form = [Windows.Markup.XamlReader]::Load($reader)

$XamlMainWindow.SelectNodes("//*[@Name]") | %{
    try {Set-Variable -Name "$("WPF_"+$_.Name)" -Value $Form.FindName($_.Name) -ErrorAction Stop}
    catch{throw}
    }

Function Get-FormVariables{
if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
get-variable *WPF*
}
#Get-FormVariables


$WPF_test.Add_Click({

    $WPF_Child.IsOpen = $true
    $WPF_Child.IsModal = $true
    $WPF_Child.AutoCloseInterval = 3000
    $WPF_Child.AllowMove = $true
})
$WPF_First_Child.Add_Click({

    $WPF_SCDE1.IsOpen = $True

})

$WPF_Second_Child.Add_Click({

    $WPF_SCDE2.IsOpen = $True

})
$WPF_Third_Child.Add_Click({

    if ($WPF_Override.IsChecked -eq $True){

        $WPF_SCDE3.IsOpen = $True
        $WPF_SCDE3.OverlayBrush.Opacity = $WPF_Opacity.Value
        $WPF_SCDE3.OverlayBrush.Color = $WPF_Colors.SelectionBoxItem
        $WPF_Override.IsChecked = $false


    }
    else{

    $WPF_SCDE3.IsOpen = $True
    $WPF_SCDE3.OverlayBrush.Opacity = "0.2"
    $WPF_SCDE3.OverlayBrush.Color = "Gray"
    $WPF_Override.IsChecked = $false
    }
    $WPF_Override.IsChecked = $false

})

$WPF_XClose.Add_Click({

    $WPF_SCDE3.IsOpen = $false

})
$WPF_XClose2.Add_Click({

    $WPF_SCDE2.IsOpen = $false

})

$WPF_Theme.Add_Click({
   $Theme1 = [ControlzEx.Theming.ThemeManager]::Current.DetectTheme($form)
    $my_theme = ($Theme1.BaseColorScheme)
	If($my_theme -eq "Light")
		{
            [ControlzEx.Theming.ThemeManager]::Current.ChangeThemeBaseColor($form,"Dark")
            $WPF_Theme.ToolTip = "Theme Dark"

		}
	ElseIf($my_theme -eq "Dark")
		{					
            [ControlzEx.Theming.ThemeManager]::Current.ChangeThemeBaseColor($form,"Light")
            $WPF_Theme.ToolTip = "Theme Light"

		}		
})

$WPF_BaseColor.Add_Click({

    $Script:Colors=@()
    $Accent = [ControlzEx.Theming.ThemeManager]::Current.ColorSchemes
    foreach ($item in $Accent)
    {
        $Script:Colors += $item
    }

    $Value = $Script:Colors[$(Get-Random -Minimum 0 -Maximum 23)]
    [ControlzEx.Theming.ThemeManager]::Current.ChangeThemeColorScheme($form ,$Value)
    $WPF_BaseColor.ToolTip = "BaseColor : $Value"

})
$Form.ShowDialog() | Out-Null

