# Linux Common Commands

This page briefly documents common Linux commands. This is very personalized to
my own experience and is not intended to replace any existting documentation
(i.e. `man` or `tldr`). Rather, it can be thought of as a list of commands that
I should be familiar with by memory.

## cd

Changes the current directory to the given one.

Tip: Use `cd -` to go back to the previous directory.

## clear

Clears the terminal screen and places the cursor at the top left.

## info

An alternative to `man`, primarily used with GNU.

## ls

Shows a list of files and directories.

| Option | Description                                                        |
| ------ | ------------------------------------------------------------------ |
| -a     | Includes hidden files                                              |
| -l     | Displays a long listing with detailed file infomration             |
| -ld    | Displays a long listing of a directory but hides its contents      |
| -lh    | Displays a long listing with file sizes in a human-friendly format |
| -lt    | Lists all files sorted by date and time (newest first)             |
| -ltr   | Lists all files sorted by date and time (oldest first)             |
| -R     | Recursively lists contents of a directory                          |

## man

Shows the manual for a given command.

Tip: Use `man -k` to do a keyword search across available man pages.

## pwd

Shows the current location in the directory tree.

## tree

Lists a hierarchy of files and directories.

| Option | Description                                  |
| ------ | -------------------------------------------- |
| -a     | Includes hidden files in the output          |
| -d     | Excludes files from the output               |
| -h     | Displays file sizes in human-friendly format |
| -f     | Prints the full path for each file           |
| -p     | Includes file permissions in the output      |

## tty

Shows the location of the current pseudo terminal session.

## uname

Displays high-level information about the system environment.

| Option | Description            |
| ------ | ---------------------- |
| -a     | Show all details       |
| -i     | Show hardware platform |
| -m     | Show hardware name     |
| -o     | Show OS name           |
| -p     | Show processor type    |
| -r     | Show kernel release    |
| -s     | Show kernel name       |
| -v     | Show kernel build date |

## uptime

Displays system's current time, length of time it has been up for, number of
users currently logged in, and the average CPU load.

## which

Displays the absolute path to the given command.
