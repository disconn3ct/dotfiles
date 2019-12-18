command which -s ls >/dev/null 2>/dev/null
or function which --description "locate a program file in the user's path"
    if test $argv[1] = "-s"
        if test -n $argv[2]
            set cmdline $argv[2..-1]
        else
            set cmdline
        end
        set quiet 1
    else
        set cmdline $argv
        set quiet 0
    end
    if test "$quiet" -eq 1
        command which $cmdline >/dev/null 2>/dev/null
    else
        command which $cmdline
    end
    return $status
end
