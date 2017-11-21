fg() {
    (( $# == 3 )) || return 1
    printf "\x1b[38;2;%d;%d;%dm\n" $1 $2 $3
}

bg() {
    (( $# == 3 )) || return 1
    printf "\x1b[48;2;%d;%d;%dm\n" $1 $2 $3
}
t() {
    echo $1
}

t 1,2,3
fg 150 50 50
bg 50 240 30
echo test
printf "\x1b[0m\n"
