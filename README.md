# Exercise: What a File Knows

Exercise code for the lesson **Exercise: What a File Knows** in PowerShell in Depth on [ask-codey.com](https://www.ask-codey.com).

A friend came back from a weekend at the coast and gave you the photos, with a few questions: what are these files, really, how big is the one of the harbor, and what's the last one in the folder? They'd also like two lists to keep: the photo names, and a table of names and sizes. You'll find every answer by asking the objects themselves, and a Pester check tells you what's done.

## What's here

- `photos/`: the five photos from the trip. Ask them questions; don't rename or change them.
- `answers.txt`: one line for each question, waiting for your answer. For you to finish.
- `Check.Tests.ps1`: the check. You don't need to change it.

## What to do

Open PowerShell 7 and go into this folder with `Set-Location`. Then use the commands from the *Everything Is an Object* chapter: `Get-Member`, a dot for a property, methods with `()`, `Select-Object` and `Format-Table`.

1. **Ask the questions.** Answer questions 1 to 6 below, and write each answer after its number in `answers.txt`, on the same line, for example `2) 1234`.
2. **Save a list of the names.** Make `photo-names.txt`, in this folder: the name of every file in `photos`, one per line, with no heading. Use `Select-Object -ExpandProperty` and `Set-Content`.
3. **Save a table of sizes.** Make `photo-sizes.txt`, in this folder: a table with two columns, `Name` and `Length`, for every file in `photos`, saved exactly as it looks on the screen. Use `Format-Table` and `>`.

The questions:

1. What kind of object is a photo? Write the name on the TypeName line that `Get-Member` shows for `photos\harbor-at-dawn.jpg`.
2. How big is `photos\harbor-at-dawn.jpg`, in bytes? Read the property with a dot.
3. On which day of the week does December 25, 2026 fall? `Get-Date 2026-12-25` gets that date as an object; read one of its properties.
4. On which day of the week is the date 100 days after December 25, 2026? Use one of the date's methods, then a property.
5. A running program is an object too. Which of its properties holds the date and time it started? `Get-Process -Id $PID` gets your own PowerShell window.
6. What is the name of the last file `Get-ChildItem photos` lists? Use `Select-Object`.

## Check your work

The check needs Pester 5 or newer. Install it once, if you haven't already:

```powershell
Install-PSResource Pester
```

Then, from this folder:

```powershell
Invoke-Pester
```

At first every test fails: that is expected. Each step you finish turns its test green. A failing test's message says which step or question it is and what to try.

If PowerShell says the check *cannot be loaded because running scripts is disabled* or *is not digitally signed*, the folder came from a download that Windows marked as from the internet. Unblock its files once with `Get-ChildItem -Recurse | Unblock-File`, from this folder, and run `Invoke-Pester` again. *Why a Script Won't Run: The Execution Policy*, in Module 5, explains what that does.

## Tips

- `Get-Member` lists a lot. `-MemberType Property` keeps it to properties, and `-Name *Time` to the names that end in Time.
- A property that prints nothing is usually a misspelled name. Check it with `Get-Member`.
- A method needs its parentheses, with what it works with inside them.
- Save the lists in this folder, not in `photos`: question 6 asks about what's in `photos`.
- After `Format-Table`, only `>` or `Out-File` may follow. `Set-Content` there writes the wrong thing.

## Hand it in

When it works, push your solution to a public repo of your own on GitHub, then paste that repo's address into **Submit your exercise** on the lesson page at [ask-codey.com](https://www.ask-codey.com). That's what completes the lesson. The lesson page shows the Git commands, step by step.
