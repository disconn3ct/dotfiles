function ksecret
  set secret $argv[1]
  set item $argv[2]
  kubectl get secret "$secret" -o jsonpath="{.data.$item}" $argv[3..] | base64 --decode
end

