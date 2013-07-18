# core.bash --- Core utilities for setup scripts.

# Configure default finish printer.
FINPRINT=my_echo
if test x$(command -v cowsay) != x ; then
    FINPRINT=my_cowsay
fi

# Supported colors.
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
bold=$(tput bold)
reset=$(tput sgr0)

# Displays operation title.
#
# Usage:
#
#   check_title "Configuring something"
#
check_title()
{
    echo -n "$@... "
}

# Displays failed result of the operation.
#
# Usage:
#
#   check_error "Fail!"
#
check_error()
{
    echo "${red}$@${reset}"
}

# Displays success result of the operation.
#
# Usage:
#
#   check_success "Fail!"
#
check_success()
{
    echo "${green}$@${reset}"
}

# Customized version of cowsay. It accepts eye setup as a first
# parameter.
#
# Usage:
#
#   my_cowsay oO "Hello world!"
#
my_cowsay()
{
    eyes=$1; shift
    echo $@ | cowsay -e $eyes -W 78
}

# Wrapper for echo that makes it compatible with my_cowsay function,
# so they can be used interchangably.
#
# Usage:
#
#   my_echo oO "Hello world!"
#
my_echo()
{
    shift; echo $@
}

# Prints error and exits program.
#
# Usage:
#
#   raise <<END
#   Something went wrong!
#   END
#
raise()
{
    echo "${red}$($FINPRINT xX $@)${reset}"; echo
    exit 1
}

# Prints success message. It should be used at the end of the setup
# script, when all the actions succeeded.
#
# Usage:
#
#   success <<END
#   All set!
#   END
#
success()
{
    echo "${green}$($FINPRINT ^^ $@)${reset}"; echo
    exit 0
}


# Checks which of given versions is higher and returns that one.
#
# Usage:
#
#   winner=$(check_version $version $required_version)
#   [ "$winner" == "$version" ] || exit 1
#
check_version()
{
    echo -e "$1\n$2" | sed '/^$/d' | sort -nr | head -1
}

# Checks if given command is available in the system.
#
# Usage:
#
#   check_cmd git
#   check_cmd ruby 2.0
#
check_cmd()
{
    cmd=$1
    version=$2

    if test x$version = x ; then
        check_title "Checking for $cmd"
    else
        check_title "Checking for $cmd >= $version"
    fi

    which=$(command -v $cmd)

    if test x$which = x ; then
        check_error "Not found!"
        raise "You don't have $cmd installed in your system!"
    fi

    installed_version=`$cmd --version 2>&1`
    if test x$? != x0 ; then
        installed_version=`$cmd -v 2>&1`
        if test x$? != x0 ; then
            check_error "Unknown!"
            raise "Couldn't figure out what version of $exe is installed!"
        fi
    fi

    installed_version=$(echo $installed_version | grep -oP '\d+(\.\d+)*' | tr '\n' ' ' | cut -d' ' -f1)

    if test x$version != x ; then
        winner=$(check_version $version $installed_version)

        if test x$winner != x$installed_version ; then
            check_error "Outdated!"
            raise "Installed version of $cmd is too old, required >= $version, found $installed_version!"
        fi
    fi

    check_success "Found $installed_version!"
}

# Wraps execution of given command with results checking.
#
# Usage:
#
#   run bundle install
#
run()
{
    check_title "Executing $@"

    out=/tmp/setup-run.out
    $@ 2>&1 >$out

    if test x$? != x0 ; then
        check_error "Fail!"
        cat $out
        raise "Error occured while executing the command!"
    fi

    check_success "Ok!"
}

# Checks if there's a *.sample version of given file. If target file
# doesn't exist, it creates it and opens editor.
#
# Usage:
#
#   edit_sample_file .env
#
edit_sample_file()
{
    file=$1

    check_title "Creating ./$file from sample file"

    if [ "$EDITOR" == "" ]; then
        check_warn "\$EDITOR not set. Trying to use nano"
        EDITOR=$(command -v nano)

        if test x$EDITOR = x ; then
            check_error "Not found!"
            raise "You don't have any configured editor. Install or configure one!"
        fi
    fi

    if [ -f $file ]; then
        check_success "Exists!"
    else
        cp $PWD/${file}.sample $PWD/$file
        check_warn "Editing!"
        $EDITOR .env || true
        echo
    fi
}
