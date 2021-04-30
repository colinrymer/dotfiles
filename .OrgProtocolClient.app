on open location this_URL
    set EC to "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient --no-wait "
    set filePath to quoted form of this_URL
    do shell script EC & filePath
    tell application "Emacs" to activate
end open location

