function ipaws --description "Find a host by public IP"
    for srch in $argv
        for region in $AWS_REGION_SEARCH
            _awsoutcheck aws ec2 describe-instances --region "$region" --filter "Name=ip-address,Values=$argv[1]" --output text --query "Reservations[].Instances[].[ Tags[?Key=='Name'].Value | [0], PublicIpAddress ]"
            and return
        end
    end
end
