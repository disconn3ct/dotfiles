which -s kubectl
and function k --description "kubectl"
    if which -s kubecolor 
    	kubecolor $argv
    else
    	kubectl $argv
    end
end

