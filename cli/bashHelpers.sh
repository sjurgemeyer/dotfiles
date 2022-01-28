#!/bin/bash
function parseArgs() {

    declare -A animals
    animals["moo"]="cow"

    #This is a way to pass a map to a function
    printArgs "$(declare -p animals)"
}

function printArgs() {

    #This is a way to parse a passed map to a function
    eval "declare -A foo="${1#*=}
    echo ${foo["moo"]}
}


function my_test() {
    validateParams myfunction \
        `string_flag f format` \
        `boolean_flag x switch` \
        `positional param1` \
        `positional_optional param2` \
        $*

    echo format=${myfunction_args[format]}
    echo switch=${myfunction_args[switch]}
    echo param1=${myfunction_args[param1]}
    echo param2=${myfunction_args[param2]}
}

function boolean_flag() {
    echo VALIDATE_ARG_FLAG_SHORT_$1_LONG_$2_BOOLEAN
}

function string_flag() {
    echo VALIDATE_ARG_FLAG_SHORT_$1_LONG_$2_STRING
}

function positional() {
    echo VALIDATE_ARG_POSITIONAL_$1
}
function positional_optional() {
    echo VALIDATE_ARG_POSITIONAL_$1_OPTIONAL
}

function validateParams() {

    #Define params
    declare -a positionals
    declare -a flags
    function_name=$1
    shift
    while [[ $1 =~ VALIDATE_ARG* ]]; do
        key="$1"
        echo $key
        case "$key" in
			VALIDATE_ARG_FLAG*)
                declare -a flag_args=()
                short=`echo $key | sed -En 's/VALIDATE_ARG_.*SHORT_([^_]*).*/\1/p'`
                echo $short
                if [ -n "$short" ]; then
                    flag_args+=-$short
                fi

                long=`echo $key | sed -En 's/VALIDATE_ARG_.*LONG_([^_]*).*/\1/p'`
                echo $long
                if [ -n "$long" ]; then
                    flag_args+=--$long
                fi
                type=`echo $key | sed -En 's/VALIDATE_ARG_.*_([^_]*)$/\1/p'`
                echo $type
                flag_args+=$type
                flags+=`join _ $flag_args`

            ;;

			VALIDATE_ARG_POSITIONAL*)
                name=`echo $key | sed -En 's/VALIDATE_ARG_POSITIONAL_([^_]*).*/\1/p'`
                echo $name
                optional=`echo $key | sed -En 's/VALIDATE_ARG_.*(OPTIONAL).*/\1/p'`
                echo $optional
                if [ -z $optional ]; then
                    positionals+=$name
                else
                    positionals+=${name}_OPTIONAL
                fi

            ;;
            *)
            ;;
        esac

        shift
    done

echo $positionals
echo $flags

    # Validate params against definitions

    declare -A temp_args
    positional_index=1
    while test $# -gt 0; do
        echo arg $1
        arg_set=0
        for flag in $flags; do
            local IFS="_"
            flag_options=(${(s:_:)flag})
            type=${flag_options[-1]}
            unset "flag_options[-1]"
            key=${flag_options[-2]}
            key=`echo $key | sed -En 's/[-]+(.*)/\1/p'`
            echo KEY: $key
            echo TYPE: $type
            unset IFS
            echo flag $flag
            for option in $flag_options; do
                echo option $option

                if [[ "$1" = $option* ]]; then
                    echo "$1 Matched option $option"

                    if [[ "$1" = $option=* ]]; then
                        echo "Found = syntax $1"
                        temp_args[$key]=`echo $1 | sed -En 's/--.*=(.*)/\1/p'`
                        arg_set=
                        break
                    elif [[ "$type" = "BOOLEAN" ]]; then
                        echo "Found true flag $1"
                        temp_args[$key]=true
                        break
                    else
                        echo "Found - flag $1"
                        shift
                        temp_args[$key]=$1
                        break
                    fi
                fi
            done
        done
        if [[ -z ${temp_args[$key]} ]]; then
            positional_value=${positionals[positional_index]}
            positional_array=(${(s:_:)positional_value})
            echo $positional_array
            positional_name=${positional_array[1]}
            echo $positional_name
            temp_args[$positional_name]=$1
            let "positional_index+=1"
        fi
        shift
    done

    declare -g -A ${function_name}_args
    set -A ${function_name}_args ${(kv)temp_args}
}

function join {
    local IFS="$1"
    shift
    echo "$*"
}

function matrix() {
    #https://gist.github.com/khakimov/3558086
    echo -e "\e[1;40m" ; clear ; while :; do echo $LINES $COLUMNS $(( $RANDOM % $COLUMNS)) $(( $RANDOM % 72 )) ;sleep 0.05; done|awk '{ letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"; c=$4; letter=substr(letters,c,1);a[$3]=0;for (x in a) {o=a[x];a[x]=a[x]+1; printf "\033[%s;%sH\033[2;32m%s",o,x,letter; printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,letter;if (a[x] >= $1) { a[x]=0; } }}'
}

function dostuff() {
    sels=( "${$(fd "${fd_default[@]}" "${@:2}"| fzf -m)}" )
    test -n "$sels" && print -z -- "$1 ${sels[@]:q:q}"
}

normal=$'\e[0m'                           # (works better sometimes)
bold=$(tput bold)                         # make colors bold/bright
red="$bold$(tput setaf 1)"                # bright red text
green=$(tput setaf 2)                     # dim green text
fawn=$(tput setaf 3); beige="$fawn"       # dark yellow text
yellow="$bold$fawn"                       # bright yellow text
darkblue=$(tput setaf 4)                  # dim blue text
blue="$bold$darkblue"                     # bright blue text
purple=$(tput setaf 5); magenta="$purple" # magenta text
pink="$bold$purple"                       # bright magenta text
darkcyan=$(tput setaf 6)                  # dim cyan text
cyan="$bold$darkcyan"                     # bright cyan text
gray=$(tput setaf 7)                      # dim white text
darkgray="$bold"$(tput setaf 0)           # bold black = dark gray text
white="$bold$gray"                        # bright white text
