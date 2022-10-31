if status is-interactive
    # Commands to run in interactive sessions can go here
    # Install fisher automatically
    if not functions -q fisher
        set -q XDG_CONFIG_HOME
        or set XDG_CONFIG_HOME ~/.config
        curl -sL https://git.io/fisher | source ; and fisher update
    end

    set -g theme_color_scheme gruvbox
    set -g theme_display_hg no
    set -g theme_display_hostname yes
    set -g theme_display_ruby no
    set -g theme_nerd_fonts yes

    set -g LSB_SYSTEM (uname -s)

    # exclude ls, df
    set -g grc_plugin_ignore_execs ls df

    mkdir -p "$HOME/.vim/swaps"; or true
    mkdir -p "$HOME/.vim/backups"; or true

    # Chromebook linux
    if [ "$hostname" = penguin ]
        xhost +local:all
    end
end
