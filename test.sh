#!/bin/bash
perc=0
test_amount=20


perc_correct_die () {
    count_false=0
    count_correct=0
    for (( i=0; i < $test_amount; i++))  ; do
        lines=$(./philo $1 $2 $3 $4 $5 > test && cat test | grep died)
        exit_status=$(echo $?)
        if (( $exit_status == 0 )) ; then
            echo Damn $lines
            break
            (( count_false++ ))
        else
            echo Yay $lines
            (( count_correct++ ))
        fi
    done
    perc=$(awk -v count="$count_correct" -v tests="$test_amount" 'BEGIN {print 100 / tests * count}')
}

perc_correct_live () {
    count_false=0
    count_correct=0
    for (( i=0; i < $test_amount; i++)) ; do
        lines=$(./philo $1 $2 $3 $4 $5 > test && cat test | grep died)
        exit_status=$(echo $?)
        if (( $lines == 1 )) ; then
            echo Damn $lines
            break
            (( count_false++ ))
        else
            echo Yay $lines
            (( count_correct++ ))
        fi
    done
    perc=$(awk -v count="$count_correct" -v tests="$test_amount" 'BEGIN {print 100 / tests * count}')
}

for (( j=1; j <= $1; j++ )) ; do
    echo "TEST number $j / $1"
    echo "-----------------------------"
    echo "TESTING UNEVEN - LIVE"
    perc_correct_live 5 800 200 200 10 245 # 20 490
    break
    echo "5 800 200 200: $perc % correct"
    perc_correct_live 5 610 200 200 10 245 #20 490
    echo "5 610 200 200: $perc % correct"
    perc_correct_live 199 610 200 200 10 10000 #20 20000
    echo "199 610 200 200: $perc % correct"

    echo "TESTING EVEN - LIVE"
    perc_correct_live 4 410 200 200 10 200 #20 390
    echo "4 410 200 200: $perc % correct"
    perc_correct_live 198 610 200 200 10 10000 #20 20000
    echo "198 610 200 200: $perc % correct"
    perc_correct_live 198 800 200 200 10 10000 #20 20000
    echo "198 610 200 200: $perc % correct"

    echo "TESTING UNEVEN - UNEVEN DIE"
    perc_correct_die 3 599 200 200 10 20
    echo "3 599 200 200: $perc % correct"
    perc_correct_die 31 599 200 200 10 220
    echo "31 599 200 200: $perc % correct"
    perc_correct_die 131 596 200 200 10 920
    echo "131 596 200 200: $perc % correct"

    echo "TESTING UNEVEN - EVEN DIE"
    perc_correct_die 4 310 200 100 10 25
    echo "4 310 200 100: $perc % correct"
    perc_correct_die 1 800 200 100 10 1
    echo "1 800 200 200: $perc % correct"
done