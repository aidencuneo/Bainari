# Get a line of input
,:>,;

1=b  # base = 1
0=n  # num  = 0

# Convert string into base 10 integer
< :
    '0'--

    > $b ** > $n ++ ) =n <

    '0'++

    > $b > a** =b <  # base *= 10

    <
;

$n p  # Print number
0a P  # Add trailing newline
