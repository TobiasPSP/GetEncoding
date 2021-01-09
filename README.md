# GetEncoding
Home of the universal text file encoding checker `Get-PsOneEncoding`

## Install
Download from PowerShell Gallery:

```powershell
Install-Module -Name EncodingAnalyzer -Scope CurrentUser
```

## Use
The module ships one cmdlet: `Get-PsOneEncoding`. It also defines the alias `Get-Encoding`.

### Determine current encoding of a single file

```powershell
Get-Encoding -Path c:\somefile.txt
```

### Determine encoding of many files

```powershell
Get-ChildItem -Path $home -Filter *.txt | Get-Encoding
```

The result looks similar to this:

```
  BOM Encoding Confidence Path
  --- -------- ---------- ----
False ASCII           100 C:\Users\tobia\.dotnet\tools\.store\powershell\6.2.4\powershell\6.2.4\tools\netcoreapp2.1\...
False UTF-8           100 C:\Users\tobia\.dotnet\tools\.store\powershell\6.2.4\powershell\6.2.4\tools\netcoreapp2.1\...
 True UTF-8           100 C:\Users\tobia\.dotnet\tools\.store\powershell\6.2.4\powershell\6.2.4\tools\netcoreapp2.1\...
False UTF-8           100 C:\Users\tobia\.dotnet\tools\.store\powershell\6.2.4\powershell\6.2.4\tools\netcoreapp2.1\...
False UTF-8           100 C:\Users\tobia\.dotnet\tools\.store\powershell\6.2.4\powershell\6.2.4\tools\netcoreapp2.1\...
False UTF-8           100 C:\Users\tobia\.dotnet\tools\.store\powershell\6.2.4\powershell\6.2.4\tools\netcoreapp2.1\...
False UTF-8           100 C:\Users\tobia\.dotnet\tools\.store\powershell\6.2.4\powershell\6.2.4\tools\netcoreapp2.1\...
False UTF-8           100 C:\Users\tobia\.dotnet\tools\.store\powershell\6.2.4\powershell\6.2.4\tools\netcoreapp2.1\...
 True UTF-8           100 C:\Users\tobia\.dotnet\tools\.store\powershell\6.2.4\powershell\6.2.4\tools\netcoreapp2.1\...
False UTF-8           100 C:\Users\tobia\.dotnet\tools\.store\powershell\6.2.4\powershell\6.2.4\tools\netcoreapp2.1\...
(...)
```

## Notes

Determining the encoding of text files can be very useful for diagnostic purposes and may also be important to identify the correct encoding when reading files.

There are many different encoding schemes, and they primarily differ by the number of bits and how they represent special characters. So reading a file with a wrong encoding typically results in damaged special characters, or the file content may not display correctly at all.

### BOM

There are two different types of encoding. **BOM** (*byte order mask*) encoding uses bytes at the beginning of a text file to specify the encoding. **BOM** encoding therefore allows for fast and reliable identification of encoding, and `Get-Encoding` always returns a confidence level of 100% for such files.

**BOM** encoding however may be incompatible with certain use cases. For example, github and many non-Windows systems do not expect **BOM**-encoded text files.

When text files are encoded *without* **BOM**, the encoding must be determined by heuristics. Typically, this is reliable, too, and can be determined by looking only at a fraction of the file. However, when the file is small and when there are no special characters in the file, encoding may be ambiguous. The confidence level returned for non-**BOM** files may therefore vary.

### License

This module uses a port of the *original Mozilla Universal Charset Detector* published here: https://github.com/errepi/ude

My work (the *PowerShell* part) is under MIT license so you can do pretty much whatever you like with it. However the heuristic analysis is performed by said DLL which is governed by more restrictive licensing terms (see there).

## Questions

Please use the discussions panel here: https://github.com/TobiasPSP/GetEncoding/discussions

I am looking forward to your questions and ideas. I am sure there's still a lot that can be done to improve and refine.
