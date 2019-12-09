if test "$LSB_SYSTEM" = "Darwin"
    function hide --description 'alias hide=defaults write com.apple.finder AppleShowAllFiles -bool false ; and killall Finder'
        defaults write com.apple.finder AppleShowAllFiles -bool false
        and killall Finder $argv
    end
end
