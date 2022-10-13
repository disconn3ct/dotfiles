if test "$LSB_SYSTEM" = "Darwin"
    set COLORFLAG -G
else
    set COLORFLAG --color=auto
end
# Only alias for LSD (preferred) or GRC
begin
    type -q lsd
    or type -q grc.wrap
end
and function ls
    if type -q lsd
        # Explicitly use command, not the function defined elsewhere
        command lsd --icon-theme unicode -a $argv
    else
        if type -q grcc.wrap
            set -l executable ls
            grc.wrap $executable -a $argv
        else
            # Something changed. Use raw ls instead.
            if status is-interactive
                command ls -aF $COLORFLAG $argv
            else
                command ls $argv
            end
        end
    end
end
