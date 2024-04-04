# Dinnertime Gaming Blocker

A simple script to stop gaming processes on Windows after certain times, intended to get children off the computer before dinner.
A warning is given via toast notification.

## Usage
Copy the script to the gaming machine in question.
Set up the scheduled task to run the PowerShell script in the background, and to start at login of the specified user.

## Customisation

The script will need some customisation in the parameters.
Change '$warningstartminutes' to how much notice you want to give the user.
Set '$dinnertime' to when you want the blocker to start taking action.
Set '$users' to include the usernames of all those users to include in the blocker - this may allow you to exclude some users from the blocker.
Set '$processes' to the process names of the games you want to block by name.
Set '$processpaths' to the paths of games you want to block - this is useful if the game process name is not unique, eg Minecraft Java runs as javaw.exe but from a specific path. The variable supports the use of the $env:username parameter so can be applied for multiple users.
