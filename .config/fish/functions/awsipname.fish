function awsipname --description "Get IP and name (search regions)"
    for srchtxt in $argv
        for region in $AWS_REGION_SEARCH
            _awsoutcheck awsipnamer "$srchtxt" "$region"
            and return
        end
    end
end