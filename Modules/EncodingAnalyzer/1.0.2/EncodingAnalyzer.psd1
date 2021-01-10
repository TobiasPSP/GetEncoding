
@{
RootModule = 'loader.psm1'
ModuleVersion = '1.0.2'
GUID = 'bbd0483d-57b3-45ce-a4e4-744ab1cfb8c8'
Author = 'Dr. Tobias Weltner'
CompanyName = 'https://powershell.one'
Copyright = '(c) 2021 Dr. Tobias Weltner. All rights reserved.'
Description = 'determines the encoding of any text file'
CompatiblePSEditions = @('Desktop', 'Core')
PowerShellVersion = '5.1'
PowerShellHostName = ''
PowerShellHostVersion = ''
DotNetFrameworkVersion = ''
CLRVersion = ''
ProcessorArchitecture = ''
FunctionsToExport = 'Get-PsOneEncoding'
AliasesToExport = 'Get-Encoding'
PrivateData = @{
        PSData = @{
            Tags       = @(
                'Encoding'
                'file'
                'text'
                'Unicode'
                'Ansi'
                'Ascii'
                'UTF8'
                'UTF7'
                'powershell.one'
                'Windows'
                'MacOS'
                'Linux'
            )
            ProjectUri = 'https://github.com/TobiasPSP/GetEncoding'
        } # End of PSData hashtable
    } # End of PrivateData hashtable
}