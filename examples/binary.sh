,:>,;

1=b  # base = 1
0=n  # num  = 0

# Convert string into base 2 integer
< :
    '0'--

    > $b ** > $n ++ ) =n <  # num += base * ptr

    $b > 2** =b  # base *= 2

    <
;

$n p  # Print number
