# this dummy class is used to determine whether
# a file has a bom encoding:
class NullEncoder : System.Text.UTF8Encoding
{
}

function Get-PsOneEncoding
{
  <#
      .SYNOPSIS
      Gets Encoding for BOM and Non-BOM text files.

      .DESCRIPTION
      Returns the encoding of text files. 
      For BOM-encoded files, the fast .NET methods are used, and confidence level is always 100%.
      For Non-BOM-encoded files, extensive heuristicts are applied, and confidence level varies depending on file content.
      Heuristics are calculated by a porting of the Mozilla Universal Charset Detector (https://github.com/errepi/ude)
      Important: this library is subject to the Mozilla Public License Version 1.1, alternatively licensed
      either under terms of GNU General Public License Version 2 or later, or GNU Lesser General Public License Version 2.1 or later.

      .PARAMETER Path
      Path to text file

      .PARAMETER BomOnly
      Returns information for BOM-encoded files only.

      .EXAMPLE
      Get-PsOneEncoding -Path c:\sometextfile.txt
      Returns the encoding of the text file specified

      .EXAMPLE
      Get-ChildItem -Path $home -Filter *.txt -Recurse | Get-PsOneEncoding
      Returns the encoding of any text file found anywhere in the current user profile.

      .NOTES
      Make sure you respect the license terms of the ported charset detector DLL.

      .LINK
      https://github.com/TobiasPSP/GetEncoding
      https://github.com/errepi/ude
      https://techblog.dorogin.com/changing-source-files-encoding-and-some-fun-with-powershell-df23bf8410ab
  #>


  param
  (
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName,Mandatory)]
    [Alias('FullName')]
    [string]
    $Path,
    
    [switch]
    $BomOnly
  )    
  begin
  {
    # load charset detector dll:
    Add-Type -Path $PSScriptRoot\Ude.dll
    $cdet = [Ude.CharsetDetector]::new()
    $nullEncoder = [NullEncoder]::new()
  }
  process 
  {
    # try and read the BOM encoding:
    # submit a dummy encoder class that is used if the encoding cannot be
    # determined from BOM. This way we know that additional heuristic
    # analysis is needed:
    $reader = [System.IO.StreamReader]::new($Path,$nullEncoder,$true)
    # must read the file at least once to get encoding:
    $null = $reader.Peek()
    $encoding = $reader.CurrentEncoding
    $reader.Close()
    $reader.Dispose()
    # if the encoding equals default encoding then there was no bom:
    $bom = $encoding -ne $nullEncoder
    $bodyname = $encoding.BodyName
    $confidence = 100
    
    # if there was no bom and non-bom files were not excluded...
    if (($bom -eq $false) -and ($BomOnly.IsPresent -eq $false))
    {
      # ...do a heuristic analysis based on file content:
      [System.IO.FileStream]$stream = [System.IO.File]::OpenRead($Path)
      $cdet.Feed($stream)
      $cdet.DataEnd()
      $bodyname = $cdet.Charset
      $confidence = [int]($cdet.Confidence * 100)
      # add a workaround for the awkward default encoding created
      # by Set-Content on Windows PowerShell:
      if ($confidence -eq 0 -and $bodyname -eq $null)
      {
        $confidence = 25
        $bodyname = 'ANSI'
      }
      $stream.Close()
      $stream.Dispose()
    }
    
    # return findings as a custom object:
    if ($bom -or !$BomOnly.IsPresent)
    {
      [PSCustomObject]@{
        BOM          = $bom
        Encoding     = $bodyName.ToUpper()
        Confidence   = $confidence
        Path = $Path
      }
    }
  }
}

Set-Alias -Name Get-Encoding -Value Get-PsOneEncoding