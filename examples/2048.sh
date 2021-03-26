# Stack items are used as function arguments in
# the order that they are taken from the top of
# the stack

# Uppercase variables A, B, C, etc. are function
# return values

# The first item in the stack can be used to tell
# a particular function how many arguments it will
# be receiving from the stack, if that function
# can receive an undefined amount

# Functions are stylised based on Quokka functions
# for readability, for example:
# fun name argmin argmax : retcount

# fun printf 1 *
Fp
    <=A # len
    $A :
        < P
        $A -1+ =A $A
    ;
;

# fun char_mult 2
Fm
    <=A # count
    <=C # char
    $A :
        $C >
        $A -1+ =A $A
    ;
;

# fun represent_number 1
Fr
    <=N

    # 0
    $N
    !?
        '      ' 06 > Fp
    ;

    # 1
    $N -1+
    !?
        ' 2    ' 06 > Fp
    ;

    # 2
    $N -2+
    !?
        ' 4    ' 06 > Fp
    ;

    # 3
    $N -3+
    !?
        ' 8    ' 06 > Fp
    ;

    # 4
    $N -4+
    !?
        ' 61   ' 06 > Fp
    ;

    # 5
    $N -5+
    !?
        ' 23   ' 06 > Fp
    ;

    # 6
    $N -6+
    !?
        ' 46   ' 06 > Fp
    ;

    # 7
    $N -7+
    !?
        ' 821  ' 06 > Fp
    ;

    # 8
    $N -8+
    !?
        ' 652  ' 06 > Fp
    ;

    # 9
    $N -9+
    !?
        ' 215  ' 06 > Fp
    ;

    # 10
    $N -a+
    !?
        ' 4201 ' 06 > Fp
    ;

    # 11
    $N -b+
    !?
        ' 8402 ' 06 > Fp
    ;

    # 12
    $N -c+
    !?
        ' 6904 ' 06 > Fp
    ;

    # 13
    $N -d+
    !?
        ' 2918 ' 06 > Fp
    ;
;

# fun add_score 1
FS
    01=A
    (p 0aP
    1 :
        >
            $A > 2 ** =A
        <
        -1+
    ; <
    $A > $s ++ =s
;

# fun print_game
FP
    0aPP

    # Print score
    ' :erocS' 07 > Fp
    $s p
    0aP

    '-' 0f7 > Fm 0f7 > Fp
    0aP

    # Print the numbers in the boxes

    # Box 1
    '|' < P
    $1 > Fr

    # Box 2
    '|' < P
    $2 > Fr

    # Box 3
    '|' < P
    $3 > Fr
    '|' < P
    0a    P

    # First row fillers
    '|' < P
    '      ' 06 > Fp
    '|' < P
    '      ' 06 > Fp
    '|' < P
    '      ' 06 > Fp
    '|' < P
    0a    P

    '-' 0f7 > Fm 0f7 > Fp
    0aP

    # Box 4
    '|' < P
    $4 > Fr

    # Box 5
    '|' < P
    $5 > Fr

    # Box 6
    '|' < P
    $6 > Fr
    '|' < P
    0a    P

    # Second row fillers
    '|' < P
    '      ' 06 > Fp
    '|' < P
    '      ' 06 > Fp
    '|' < P
    '      ' 06 > Fp
    '|' < P
    0a    P

    '-' 0f7 > Fm 0f7 > Fp
    0aP

    # Box 7
    '|' < P
    $7 > Fr

    # Box 8
    '|' < P
    $8 > Fr

    # Box 9
    '|' < P
    $9 > Fr
    '|' < P
    0a    P

    # Third row fillers
    '|' < P
    '      ' 06 > Fp
    '|' < P
    '      ' 06 > Fp
    '|' < P
    '      ' 06 > Fp
    '|' < P
    0a    P

    '-' 0f7 > Fm 0f7 > Fp
    0aP
;

# fun slide_up
F1
    # if box 4 is full
    $4 ?
        # if box 1 is full
        $1 ?
            # if box 4 == box 1
            $4 > $1 -- !?
                # Merge box 4 and box 1
                $1 1 )> FS < =1
                =4
            ;
        ;

        # if box 1 is not full
        $1 !?
            # Put box 4 into box 1
            $4 =1
               =4
        ;
    ;

    # if box 5 is full
    $5 ?
        # if box 2 is full
        $2 ?
            # if box 5 == box 2
            $5 > $2 -- !?
                # Merge box 5 and box 2
                $2 1 )> FS < =2
                =5
            ;
        ;

        # if box 2 is not full
        $2 !?
            # Put box 5 into box 2
            $5 =2
               =5
        ;
    ;

    # if box 6 is full
    $6 ?
        # if box 3 is full
        $3 ?
            # if box 6 == box 3
            $6 > $3 -- !?
                # Merge box 6 and box 3
                $3 1 )> FS < =3
                =6
            ;
        ;

        # if box 3 is not full
        $3 !?
            # Put box 6 into box 3
            $6 =3
               =6
        ;
    ;

    # if box 7 is full
    $7 ?
        # if box 4 is not full
        $4 !?
            # if box 1 is full
            $1 ?
                # if box 7 == box 1
                $7 > $1 -- !?
                    # Merge box 7 and box 1
                    $1 1 )> FS < =1
                    =7
                ;

                # if box 7 != box 1
                $7 > $4 -- ?
                    # Put box 7 into box 4
                    $7 =4
                       =7
                ;
            ;

            # if box 1 is not full
            $1 !?
                # Put box 7 into box 1
                $7 =1
                   =7
            ;
        ;
    ;

    # if box 8 is full
    $8 ?
        # if box 5 is not full
        $5 !?
            # if box 2 is full
            $2 ?
                # Put box 8 into box 5
                $8 =5
                   =8
            ;

            # if box 2 is not full
            $2 !?
                # Put box 8 into box 2
                $8 =2
                   =8
            ;
        ;
    ;

    # if box 9 is full
    $9 ?
        # if box 6 is not full
        $6 !?
            # if box 3 is full
            $3 ?
                # Put box 9 into box 6
                $9 =6
                   =9
            ;

            # if box 3 is not full
            $3 !?
                # Put box 9 into box 3
                $9 =3
                   =9
            ;
        ;
    ;
;

# fun slide_down
F2

;

# fun slide_left
F3

;

# fun slide_right
F4

;


# Setting up each box in the grid
0=1
0=2
1=3
6=4
0=5
0=6
6=7
0=8
0=9

# Score
0=s

# Number meanings:
# 0 = 0
# 1 = 2
# 2 = 4
# 3 = 8
# 4 = 16
# 5 = 32
# 6 = 64
# 7 = 128
# 8 = 256
# 9 = 512
# 10 = 1024
# 11 = 2048
# 12 = 4096
# 13 = 8192

1 :
    # Print the game board
    FP

    # c = getchar()
    ,=c

    # Check if character matches a valid instruction

    # Quit
    $c 'q' -- !?
        q
    ;

    # Slide up
    $c 'w' -- !?
        F1
    ;

    # Slide down
    $c 's' -- !?
        F2
    ;

    # Slide left
    $c 'a' -- !?
        F3
    ;

    # Slide right
    $c 'd' -- !?
        F4
    ;

    1 # Always repeat the game loop until 'q' is pressed
;
