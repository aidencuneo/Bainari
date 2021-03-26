# Set pointer to 15 (hex)
f

:            # while pointer, do:
    p        #   print integer value of pointer
    > aP <   #   hard push pointer, print '\n', hard pop pointer
    ) !?q; ( #   soft push pointer, if (!pointer) quit, soft pop pointer
    -1+      #   decrement pointer
;            # end
