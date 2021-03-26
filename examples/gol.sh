# Game of Life
#
# Author: Aiden Blishen Cuneo
# (Only this implementation, Game of Life was invented by John Conway)

# Game board will be stored in the stack, and a dead cell will be 1, while a
# living cell will be 2, and the end of the game board will be 0.

5=w # Width (42) # aaaa2
     # Height will be infinite

# fun printf 1 *
Fp
    <=A # len
    $A :
        < P
        $A -1+ =A $A
    ;
;

# fun display
Fd
    0aP # Leading newline

    < : # Loop over the game board, which is stored in the stack
        =p
        $p -1+ !?
            ' ' <P
        ;
        $p -2+ !?
            'O' <P
        ;
        <
    ;

    0aP # Trailing newline
;

' :htdiW' 7 > Fp
$w p
0aP

0
1]1]1]2]1]2]2]1]1]1]2]2]2]2]1]1]1]2]1]

Fd
