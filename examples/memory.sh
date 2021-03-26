# See code_styling.txt for code styling information

# `0 @c` will be used to count the number of objects in memory, because the
# number of zeroes in the stack should always be the same as the number of
# objects in memory

# fun memset 0 : 1
Fs
    0 @c =A # Return the old number of objects in memory, because this number
          # will become the memory index of the added memory
    # Add a null byte to the end of the stack
    0 >
;

# fun memget 1
Fg
    <=A # Memory index to search for
    0 @c =B # Current memory index
    $@ -1+ =C # Old stack top

    0=D # (bool) Found the right memory index?
    0=E # (bool) Break the loop now?

    # This loop won't pop from the stack at any point in time, it will only
    # decrement the stack's top until it reaches 0, then it will return the
    # stack's top back to what it was before

    # Decrement the stack's top to begin with (to get past the first null byte)
    $@ -2+ @s
    # Also decrement current memory index to account for the line above
    $B -1+ =B

    # If current memory index is ALREADY equal to the index to search for, then
    # this is the right object
    $B r1 $A -- !?
        1=D
    ;

    ( 1 :
        # Do a fancy thing to prevent the loop from stopping at 0
        -1+
        =c

        # $c p 0aP

        # If this is the right memory object, then retrieve it
        $D ?
        $c ? # (only if this character isn't 0)

            # This code segment will temporarily reset the stack's top, then
            # append this character to the top of the normal stack, then return
            # the stack's top back to the slowly decrementing one
            $@ -1+ =S
            $C @s

            $c >

            $S @s
            $C 1 =C

        ;;

        # If 0 was found
        $c !?
            # If the right memory index has already been found, then this 0
            # should break the loop
            $D ?
                1=E
            ;

            # Otherwise, continue searching
            $D !?
                # Decrement current memory index
                $B -1+ =B

                # If current memory index is equal to the index to search for,
                # then this is the right object
                $B r1 $A -- !?
                    1=D
                ;
            ;
        ;

        # Decrement stack top by 1
        $@ -2+ @s

        # Do a fancy thing to prevent the loop from stopping at 0 (as long as
        # the stack length isn't 0 AND the loop isn't mean to break now)
        $@ ?
        $E !?
            ( 1
        ;;
    ;

    # Reset the stack's top to the old stack top
    $C @s
;

# fun memdel 1
Fd
    <=A # Memory index to delete
    0 @c =B # Current memory index
    $@ -1+ =C # Old stack top

    0=D # (bool) Found the right memory index?
    0=E # (bool) Break the loop now?

    # This loop won't pop from the stack at any point in time, it will only
    # decrement the stack's top until it reaches 0, then it will return the
    # stack's top back to what it was before

    # Decrement the stack's top to begin with (to get past the first null byte)
    $@ -2+ @s
    # Also decrement current memory index to account for the line above
    $B -1+ =B

    # If current memory index is ALREADY equal to the index to delete, then
    # this is the right object
    $B r1 $A -- !?
        1=D
    ;

    ( 1 :
        # Do a fancy thing to prevent the loop from stopping at 0
        -1+
        =c

        # $c p 0aP

        # If this is the right memory object, then delete it
        $D ?
        $c ? # (only if this character isn't 0)
            # Replace the memory object with dead memory
            <
            # INT_MAX
            0 ff2 r1 2 ** ** ** ** ** ** -1+
            >
        ;;

        # If 0 was found
        $c !?
            # If the right memory index has already been found, then this 0
            # should break the loop
            $D ?
                1=E
            ;

            # Otherwise, continue searching
            $D !?
                # Decrement current memory index
                $B -1+ =B

                # If current memory index is equal to the index to delete,
                # then this is the right object
                $B r1 $A -- !?
                    1=D
                ;
            ;
        ;

        # Decrement stack top by 1
        $@ -2+ @s

        # Do a fancy thing to prevent the loop from stopping at 0 (as long as
        # the stack length isn't 0 AND the loop isn't mean to break now)
        $@ ?
        $E !?
            ( 1
        ;;
    ;

    # Reset the stack's top to the old stack top
    $C @s
;

'hello' Fs $A p
0aP
'hellooo' Fs $A p
0aP
"I'm also here" Fs $A p
0aP
"Don't forget about me" Fs $A p
0aP
'hiii' Fs $A p
0aP

# Get the array back
00 > Fg
<:P<; > 0aP
01 > Fg
<:P<; > 0aP
02 > Fg
<:P<; > 0aP

03 > Fd

03 > Fg
<:P<; > 0aP
04 > Fg
<:P<; > 0aP

0 -1+ ]

< 1 :
    -1+
    P
    < 1
;

0aP
