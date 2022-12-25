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

#printf "\033[s\033[7A\033[1;32m" -- move cursor up seven line
#printf "\033[s\033[7B\033[1;32m" -- move cursor down seven line
#printf "\e[2K" -- clear the entire line
#printf "r" -- carriage return -- go to beginning of the line + start overwriting the line

if [ -d $error_file ]; then
    rm -rf $error_file; 
fi
mkdir $error_file

print_loading_bar () {
    printf "LOADING\t"
    for (( x=0; x <= $1; x+=10)) ; do
    {
        if (( $1 % 10 == 0 )) ; then
            printf "${BH_OK_COLOR}#${RESET}"
        fi
    }
    done
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
    printf "\t${BH_MAGENTA}$1 $2 $3 $4 $5 ${RESET}\n"
   #printf "\t\t\t\tLOADING\t"
    for (( i=1; i <= $test_amount; i++))  ; do
        ./philo $1 $2 $3 $4 $5 > output && cat output | grep died
        exit_status=$(echo $?)
        if (( $exit_status == 1 )) ; then
            printf "\e[2K \r${RESET}$i\t${B_ERROR_COLOR}Fail\t[x]${RESET}\t\t"
            echo "--------------- $1 $2 $3 $4 $5 --------------------" >> $error_file/$1_$2_$3_$4_$5_$i && cat output >> $error_file/$1_$2_$3_$4_$5_$i
            (( count_false++ ))
        else
            printf "\033[s\033[1A\033[1;32m"
            printf "\e[2K \r$i\t${B_OK_COLOR}Pass\t[✓]${RESET}\t\t"
            (( count_correct++ ))
        fi
        print_loading_bar $(awk -v count="$loading_bar_count" -v tests="$test_amount" 'BEGIN {print 100 / tests * count}')
        (( loading_bar_count++ ))
    done
    print_perc $(awk -v count="$count_correct" -v tests="$test_amount" 'BEGIN {print 100 / tests * count}')
}

perc_correct_live () {
    count_false=0
    count_correct=0
    loading_bar_count=0
    printf "\t${BH_MAGENTA}$1 $2 $3 $4 $5 ${RESET}\n"
    #printf "\t\t\t\tLOADING\t"
    for (( i=1; i <= $test_amount; i++)) ; do
        ./philo $1 $2 $3 $4 $5 > output && cat output | grep died
        exit_status=$(echo $?)
        if (( $exit_status == 0 )) ; then
            printf "\033[s\033[1A\033[1;32m"
            printf "\e[2K \r${RESET}$i\t${B_ERROR_COLOR}Fail\t[x]${RESET}\t\t"
            echo "--------------- $1 $2 $3 $4 $5 --------------------" >> $error_file/$1_$2_$3_$4_$5_$i && cat output >> $error_file/$1_$2_$3_$4_$5_$i
            (( count_false++ ))
        else
            printf "\e[2K \r$i\t${B_OK_COLOR}Pass\t[✓]${RESET}\t\t"
            (( count_correct++ ))
        fi
        print_loading_bar $(awk -v count="$loading_bar_count" -v tests="$test_amount" 'BEGIN {print 100 / tests * count}')
        (( loading_bar_count++ ))
    done
    print_perc $(awk -v count="$count_correct" -v tests="$test_amount" 'BEGIN {print 100 / tests * count}')
}

uneven_live () {
    printf "\n${B_CYAN}Testing uneven numbers - they shouldn't die${RESET}\n\n"
    perc_correct_live 5 800 200 200 $times_to_eat
    perc_correct_live 5 610 200 100 $times_to_eat
    perc_correct_live 5 610 200 200 $times_to_eat
    perc_correct_live 5 601 200 200 $times_to_eat

    perc_correct_live 31 610 200 100 $times_to_eat
    perc_correct_live 31 610 200 200 $times_to_eat
    perc_correct_live 31 605 200 200 $times_to_eat
    perc_correct_live 31 601 200 200 $times_to_eat

    perc_correct_live 131 610 200 100 $times_to_eat
    perc_correct_live 131 610 200 200 $times_to_eat
    perc_correct_live 131 605 200 200 $times_to_eat
    perc_correct_live 131 601 200 200 $times_to_eat

    perc_correct_live 199 610 200 100 $times_to_eat
    perc_correct_live 199 610 200 200 $times_to_eat
    perc_correct_live 199 605 200 200 $times_to_eat
    perc_correct_live 199 601 200 200 $times_to_eat
}

