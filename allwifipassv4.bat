@echo off
setlocal enabledelayedexpansion

echo Retrieving all WiFi profiles...

:: Get all WiFi profiles
for /F "tokens=2 delims=:" %%a in ('netsh wlan show profile ^| findstr /C:"All User Profile"') do (
    set "wifi_name=%%a"
    set "wifi_name=!wifi_name:~1!"
    echo Found profile: '!wifi_name!'

    :: Debugging: Show profile details command
    echo Running: netsh wlan show profile name="!wifi_name!" key=clear

    :: Get the full details of the profile
    netsh wlan show profile name="!wifi_name!" key=clear > profile_details.txt

    :: Debugging: Display the full profile details
    type profile_details.txt

    :: Get the password for each profile
    set "wifi_pwd="
    for /F "tokens=2* delims=:" %%b in ('type profile_details.txt ^| findstr /C:"Key Content"') do (
        set "wifi_pwd=%%b"
        set "wifi_pwd=!wifi_pwd:~1!"
        setlocal enabledelayedexpansion
        for /F "tokens=* delims= " %%c in ("!wifi_pwd!") do (
            endlocal
            set "wifi_pwd=%%c"
        )
    )
    if defined wifi_pwd (
        echo Password for '!wifi_name!': '!wifi_pwd!'
    ) else (
        echo No password found for '!wifi_name!' or an error occurred.
    )
)

:: Check if any profiles were found
if "%wifi_name%"=="" (
    echo No profiles found or an error occurred.
)

endlocal
pause






