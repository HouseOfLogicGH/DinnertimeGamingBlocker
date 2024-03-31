Param(
    [bool]$whatif = $false,
    [int]$warningstartminutes = 5,
    [DateTime]$dinnertime = "17:00:00",
    $users = @( "demouser","demouser2"),
    $processes = @( "Minecraft.Windows", "PartyAnimals", "RobloxPlayer"  ),
    $processpaths = @( "C:\Users\$env:username\AppData\Local\Packages\Microsoft.4297127D64EC6_8wekyb3d8bbwe\LocalCache\Local\runtime\java-runtime-gamma\windows-x64\java-runtime-gamma\bin\javaw.exe" )
    )
function Stop-Game
{
    # find the game process and kill it
   
   $gameprocesses = get-process -ErrorAction SilentlyContinue | Where-Object {($_.Name -in $processes) -or ($_.Path -in $processpaths) }
   
   if( $gameprocesses )
        {
        foreach( $gameprocess in $gameprocesses )
            {

            $gameprocess | Stop-Process -Force
            Show-Notification -ToastText "Your game has been stopped." -ToastTitle "Time to stop!"
            }
        }
}

function Show-Notification {
    [cmdletbinding()]
    Param (
        [string]
        $ToastTitle,
        [string]
        [parameter(ValueFromPipeline)]
        $ToastText
    )

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
    $Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)

    $RawXml = [xml] $Template.GetXml()
    ($RawXml.toast.visual.binding.text|where {$_.id -eq "1"}).AppendChild($RawXml.CreateTextNode($ToastTitle)) > $null
    ($RawXml.toast.visual.binding.text|where {$_.id -eq "2"}).AppendChild($RawXml.CreateTextNode($ToastText)) > $null

    $SerializedXml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $SerializedXml.LoadXml($RawXml.OuterXml)

    $Toast = [Windows.UI.Notifications.ToastNotification]::new($SerializedXml)
    $Toast.Tag = "PowerShell"
    $Toast.Group = "PowerShell"
    $Toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(1)

    $Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Parental Controls")
    $Notifier.Show($Toast);
}
function CheckLoggedInUser
{

    $loggedinuser = $env:username

    if( $users -contains $loggedinuser )
        {
        return $true
        }
    else
        {
        return $false
        }
}

if( CheckLoggedInUser )
    {

    $timeformat = "HH:mm:ss"
    while( $true )
        {
        Start-Sleep -Seconds 60
        
        $timenow = Get-Date -format $timeformat
        $dinnerdatetime = Get-Date -Date $dinnertime -Format $timeformat
        Write-Output "Time is $timenow"

        $warningstart =  Get-Date -date ($dinnertime.AddMinutes( - $warningstartminutes)) -Format $timeformat

        if( ($timenow -gt $warningstart) -and  ($timenow -le $dinnerdatetime) )
            {
            for( $i = 0; $i -lt $warningstartminutes ; $i++ )
                {
                $warncount = $warningstartminutes - $i

                Show-Notification -ToastText "It's nearly Dinnertime. Your game will exit in $warncount minutes." -ToastTitle "Dinnertime soon!"
                Start-Sleep -Seconds 60
                }
            
            }
        else
            {

            if( $timenow -gt $dinnerdatetime )
                {

               
                Stop-Game
                } 
            }
        }
    }
else
    {
    Write-Output "User not in user list"
    exit 
    }