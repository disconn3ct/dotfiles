# Example: awsipr potato us-west-1
function awsipr --description "Get an IP address (with region)"
    _awsoutcheck aws ec2 describe-instances --region "$argv[2]" --filter "Name=tag:Name,Values=*$argv[1]*" --output text --query 'Reservations[*].Instances[*].PublicIpAddress'
    and return
end

