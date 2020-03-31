# Install-LanguagePack

This PowerShell function is designed to automate the installation of any of any* language with the attendant features on demand.  Not all languages have all features available to them, but this function will install all available.  This supports Windows 10 single and multisession.

You will need 3 external resources for this scriopt to run:

The contents of two iso files 
mu_windows_10_version_1903_local_experience_packs_lxps_for_lip_languages_released_oct_2019_x86_arm64_x64_dvd_2f05e51a.iso
en_windows_10_features_on_demand_part_1_version_1903_x64_dvd_1076e85a.iso

The excel file from 'Language and region Features on Demand' documentation **saved as a csv file**.  This is needed as it shows what features are availbel for each language.  I'd prefer an APi or the ability to daownload a CSV, but I guess we work with what we've got.
https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/features-on-demand-language-fod

As long as the structure of the iso files and format of the excel file stay the same, this function will work for future language updates



*currently supported languages: 'ar-sa', 'bg-bg', 'cs-cz', 'da-dk', 'de-de', 'el-gr', 'en-gb', 'en-us', 'es-es', 'es-mx', 'et-ee', 'fi-fi', 'fr-ca', 'fr-fr', 'he-il', 'hr-hr', 'hu-hu', 'it-it', 'ja-jp', 'ko-kr', 'lt-lt', 'lv-lv', 'nb-no', 'nl-nl', 'pl-pl', 'pt-br', 'pt-pt', 'ro-ro', 'ru-ru', 'sk-sk', 'sl-si', 'sr-latn-rs', 'sv-se', 'th-th', 'tr-tr', 'uk-ua', 'zh-cn', 'zh-hk', 'zh-tw'
