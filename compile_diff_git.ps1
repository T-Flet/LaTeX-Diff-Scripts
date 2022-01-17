<#
.SYNOPSIS
    Produce and compile a .tex file highlighting the changes of a .tex project compared with a given past commit of it
.DESCRIPTION
    Given the hash or alias (e.g. HEAD~1) of a past commit, produce and compile each of the following:
        - a single-.tex-script version of the current state
        - a single-.tex-script version of the state at the given commit
        - a single-.tex-script version of the current state WITH the differences from the given commit highlighted
    The script calls compile_expanded.ps1 to produce the first two outputs; it automatically cleans up all intermediate files and opens the differences pdf.
    The aforementioned cleanup is indiscriminate, so DO NOT name files in the same folder $Old*, $New* or $Diff*.
.PARAMETER OldCommit
    An alias of the commit to compare to, such as its partial or full hash or e.g. HEAD~1, which is the default
.PARAMETER FileName
    The name (without extension) of the main .tex to compile. Defaults to Report
.PARAMETER Old
    The name (without extension) of the expanded .tex and .pdf of the given commit version. Defaults to OLD_EXPANDED
.PARAMETER New
    The name (without extension) of the expanded .tex and .pdf of the current commit version. Defaults to NEW_EXPANDED
.PARAMETER Diff
    The name (without extension) of the expanded .tex and .pdf of the differences between old and new versions. Defaults to DIFF_EXPANDED
.EXAMPLE
    PS> compile_diff_git.ps1 HEAD~1 MyTexName MyOldName MyNewName MyDiffName
#>
param(
    [string]$OldCommit = 'HEAD~1',
    [string]$FileName = 'Report',
    [string]$Old = 'OLD_EXPANDED',
    [string]$New = 'NEW_EXPANDED',
    [string]$Diff = 'DIFF_EXPANDED'
)

$Branch = git branch --show-current

Write-Output "Creating $New.tex and $New.pdf`n"
latexpand "$FileName.tex" > "$New.tex"
& .\compile.ps1 -FileName $New -Cleanup

Write-Output "`nGoing to $OldCommit and creating $Old.tex and $Old.pdf`n"
git stash
git checkout -f $OldCommit
latexpand "$FileName.tex" > "$Old.tex"
& .\compile.ps1 -FileName $Old -Cleanup
git checkout -f $Branch
git stash apply

Write-Output "`nGenerating diff documents $Diff.tex and $Diff.pdf`n"
latexdiff -t CTRADITIONAL "$Old.tex" "$New.tex" > "$Diff.tex"
& .\compile.ps1 -FileName $Diff -Cleanup -ShowPdf