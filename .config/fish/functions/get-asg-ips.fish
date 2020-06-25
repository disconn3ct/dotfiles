function _get-asg-ips-usage
  echo "Usage: get-asg-ips {AMI-ID|ASG name} [environment|'develop'] [region|'us-west-2']"
  echo "Example: get-asg-ips ami-123123123 production us-east-2"
  echo "Alternate: get-asg-ips webserver develop01"
end

function get-asg-ips
  set argc (count $argv)
  if test $argc -lt 1 -o $argc -gt 2
    _get-asg-ips-usage
    return 1
  end
  if test -z "$argv[2]"
    if test -z "$AWS_PROFILE"
      set -x PROFILE develop
    else
      set -x PROFILE $AWS_PROFILE
    end
  else
    set -x PROFILE $argv[2]
  end
  if test -z $argv[3]
    if test -z $AWS_DEFAULT_REGION
      set -x REGION us-west-2
    else
      set -x REGION $AWS_DEFAULT_REGION
    end
  else
    set -x REGION $argv[3]
  end
  set -e AWS_PROFILE
  set -e AWS_DEFAULT_REGION
  if string match -r '^ami-' $argv[1]
    echo "#ami provided"
    set -x AMIID $argv[1]
  else
    set -x AMIID (get_ami_id $argv)
  end
  set INSLIST (aws --profile "$PROFILE" --region "$REGION" ec2 describe-instances --filters Name=image-id,Values="$AMIID" --query "Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddress" --output yaml | string trim -c ' - ')
  if test -n "$VERBOSE"
    echo -e "## AMI: $AMIID owned by $PROFILE in $REGION"
  end
  echo $INSLIST
end
