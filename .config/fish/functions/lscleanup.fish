if test "$LSB_SYSTEM" = "Darwin"
    function lscleanup --description 'alias lscleanup=/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user ; and killall Finder'
        /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
        and killall Finder $argv
    end
end