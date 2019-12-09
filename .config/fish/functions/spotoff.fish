if test "$LSB_SYSTEM" = "Darwin"
    function spotoff --description 'alias spotoff=sudo mdutil -a -i off'
        sudo mdutil -a -i off $argv
    end
end