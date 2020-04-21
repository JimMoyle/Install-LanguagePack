# Install-LanguagePack

This PowerShell function is designed to automate the installation of any of any* language with the attendant features on demand.  Not all languages have all features available to them, but this function will install all available.  This supports Windows 10 single and multisession.

You will need 3 external resources for this script to run:

The contents of two iso files 

  mu_windows_10_version_1903_local_experience_packs_lxps_for_lip_languages_released_oct_2019_x86_arm64_x64_dvd_2f05e51a.iso
  en_windows_10_features_on_demand_part_1_version_1903_x64_dvd_1076e85a.iso

The excel file from 'Language and region Features on Demand' documentation **saved as a csv file**.  

This is needed as it shows what features are available for each language.  I'd prefer an API or the ability to download a CSV, but I guess we work with what we've got so you've got to download the xlsx file and save it as a csv.  The current file is included 31-Mar-2020
https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/features-on-demand-language-fod

As long as the structure of the iso files and format of the excel file stay the same, this function will work for future language updates.

Thanks to Claus Emrich for the original script I adapted



*currently supported languages: 'af-za', 'am-et', 'ar-sa', 'as-in', 'az-latn-az', 'be-by', 'bg-bg', 'bn-bd', 'bn-in', 'bs-latn-ba', 'ca-es', 'ca-es-valencia', 'chr-cher-us', 'cs-cz', 'cy-gb', 'da-dk', 'de-de', 'el-gr', 'en-gb', 'en-us', 'es-es', 'es-mx', 'et-ee', 'eu-es', 'fa-ir', 'fi-fi', 'fil-ph', 'fr-ca', 'fr-fr', 'ga-ie', 'gd-gb', 'gl-es', 'gu-in', 'ha-latn-ng', 'he-il', 'hi-in', 'hr-hr', 'hu-hu', 'hy-am', 'id-id', 'ig-ng', 'is-is', 'it-it', 'ja-jp', 'ka-ge', 'kk-kz', 'km-kh', 'kn-in', 'kok-in', 'ko-kr', 'ku-arab-iq', 'ky-kg', 'lb-lu', 'lo-la', 'lt-lt', 'lv-lv', 'mi-nz', 'mk-mk', 'ml-in', 'mn-mn', 'mr-in', 'ms-my', 'mt-mt', 'nb-no', 'ne-np', 'nl-nl', 'nn-no', 'nso-za', 'or-in', 'pa-arab-pk', 'pa-in', 'pl-pl', 'prs-af', 'pt-br', 'pt-pt', 'quc-latn-gt', 'quz-pe', 'ro-ro', 'ru-ru', 'rw-rw', 'sd-arab-pk', 'si-lk', 'sk-sk', 'sl-si', 'sq-al', 'sr-cyrl-ba', 'sr-cyrl-rs', 'sr-latn-rs', 'sv-se', 'sw-ke', 'ta-in', 'te-in', 'tg-cyrl-tj', 'th-th', 'ti-et', 'tk-tm', 'tn-za', 'tr-tr', 'tt-ru', 'ug-cn', 'uk-ua', 'ur-pk', 'uz-latn-uz', 'vi-vn', 'wo-sn', 'xh-za', 'yo-ng', 'zh-cn', 'zh-tw', 'zu-za'
