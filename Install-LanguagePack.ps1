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
        Disable-ScheduledTask -TaskPath "\Microsoft\Windows\AppxDeploymentClient\" -TaskName "Pre-staged app cleanup" | Out-Null

    } # Begin
    PROCESS {
        #Code mapping from https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/features-on-demand-language-fod
        $codeMapping = Import-Csv "Windows-10-1809-FOD-to-LP-Mapping-Table.csv"

        foreach ($code in $LanguageCode) {
            $contentPath = Join-Path $PathToLocalExperience (Join-Path 'LocalExperiencePack' $code)
            #From the local experience iso
            $appxPath = "$contentPath\LanguageExperiencePack.$code.Neutral.appx"
            if (-not (Test-Path $appxPath)) {
                Write-Error "Could not validate that $appxPath file exists in this location"
                break
            }
            if (-not (Test-Path "$contentPath\License.xml")) {
                Write-Error "Could not validate that $contentPath\License.xml file exists in this location"
                break
            }
            try {
                Add-AppProvisionedPackage -Online -PackagePath $appxPath -LicensePath "$contentPath\License.xml" -ErrorAction Stop #ToDo enable logging  -LogPath
            }
            catch {
                $error[0]
                break
            }
            
            #From the Features On Demand iso
            $fileList = @(
                "$PathToFeaturesOnDemand\Microsoft-Windows-LanguageFeatures-Basic-$code-Package~31bf3856ad364e35~amd64~~.cab",
                "$PathToFeaturesOnDemand\Microsoft-Windows-LanguageFeatures-Handwriting-$code-Package~31bf3856ad364e35~amd64~~.cab",
                "$PathToFeaturesOnDemand\Microsoft-Windows-LanguageFeatures-OCR-$code-Package~31bf3856ad364e35~amd64~~.cab",
                "$PathToFeaturesOnDemand\Microsoft-Windows-LanguageFeatures-Speech-$code-Package~31bf3856ad364e35~amd64~~.cab",
                "$PathToFeaturesOnDemand\Microsoft-Windows-LanguageFeatures-TextToSpeech-$code-Package~31bf3856ad364e35~amd64~~.cab",
                "$PathToFeaturesOnDemand\Microsoft-Windows-NetFx3-OnDemand-Package~31bf3856ad364e35~amd64~$code~.cab"
            )

            if ($fontcheck) {
                #Add font file to list
                ## $PathToFeaturesOnDemand\Microsoft-Windows-LanguageFeatures-Fonts-Jpan-Package~31bf3856ad364e35~amd64~~.cab
            }

            foreach ($file in $fileList) {
                if (-not (Test-Path $file)) {
                    Write-Error "Could not validate that $file file exists in this location"
                    break
                }
                try {
                    Add-WindowsPackage -Online -PackagePath $file -ErrorAction Stop
                }
                catch {
                    $error[0]
                    break
                }
            }

            try {
                $LanguageList = Get-WinUserLanguageList -ErrorAction Stop
                $LanguageList.Add("$code") 
                Set-WinUserLanguageList $LanguageList -force -ErrorAction Stop
            }
            catch {
                $error[0]
                break
            }
            Write-Verbose "Installed $code"
        }
    } #Process
    END {
        
    } #End
}  #function Install-LanguagePack