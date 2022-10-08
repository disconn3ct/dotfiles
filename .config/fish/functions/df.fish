function df
    if type -q grc.wrap
        set -l executable df
        grc.wrap $executable -x squashfs -h $argv
    else
        command df -x squashfs -h $argv
    end
end
