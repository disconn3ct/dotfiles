function kwatch --wraps kubectl
  watch -c kubecolor --force-colors $argv;
end

