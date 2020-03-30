function Install-LanguagePack {
    [CmdletBinding()]

    Param (
        [Parameter(
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [ValidateSet('ar-sa', 'bg-bg', 'cs-cz', 'da-dk', 'de-de', 'el-gr', 'en-gb', 'en-us', 'es-es', 'es-mx', 'et-ee', 'fi-fi', 'fr-ca', 'fr-fr', 'he-il', 'hr-hr', 'hu-hu', 'it-it', 'ja-jp', 'ko-kr', 'lt-lt', 'lv-lv', 'nb-no', 'nl-nl', 'pl-pl', 'pt-br', 'pt-pt', 'ro-ro', 'ru-ru', 'sk-sk', 'sl-si', 'sr-latn-rs', 'sv-se', 'th-th', 'tr-tr', 'uk-ua', 'zh-cn', 'zh-hk', 'zh-tw')]
        [System.String[]]$LanguageCode,

        [Parameter(
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [System.String]$PathToLocalExperience,

        [Parameter(
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [System.String]$PathToFeaturesOnDemand,

        [Parameter(
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true
        )]
        [System.String]$LogPath
    )

    BEGIN {
        
        Set-StrictMode -Version Latest

        #Requires -RunAsAdministrator

        ##Disable Language Pack Cleanup## (do not re-enable)
        Disable-ScheduledTask -TaskPath "\Microsoft\Windows\AppxDeploymentClient\" -TaskName "Pre-staged app cleanup"

    } # Begin
    PROCESS {
        #Code mapping from https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/features-on-demand-language-fod
        $codeMapping = 

        foreach ($code in $LanguageCode) {
            $contentPath = Join-Path $Path $LanguageCode
            #From the local experience iso
            $appxPath = "$contentPath\LanguageExperiencePack.$LanguageCode.Neutral.appx"
            if (-not (Test-Path $appxPath)) {
                Write-Error "Could not validate that $appxPath file exists in this location"
                break
            }
            if (-not (Test-Path "$contentPath\License.xml")) {
                Write-Error "Could not validate that $contentPath\License.xml file exists in this location"
                break
            }
            try {
                Add-AppProvisionedPackage -Online -PackagePath $appxPath -LicensePath $contentPath\License.xml -ErrorAction Stop #ToDo enable logging  -LogPath
            }
            catch {
                $error[0]
                break
            }
            
            #From the Features On Demand iso
            try {
                Add-WindowsPackage -Online -PackagePath $Path\Microsoft-Windows-LanguageFeatures-Basic-$LanguageCode-Package~31bf3856ad364e35~amd64~~.cab -ErrorAction Stop
                Add-WindowsPackage -Online -PackagePath $Path\Microsoft-Windows-LanguageFeatures-Fonts-Jpan-Package~31bf3856ad364e35~amd64~~.cab -ErrorAction Stop
                Add-WindowsPackage -Online -PackagePath $Path\Microsoft-Windows-LanguageFeatures-Handwriting-$LanguageCode-Package~31bf3856ad364e35~amd64~~.cab -ErrorAction Stop
                Add-WindowsPackage -Online -PackagePath $Path\Microsoft-Windows-LanguageFeatures-OCR-$LanguageCode-Package~31bf3856ad364e35~amd64~~.cab -ErrorAction Stop
                Add-WindowsPackage -Online -PackagePath $Path\Microsoft-Windows-LanguageFeatures-Speech-$LanguageCode-Package~31bf3856ad364e35~amd64~~.cab -ErrorAction Stop
                Add-WindowsPackage -Online -PackagePath $Path\Microsoft-Windows-LanguageFeatures-TextToSpeech-$LanguageCode-Package~31bf3856ad364e35~amd64~~.cab -ErrorAction Stop
                Add-WindowsPackage -Online -PackagePath $Path\Microsoft-Windows-NetFx3-OnDemand-Package~31bf3856ad364e35~amd64~$LanguageCode~.cab -ErrorAction Stop
                $LanguageList = Get-WinUserLanguageList -ErrorAction Stop
                $LanguageList.Add("$LanguageCode") 
                Set-WinUserLanguageList $LanguageList -force -ErrorAction Stop
            }
            catch {
                $error[0]
                break
            }
            Write-Verbose "Installed $LanguageCode"
        }
    } #Process
    END {
        
    } #End
}  #function Install-Language