#!/bin/bash
perc=0
test_amount=20

if [ "$#" -gt 1 ]; then
	printf "Invalid input!\n"
	exit
elif [ "$#" -lt 1 ]; then
	set $1 10
fi

perc_correct_die () {
    count_false=0
    count_correct=0
    for (( i=0; i < $test_amount; i++))  ; do
        printf "$i\t"
        lines=$(./philo $1 $2 $3 $4 $5 > test && cat test | grep died)
        exit_status=$(echo $?)
        if (( $exit_status ==  1 )) ; then
            printf "${ERROR_COLOR}Damn${NO_COLOR} $lines\t"
            printf "${ERROR_COLOR}[x]${NO_COLOR}\n"
            break
            (( count_false++ ))
        else
            printf "${OK_COLOR}Yay${NO_COLOR} $lines\t"
            printf "${OK_COLOR}[✓]${NO_COLOR}\n"
        fi
    done
    perc=$(awk -v count="$count_correct" -v tests="$test_amount" 'BEGIN {print 100 / tests * count}')
}

perc_correct_live () {
    count_false=0
    count_correct=0
    for (( i=0; i < $test_amount; i++)) ; do
        printf "$i\t"
        lines=$(./philo $1 $2 $3 $4 $5 > test && cat test | grep died)
        exit_status=$(echo $?)
        if (( $exit_status == 0 )) ; then
            printf "${ERROR_COLOR}Damn${NO_COLOR} $lines\t"
            printf "${ERROR_COLOR}[x]${NO_COLOR}\n"
            break
            (( count_false++ ))
        else
            printf "${OK_COLOR}Yay${NO_COLOR} $lines\t"
            printf "${OK_COLOR}[✓]${NO_COLOR}\n"
        fi
    done
    perc=$(awk -v count="$count_correct" -v tests="$test_amount" 'BEGIN {print 100 / tests * count}')
}

for (( j=1; j <= $1; j++))
do
    printf "${OBJ_COLOR}Testing uneven numbers - they shouldn't die${NO_COLOR}\n"
    printf "${WARN_COLOR}5 800 200 200${NO_COLOR} (10)\n"
    perc_correct_live 5 800 200 200 10 245 # 20 490
	printf "$perc %% correct\n"
	printf "______________________\n"
    printf "${WARN_COLOR}5 610 200 200${NO_COLOR} (10)\n"
    perc_correct_live 5 610 200 200 10 245 #20 490
    printf "$perc %% correct\n"
	printf "______________________\n"
    printf "${WARN_COLOR}199 610 200 200${NO_COLOR} (10)\n"
    perc_correct_live 199 610 200 200 10 10000 #20 20000
    printf "$perc %% correct\n"
	printf "______________________\n"

    printf "${OBJ_COLOR}Testing even numbers - they shouldn't die${NO_COLOR}\n"
    printf "${WARN_COLOR}4 410 200 200${NO_COLOR} (10)\n"
    perc_correct_live 4 410 200 200 10 200 #20 390
    printf "$perc %% correct"
	printf "______________________"
    printf "${WARN_COLOR}198 610 200 200${NO_COLOR} (10)\n"
    perc_correct_live 198 610 200 200 10 9800 #20 20000
    printf "$perc %% correct"
	printf "______________________"
    printf "${WARN_COLOR}198 610 200 200${NO_COLOR} (10)\n"
    perc_correct_live 198 800 200 200 10 10000 #20 20000
    printf "$perc %% correct"
	printf "______________________"

    printf "${OBJ_COLOR}Testing even numbers - one should die${NO_COLOR}\n"
    printf "3 599 200 200 (10)"
    perc_correct_die 3 599 200 200 10 20
	printf "$perc %% correct"
	printf "______________________"
    printf "31 599 200 200"
    perc_correct_die 31 599 200 200 10 220
    printf "$perc %% correct"
	printf "______________________"
    printf "131 596 200 200"
    perc_correct_die 131 596 200 200 10 920
    printf "$perc %% correct"
	printf "______________________"

    printf "${OBJ_COLOR}Testing uneven numbers - one should die${NO_COLOR}\n"
    printf "4 310 200 100"
    perc_correct_die 4 310 200 100 10 25
    printf "$perc %% correct"
	printf "______________________"
    printf "1 800 200 200"
    perc_correct_die 1 800 200 100 10 1
    printf "$perc %% correct"
	printf "______________________"
done