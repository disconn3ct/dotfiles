which -s lsd
or function lsd --description 'LSD package placeholder. Uses ls instead'
    which -s lsd
    and begin
        functions -e lsd
        command lsd $argv
    end
    or begin
        command ls $argv
    end
end
