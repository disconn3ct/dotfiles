if test "$LSB_SYSTEM" = "Darwin"
    function show --description 'alias show=defaults write com.apple.finder AppleShowAllFiles -bool true ; and killall Finder'
        defaults write com.apple.finder AppleShowAllFiles -bool true
        and killall Finder $argv

    end
end