#!/bin/bash
perc=0
test_amount=10
times_to_eat=10
error_file=.error

B_ERROR_COLOR="\e[1;31m"
B_OK_COLOR="\e[1;32m"
B_WARN_COLOR="\e[1;33m"
B_BLUE="\e[1;34m"
B_MAGENTA="\e[1;35m"
B_CYAN="\e[1;36m"

BH_ERROR_COLOR="\e[1;91m"
BH_OK_COLOR="\e[1;92m"
BH_WARN_COLOR="\e[1;93m"
BH_BLUE="\e[1;94m"
BH_MAGENTA="\e[1;95m"
BH_CYAN="\e[1;96m"

RESET="\033[0m"


if [ -d $error_file ]; then
    rm -rf $error_file; 
fi
mkdir $error_file

print_loading_bar () {
    if (( $1 != 100 && $1 % 5 == 0 )) ; then
        printf "${BH_OK_COLOR}#${RESET}"
    fi
}

print_perc () {
    if [ $1 -gt 95 ]; then
        printf "\t${B_OK_COLOR}$1 %% correct${RESET}\n" 
    elif [ $1 -gt 69 ]; then
        printf "\t${B_WARN_COLOR}$1 %% correct${RESET}\n" 
    else
        printf "\t${B_ERROR_COLOR}$1 %% correct${RESET}\n"
    fi
    printf "\n"
}

perc_correct_die () {
    count_false=0
    count_correct=0
    loading_bar_count=0
    printf "${BH_MAGENTA}$1 $2 $3 $4 $5 ${RESET}\n"
    printf "LOADING\t"
    for (( i=0; i < $test_amount; i++))  ; do
        line=$(./philo $1 $2 $3 $4 $5 > output && cat output | grep died)
        exit_status=$(echo $?)
        if (( $exit_status == 1 )) ; then
            echo "--------------- $1 $2 $3 $4 $5 --------------------" >> $error_file/"$1_$2_$3_$4_$5_$i" && cat output >> $error_file/"$1_$2_$3_$4_$5_$i"
            (( count_false++ ))
        else
            (( count_correct++ ))
        fi
        (( loading_bar_count++ ))
        print_loading_bar $(awk -v count="$loading_bar_count" -v tests="$test_amount" 'BEGIN {print 100 / tests * count}')
    done
    print_perc $(awk -v count="$count_correct" -v tests="$test_amount" 'BEGIN {print 100 / tests * count}')
}

perc_correct_live () {
    count_false=0
    count_correct=0
    loading_bar_count=0
    printf "${BH_MAGENTA}$1 $2 $3 $4 $5 ${RESET}\n"
    printf "LOADING\t"
    for (( i=0; i < $test_amount; i++)) ; do
        line=$(./philo $1 $2 $3 $4 $5 > output && cat output | grep died)
        exit_status=$(echo $?)
        if (( $exit_status == 0 )) ; then
            echo "--------------- $1 $2 $3 $4 $5 --------------------" >> $error_file/"$1_$2_$3_$4_$5_$i" && cat output >> $error_file/"$1_$2_$3_$4_$5_$i"
            (( count_false++ ))
        else
            (( count_correct++ ))
        fi
        (( loading_bar_count++ ))
        print_loading_bar $(awk -v count="$loading_bar_count" -v tests="$test_amount" 'BEGIN {print 100 / tests * count}')
    done
    print_perc $(awk -v count="$count_correct" -v tests="$test_amount" 'BEGIN {print 100 / tests * count}')
}

uneven_live () {
    printf "\n${B_CYAN}Testing uneven numbers - they shouldn't die${RESET}\n\n"
    perc_correct_live 5 800 200 200 $times_to_eat
    perc_correct_live 5 610 200 200 $times_to_eat
    perc_correct_live 199 610 200 200 $times_to_eat
}

even_live () {
    printf "\n${B_CYAN}Testing even numbers - they shouldn't die${RESET}\n\n"
    perc_correct_live 4 410 200 200 $times_to_eat
    perc_correct_live 198 610 200 200 $times_to_eat
    perc_correct_live 198 800 200 200 $times_to_eat
}

even_die () {
    printf "\n${B_CYAN}Testing even numbers - one should die${RESET}\n\n"
    perc_correct_die 3 599 200 200 $time_to_eat
    perc_correct_die 31 599 200 200 $times_to_eat
    perc_correct_die 131 596 200 200 $time_to_eat
}

uneven_die () {
    printf "\n${B_CYAN}Testing uneven numbers - one should die${RESET}\n\n"
    perc_correct_die 4 310 200 100 $times_to_eat
    perc_correct_die 1 800 200 100 $times_to_eat
}

text () {
    printf "\e[1;1H\e[2J"
    printf "\n${B_BLUE}Philo Tester${RESET}\t$(date +%Y/%m/%d)\n\n"
    printf "${B_MAGENTA}All tests\t\t\t\t[0]${RESET}\n\n"
    printf "Uneven numbers that shouldn't die\t[1]\n"
    printf "Even numbers that shouldn't die\t\t[2]\n"
    printf "${B_MAGENTA}All numbers that shouldn't die\t\t[3]${RESET}\n\n"
    printf "Uneven numbers that should die\t\t[4]\n"
    printf "Even numbers that should die\t\t[5]\n"
    printf "${B_MAGENTA}All numbers that should die\t\t[6]${RESET}\n\n"
}

tests () {
    text
	read -r -n 1 -p $'\n\nPlease choose:' test
	printf "\n"
	case $test in
		0)
            clear
			uneven_live
            even_live
            uneven_die
            even_die
			;;
		1)
            clear
			uneven_live
			;;
		2)
            clear
			even_live
			;;
		3)
            clear
            uneven_live
			even_live
			;;
		4)
            clear
            uneven_die
			;;
		5)
            clear
			even_die
			;;
		6)
            clear
            uneven_die
			even_die
			;;
		$'\e')
			exit 0
			;;
		*)
            clear
			printf "${B_WARN_COLOR}Invalid input!\n${RESET}"
			tests
			;;
	esac
}

tests
rm output