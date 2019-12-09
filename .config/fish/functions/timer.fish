function timer --description 'Start an arbitrary timer'
    echo "Timer started. Stop with Ctrl-D."
    and date
    and time cat
    and date $argv
end
