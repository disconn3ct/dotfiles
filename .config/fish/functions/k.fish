type -q kubectl
and function k --description "kubectl"
    if type -q kubecolor 
    	kubecolor $argv
    else
    	kubectl $argv
    end
end

