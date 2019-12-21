which -s dig
and function myip --description 'alias myip=dig +short myip.opendns.com @resolver1.opendns.com'
    dig -4 +short myip.opendns.com @resolver1.opendns.com $argv
end
