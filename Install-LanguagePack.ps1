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
        [System.String]$LPtoFODFile = "Windows-10-1809-FOD-to-LP-Mapping-Table.csv",

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

        if (-not (Test-Path $LPtoFODFile )) {

            #Check for Excel file
            $excelName = $LPtoFODFile.Replace('.csv','.xlsx')
            if (Test-Path $excelName) {
                Write-Error "Please open $excelName and save as a csv"
                break
            }

            Write-Error "Could not validate that $LPtoFODFile  file exists in this location"
            exit
        }
        $codeMapping = Import-Csv $LPtoFODFile

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
                Add-AppProvisionedPackage -Online -PackagePath $appxPath -LicensePath "$contentPath\License.xml" -ErrorAction Stop -WarningAction SilentlyContinue #ToDo enable logging  -LogPath
            }
            catch {
                $error[0]
                break
            }
            
            $fileList = $codeMapping | Where-Object { $_.'Target Lang' -eq $code }

            #From the Features On Demand iso

            foreach ($file in $fileList.'Cab Name') {
                $filePath = Get-ChildItem (Join-Path $PathToFeaturesOnDemand $file.replace('.cab', '*.cab'))

                if ($null -eq $filePath) {
                    Write-Error "Could not find $filePath"
                    break
                }

                try {
                    Add-WindowsPackage -Online -PackagePath $filePath.FullName -NoRestart -ErrorAction Stop | Out-Null
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