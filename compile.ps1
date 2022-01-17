<#
.SYNOPSIS
    Perform the sequence of steps to fully compile a LaTeX project
.DESCRIPTION
    Perform a sequence of steps to fully compile a LaTeX project; edit the involved commands in this file to suit the project's needs (e.g. xelatex vs pdflatex, natbib vs Biber, ...).
    The script can automatically cleanup all intermediate files and open the output pdf.
.PARAMETER FileName
    The name (without extension) of the main .tex to compile. Defaults to Report
.PARAMETER Cleanup
    Delete all files in the current folder called $FileName* except for .tex and .pdf
.PARAMETER ShowPdf
    Open the output pdf in the default pdf reader
.EXAMPLE
    PS> compile.ps1 MyTexName -Cleanup -ShowPdf
#>
param(
    [string]$FileName = 'Report',
    [switch]$Cleanup = $False,
    [switch]$ShowPdf = $False
)

xelatex $FileName
# pdflatex $FileName
makeglossaries $FileName
Biber $FileName
# bibtex $FileName
xelatex $FileName
# pdflatex $FileName

if ($Cleanup) { Remove-Item * -Include $FileName* -Exclude *.tex,*.pdf }
if ($ShowPdf) { Start-Process "$FileName.pdf" }