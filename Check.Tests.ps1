# Checks what you found out: your answers in answers.txt, and the two lists you saved.
# Run it from this folder with: Invoke-Pester
# You don't need to change this file.

BeforeAll {
    $script:answers = @{}
    foreach ($line in Get-Content (Join-Path $PSScriptRoot 'answers.txt')) {
        if ($line -match '^\s*(\d+)\)\s*(.*)$') {
            $script:answers[[int]$Matches[1]] = $Matches[2].Trim().Trim("'", '"')
        }
    }

    $script:photos = Join-Path $PSScriptRoot 'photos'
    $script:photoNames = @(Get-ChildItem $photos -File).Name
}

Describe 'Exercise: What a File Knows' {

    It '1) what kind of object a photo is' {
        $answers[1] | Should -Not -BeNullOrEmpty -Because 'question 1 has no answer yet. Pipe photos\harbor-at-dawn.jpg from Get-Item to Get-Member and read the TypeName line'
        ($answers[1] -replace '^TypeName:\s*', '') | Should -Be 'System.IO.FileInfo' -Because 'Get-Member names the kind of object on its TypeName line'
    }

    It '2) the size of harbor-at-dawn.jpg in bytes' {
        $answers[2] | Should -Not -BeNullOrEmpty -Because 'question 2 has no answer yet. Read the Length property of photos\harbor-at-dawn.jpg with a dot'
        $size = (Get-Item (Join-Path $photos 'harbor-at-dawn.jpg')).Length
        ($answers[2] -replace '[,\s]|bytes$', '') | Should -Be "$size" -Because 'a file''s size in bytes is its Length property: (Get-Item photos\harbor-at-dawn.jpg).Length'
    }

    It '3) the day of the week of December 25, 2026' {
        $answers[3] | Should -Not -BeNullOrEmpty -Because 'question 3 has no answer yet. Get-Date 2026-12-25 gets that date; read its DayOfWeek property'
        $answers[3] | Should -Be "$((Get-Date 2026-12-25).DayOfWeek)" -Because 'a date knows its own day of the week: (Get-Date 2026-12-25).DayOfWeek'
    }

    It '4) the day of the week 100 days after December 25, 2026' {
        $answers[4] | Should -Not -BeNullOrEmpty -Because 'question 4 has no answer yet. Call the date''s AddDays method with 100, then read DayOfWeek'
        $answers[4] | Should -Be "$((Get-Date 2026-12-25).AddDays(100).DayOfWeek)" -Because 'AddDays(100) works out the date 100 days later, and DayOfWeek reads its day: (Get-Date 2026-12-25).AddDays(100).DayOfWeek'
    }

    It '5) the property that says when a program started' {
        $answers[5] | Should -Not -BeNullOrEmpty -Because 'question 5 has no answer yet. Pipe Get-Process -Id $PID to Get-Member and look at the names that end in Time'
        $answers[5] | Should -Be 'StartTime' -Because 'one property of a running program holds the date and time it started'
    }

    It '6) the last file Get-ChildItem lists in photos' {
        $answers[6] | Should -Not -BeNullOrEmpty -Because 'question 6 has no answer yet. Use Select-Object -Last 1 after Get-ChildItem photos'
        $last = (Get-ChildItem $photos -File | Select-Object -Last 1).Name
        $answers[6] | Should -Be $last -Because 'Select-Object -Last 1 keeps the last file in the order Get-ChildItem lists them, by name'
    }

    It 'photo-names.txt holds every photo''s name, one per line, with no heading' {
        $file = Join-Path $PSScriptRoot 'photo-names.txt'
        Test-Path $file -PathType Leaf | Should -BeTrue -Because 'step 2 saves the names in photo-names.txt, in this folder, with Select-Object -ExpandProperty Name and Set-Content'
        $lines = @(Get-Content $file | ForEach-Object { $_.Trim() } | Where-Object { $_ })
        $lines | Should -Not -Contain 'Name' -Because 'a plain list has no heading: use -ExpandProperty, not -Property'
        $lines | Should -Not -Contain '----' -Because 'a plain list has no heading: use -ExpandProperty, not -Property'
        ($lines -match '^@\{') | Should -BeNullOrEmpty -Because 'lines such as @{Name=ferry-ride.jpg} are whole objects from -Property Name: -ExpandProperty Name hands on only the names'
        foreach ($name in $photoNames) {
            $lines | Should -Contain $name -Because 'every file in photos should be on its own line'
        }
        $lines.Count | Should -Be $photoNames.Count -Because 'the list holds one line for each file in photos, and nothing else'
    }

    It 'photo-sizes.txt holds a table of names and sizes, as it looks on the screen' {
        $file = Join-Path $PSScriptRoot 'photo-sizes.txt'
        Test-Path $file -PathType Leaf | Should -BeTrue -Because 'step 3 saves the table in photo-sizes.txt, in this folder, with Format-Table Name, Length and >'
        $text = Get-Content $file -Raw
        $text | Should -Not -Match 'Microsoft\.PowerShell\.Commands\.Internal\.Format' -Because 'after a Format- command only > or Out-File may follow: Set-Content writes the names of the formatting instructions'
        $text | Should -Match '(?m)^\s*Name\s+Length\s*$' -Because 'the table has exactly two columns, Name and Length, in that order'
        foreach ($name in $photoNames) {
            $size = (Get-Item (Join-Path $photos $name)).Length
            $text | Should -Match ("(?m)^\s*{0}\s+{1}\s*$" -f [regex]::Escape($name), $size) -Because "the table has a row for $name with its size, $size"
        }
    }
}
