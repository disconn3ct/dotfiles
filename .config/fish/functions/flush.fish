which -s dscacheutil
and function flush --description 'alias flush=dscacheutil -flushcache ; and killall -HUP mDNSResponder'
    dscacheutil -flushcache
    and killall -HUP mDNSResponder $argv
end
