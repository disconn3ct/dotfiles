function df --description 'alias df=df -h'
    if type -q grc.wrap
        set -l executable df
        grc.wrap $executable -h $argv
    else
        command df -h $argv
    end
end
