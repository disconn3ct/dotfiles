function pipaws
    for srch in $argv
        for region in $AWS_REGION_SEARCH
            _awsoutcheck aws ec2 describe-instances --region "$region" --filter "Name=private-ip-address,Values=$argv[1]" --output text --query "Reservations[].Instances[].[ Tags[?Key=='Name'].Value | [0], PrivateIpAddress ]"
            and return
        end
    end
end
