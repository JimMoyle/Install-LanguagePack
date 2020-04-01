$here = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Install-LanguagePack" {

    Context "Input" {

        Mock -CommandName 'Disable-ScheduledTask' -MockWith {$null}
        Mock -CommandName 'Test-Path' -MockWith {$true}
        Mock -CommandName 'Add-AppProvisionedPackage' -MockWith {$null}
        Mock -CommandName 'Import-Csv' -MockWith {[PSCustomObject]@{
            'Target Lang' = 'made-up'
        }}

        It "Takes input by parameter" {
            $out = Install-LanguagePack -LanguageCode 'en-gb' -PathToLocalExperience 'D:\' -PathToFeaturesOnDemand 'E:\' -LPtoFODFile '\\server\share3\mycsv.csv'
            $out | Should -BeNull
        }

        It "Takes input by pipeline" {
            $out = 'en-gb' | Install-LanguagePack -PathToLocalExperience 'E:\' -PathToFeaturesOnDemand 'D:\' -LPtoFODFile '\\server\share3\mycsv.csv'
            $out | Should -BeNull
        }

        It "Takes input by named pipeline" {

            $pipe = [PSCustomObject]@{
                LanguageCode = 'en-gb'
                PathToLocalExperience = 'E:\'
                PathToFeaturesOnDemand = 'D:\'
                LPtoFODFile = '\\server\share3\mycsv.csv'
            }
            $out = $pipe | Install-LanguagePack
            $out | Should -BeNull
        }


    }

    Context "Logic" {
        It "ItName" {
            #Assertion
        }
    }

    Context "Output" {
        It "ItName" {
            #Assertion
        }
    }


}
