<#
.SYNOPSIS
    Expand a multi-file .tex project into a single script and then compile it
.DESCRIPTION
    Expand a multi-file .tex project into a single script, then call compile.ps1 to perform the appropriate LaTeX compilation steps.
    The script automatically cleans up all intermediate files and can open the output pdf.
    The aforementioned cleanup is indiscriminate, so DO NOT name files in the same folder $Expanded*.
.PARAMETER FileName
    The name (without extension) of the main .tex to compile. Defaults to Main
.PARAMETER Expanded
    The name (without extension) of the output expanded .tex and .pdf. Defaults to EXPANDED
.PARAMETER ShowPdf
    Open the output pdf in the default pdf reader
.EXAMPLE
    PS> compile_expanded.ps1 MyTexName MyExpandedName -ShowPdf
#>
param(
    [string]$FileName = 'Main',
    [string]$Expanded = 'EXPANDED',
    [switch]$ShowPdf = $False
)

latexpand "$FileName.tex" > "$Expanded.tex"
& .\compile.ps1 -FileName $Expanded -Cleanup -ShowPdf=$ShowPdf