even_live () {
    printf "\n${B_CYAN}Testing even numbers - they shouldn't die${RESET}\n\n"
    perc_correct_live 4 410 200 100 $times_to_eat
    perc_correct_live 4 410 200 200 $times_to_eat

    perc_correct_live 50 410 200 100 $times_to_eat
    perc_correct_live 50 410 200 200 $times_to_eat
    perc_correct_live 50 405 200 200 $times_to_eat
    perc_correct_live 50 401 200 200 $times_to_eat

    perc_correct_live 130 410 200 100 $times_to_eat
    perc_correct_live 130 410 200 200 $times_to_eat
    perc_correct_live 130 405 200 200 $times_to_eat
    perc_correct_live 130 401 200 200 $times_to_eat
    
    perc_correct_live 198 410 200 100 $times_to_eat
    perc_correct_live 198 410 200 200 $times_to_eat
    perc_correct_live 198 405 200 200 $times_to_eat
    perc_correct_live 198 401 200 200 $times_to_eat
}

uneven_die () {
    printf "\n${B_CYAN}Testing uneven numbers - one should die${RESET}\n\n"
    perc_correct_die 3 596 200 200 $times_to_eat
    perc_correct_die 3 599 200 200 $times_to_eat
    perc_correct_die 3 600 200 200 $times_to_eat

    perc_correct_die 31 596 200 200 $times_to_eat
    perc_correct_die 31 599 200 200 $times_to_eat
    perc_correct_die 31 600 200 200 $times_to_eat

    perc_correct_die 131 596 200 200 $times_to_eat
    perc_correct_die 131 599 200 200 $times_to_eat
    perc_correct_die 131 600 200 200 $times_to_eat

    erc_correct_die 199 596 200 200 $times_to_eat
    perc_correct_die 199 599 200 200 $times_to_eat
    perc_correct_die 199 600 200 200 $times_to_eat

    perc_correct_die 1 800 200 100 $times_to_eat
}

even_die () {
    printf "\n${B_CYAN}Testing even numbers - one should die${RESET}\n\n"
    perc_correct_die 4 310 200 100 $times_to_eat

    perc_correct_die 50 396 200 200 $times_to_eat
    perc_correct_die 50 399 200 200 $times_to_eat
    perc_correct_die 50 400 200 200 $times_to_eat

    perc_correct_die 130 396 200 200 $times_to_eat
    perc_correct_die 130 399 200 200 $times_to_eat
    perc_correct_die 130 400 200 200 $times_to_eat

    erc_correct_die 198 396 200 200 $times_to_eat
    perc_correct_die 198 399 200 200 $times_to_eat
    perc_correct_die 198 400 200 200 $times_to_eat
}

own_test () {
    read -r -p $'\n\nNumber_of_philosophers:' n_philos
    printf "\n$n_philos"
    read -r -p $'\n\nTime_to_die:' time_to_die
    printf "\n$n_philos $time_to_die"
    read -r -p $'\n\nTime_to_eat:' time_to_eat
    printf "\n$n_philos $time_to_die $time_to_eat"
    read -r -p $'\n\nTime_to_sleep:' time_to_sleep
    printf "\n$n_philos $time_to_die $time_to_eat $time_to_sleep"
    read -r -p $'\n\nNumber_of_times_each_philosopher_must_eat:' number_of_times_each_philosopher_must_eat
    printf "\n$n_philos $time_to_die $time_to_eat $time_to_sleep $number_of_times_each_philosopher_must_eat"
    read -r -n 1 -p $'\n\nShould die?\t[0]\nShouldn\'t die?\t[1]\n' should_die
    clear
    if [ $should_die -eq 0 ]; then
        perc_correct_die $n_philos $time_to_die $time_to_eat $time_to_sleep $number_of_times_each_philosopher_must_eat
    else
        perc_correct_live $n_philos $time_to_die $time_to_eat $time_to_sleep $number_of_times_each_philosopher_must_eat
    fi
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
    printf "${PURPLE}Own tests\t\t\t\t[7]${RESET}\n\n"
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
        7)
            clear
            own_test
            exit 0
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