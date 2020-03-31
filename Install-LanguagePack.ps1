function Install-LanguagePack {
  
    <#
    .SYNOPSIS
    Function to install language(s) with all approriate featurs on demand.

    .DESCRIPTION
    This PowerShell function is designed to automate the installation of any of any* language with the attendant features on demand.  Not all languages have all features available to them, but this function will install all available.  This supports Windows 10 single and multisession.

    You will need 3 external resources for this script to run:

    The contents of two iso files 
    mu_windows_10_version_1903_local_experience_packs_lxps_for_lip_languages_released_oct_2019_x86_arm64_x64_dvd_2f05e51a.iso
    en_windows_10_features_on_demand_part_1_version_1903_x64_dvd_1076e85a.iso

    The excel file from 'Language and region Features on Demand' documentation **saved as a csv file**.  This is needed as it shows what features are available for each language.  I'd prefer an API or the ability to daownload a CSV, but I guess we work with what we've got so you've got to download the xlsx file and save it as a csv.
    https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/features-on-demand-language-fod

    As long as the structure of the iso files and format of the excel file stay the same, this function will work for future language updates.

    *currently supported languages: 'af-za', 'am-et', 'ar-sa', 'as-in', 'az-latn-az', 'be-by', 'bg-bg', 'bn-bd', 'bn-in', 'bs-latn-ba', 'ca-es', 'ca-es-valencia', 'chr-cher-us', 'cs-cz', 'cy-gb', 'da-dk', 'de-de', 'el-gr', 'en-gb', 'en-us', 'es-es', 'es-mx', 'et-ee', 'eu-es', 'fa-ir', 'fi-fi', 'fil-ph', 'fr-ca', 'fr-fr', 'ga-ie', 'gd-gb', 'gl-es', 'gu-in', 'ha-latn-ng', 'he-il', 'hi-in', 'hr-hr', 'hu-hu', 'hy-am', 'id-id', 'ig-ng', 'is-is', 'it-it', 'ja-jp', 'ka-ge', 'kk-kz', 'km-kh', 'kn-in', 'kok-in', 'ko-kr', 'ku-arab-iq', 'ky-kg', 'lb-lu', 'lo-la', 'lt-lt', 'lv-lv', 'mi-nz', 'mk-mk', 'ml-in', 'mn-mn', 'mr-in', 'ms-my', 'mt-mt', 'nb-no', 'ne-np', 'nl-nl', 'nn-no', 'nso-za', 'or-in', 'pa-arab-pk', 'pa-in', 'pl-pl', 'prs-af', 'pt-br', 'pt-pt', 'quc-latn-gt', 'quz-pe', 'ro-ro', 'ru-ru', 'rw-rw', 'sd-arab-pk', 'si-lk', 'sk-sk', 'sl-si', 'sq-al', 'sr-cyrl-ba', 'sr-cyrl-rs', 'sr-latn-rs', 'sv-se', 'sw-ke', 'ta-in', 'te-in', 'tg-cyrl-tj', 'th-th', 'ti-et', 'tk-tm', 'tn-za', 'tr-tr', 'tt-ru', 'ug-cn', 'uk-ua', 'ur-pk', 'uz-latn-uz', 'vi-vn', 'wo-sn', 'xh-za', 'yo-ng', 'zh-cn', 'zh-tw', 'zu-za'

    .PARAMETER LanguageCode
    This is the language code for your language the full list of available codes is in the description.  The parameter will only allow valid codes

    .PARAMETER PathToLocalExperience
    This is the path to the root of the mu_windows_10_version_1903_local_experience_packs_lxps_for_lip_languages iso, for instance D:\ if the iso is mounted.  Any SMB location should work

    .PARAMETER PathToFeaturesOnDemand
    This is the path to the root of the en_windows_10_features_on_demand_part_1 iso, for instance E:\ if the iso is mounted.  Any SMB location should work

    .PARAMETER LPtoFODFile
    This is the path to the csv version of the excel file from 'Language and region Features on Demand' documentation.  You can find it here: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/features-on-demand-language-fod.
    The default value for this parameter is Windows-10-1809-FOD-to-LP-Mapping-Table.csv

    .PARAMETER LogPath
    Not yet implemented

    .EXAMPLE
    Install-LanguagePack -LanguageCode en-gb -PathToLocalExperience E:\ -PathToFeaturesOnDemand D:\

    .EXAMPLE 
    Install-LanguagePack -LanguageCode 'fi-fi', 'fil-ph', 'fr-ca' -PathToLocalExperience \\server\share -PathToFeaturesOnDemand \\server\share2

    .LINK
    https://github.com/JimMoyle/Install-LanguagePack

    #>

    [CmdletBinding()]

    Param (
        [Parameter(
            ValuefromPipelineByPropertyName = $true,
            ValuefromPipeline = $true,
            Mandatory = $true
        )]
        [ValidateSet('af-za', 'am-et', 'ar-sa', 'as-in', 'az-latn-az', 'be-by', 'bg-bg', 'bn-bd', 'bn-in', 'bs-latn-ba', 'ca-es', 'ca-es-valencia', 'chr-cher-us', 'cs-cz', 'cy-gb', 'da-dk', 'de-de', 'el-gr', 'en-gb', 'en-us', 'es-es', 'es-mx', 'et-ee', 'eu-es', 'fa-ir', 'fi-fi', 'fil-ph', 'fr-ca', 'fr-fr', 'ga-ie', 'gd-gb', 'gl-es', 'gu-in', 'ha-latn-ng', 'he-il', 'hi-in', 'hr-hr', 'hu-hu', 'hy-am', 'id-id', 'ig-ng', 'is-is', 'it-it', 'ja-jp', 'ka-ge', 'kk-kz', 'km-kh', 'kn-in', 'kok-in', 'ko-kr', 'ku-arab-iq', 'ky-kg', 'lb-lu', 'lo-la', 'lt-lt', 'lv-lv', 'mi-nz', 'mk-mk', 'ml-in', 'mn-mn', 'mr-in', 'ms-my', 'mt-mt', 'nb-no', 'ne-np', 'nl-nl', 'nn-no', 'nso-za', 'or-in', 'pa-arab-pk', 'pa-in', 'pl-pl', 'prs-af', 'pt-br', 'pt-pt', 'quc-latn-gt', 'quz-pe', 'ro-ro', 'ru-ru', 'rw-rw', 'sd-arab-pk', 'si-lk', 'sk-sk', 'sl-si', 'sq-al', 'sr-cyrl-ba', 'sr-cyrl-rs', 'sr-latn-rs', 'sv-se', 'sw-ke', 'ta-in', 'te-in', 'tg-cyrl-tj', 'th-th', 'ti-et', 'tk-tm', 'tn-za', 'tr-tr', 'tt-ru', 'ug-cn', 'uk-ua', 'ur-pk', 'uz-latn-uz', 'vi-vn', 'wo-sn', 'xh-za', 'yo-ng', 'zh-cn', 'zh-tw', 'zu-za')]
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

        #Code mapping from https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/features-on-demand-language-fod
        #Check for code mapping file
        if (-not (Test-Path $LPtoFODFile )) {

            #Check for Excel file
            $excelName = $LPtoFODFile.Replace('.csv', '*.xlsx')
            if (Test-Path $excelName) {
                Write-Error "Please open $excelName and save as a csv"
                exit
            }

            Write-Error "Could not validate that $LPtoFODFile  file exists in this location"
            exit
        }
        $codeMapping = Import-Csv $LPtoFODFile

    } # Begin
    PROCESS {

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
                Add-AppProvisionedPackage -Online -PackagePath $appxPath -LicensePath "$contentPath\License.xml" -ErrorAction Stop -WarningAction SilentlyContinue | Out-Null #ToDo enable logging  -LogPath 
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
                    Add-WindowsPackage -Online -PackagePath $filePath.FullName -NoRestart -ErrorAction Stop -WarningAction SilentlyContinue | Out-Null
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