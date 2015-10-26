_machine()
{
    local cur prev opts base
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    #
    #  The basic options we'll complete.
    #
    opts=$(for x in `ls -d -1 $HOME/.machines/*/`; do x=${x%/}; echo ${x/$HOME\/.machines\//}; done )

    #
    #  Complete the arguments to some of the basic commands.
    #
    if [ -d "$HOME/.machines/${prev}" ]; then
    	names=$(for x in `ls -1 $HOME/.machines/${prev}/*`; do echo ${x/$HOME\/.machines\/$prev\//} ; done )
    	COMPREPLY=( $(compgen -W "${names}" -- ${cur}) )
	return 0
    fi

   COMPREPLY=($(compgen -W "${opts}" -- ${cur})) 
   return 0
}
complete -F _machine machine
