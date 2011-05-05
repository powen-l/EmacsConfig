@echo off
REG ADD "HKCR\*\shell\open with emacs...\command" /ve /d "e:\Tools\emacs-23.3\bin\emacsclientw.exe \"%%1\" -a e:\Tools\emacs-23.3\bin\runemacs.exe"
