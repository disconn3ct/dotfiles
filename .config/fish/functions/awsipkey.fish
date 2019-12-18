function awsipkey --description "Get IP and build key"
    for srch in $argv
        for region in $AWS_REGION_SEARCH
            _awsoutcheck aws ec2 describe-instances --region "$region" --filter "Name=tag:Name,Values=*$srch*" --output text --query "Reservations[].Instances[].[ Tags[?Key=='Name'].Value | [0], PublicIpAddress, KeyName ]"
            and return
        end
    end
end