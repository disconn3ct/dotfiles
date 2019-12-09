if test "$LSB_SYSTEM" = "Darwin"
    function spoton --description 'alias spoton=sudo mdutil -a -i on'
        sudo mdutil -a -i on $argv
    end
end