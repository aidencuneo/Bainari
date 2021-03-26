#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "bainari.h"

#include "stack.c"
#include "varlist.c"
#include "var.c"

char * current_file;
char * buffer = 0;

// Current index in the script
int fileIndex = 0;

// FILE *  file_descriptor;

struct stack * stack;
// struct varlist * varlist;
int ptr0 = 0;
int ptr1 = 0;
int ptr2 = 0;

// CLI Options
int minify = 0;
int verbose = 0;

void error(char * text, char * buffer, int pos)
{
    // int MAXLINE = 128;

    printf("\nProgram execution terminated:\n\n");

    if (buffer == NULL || pos < 0)
    {
        printf("(At %s)\n", current_file);
    }
    else
    {
        char * linepreview = malloc(5 + 1);
        linepreview[0] = buffer[pos - 2];
        linepreview[1] = buffer[pos - 1];
        linepreview[2] = buffer[pos];
        linepreview[3] = buffer[pos + 1];
        linepreview[4] = buffer[pos + 2];
        linepreview[5] = 0;

        printf("At %s : Pos %d\n\n", current_file, pos);
        printf("> {{ %s }}\n\n", linepreview);

        free(linepreview);
    }

    printf("Error: %s\n\n", text);

    quit(1);
}

char * minify_code(char * code)
{
    int len = strlen(code);
    char * min = malloc(len + 1);
    min[0] = 0;
    int ind = 0;

    for (int i = 0; i < len; i++)
        if (code[i] == '0' || code[i] == '1')
            min[ind++] = code[i];

    min[ind] = 0;
    return min;
}

void quit(int code)
{
    free(stack->items);
    free(stack);

    // free(varlist->names);
    // free(varlist->values);
    // free(varlist);

    free(buffer);

    exit(code);
}

void run_instruction(int instPtr)
{
    // instPtr tells this function which pointer should be used as the opcode

    int opcode, arg;

    if (instPtr)
    {
        opcode = ptr1;
        arg = ptr0;
    }
    else
    {
        opcode = ptr0;
        arg = ptr1;
    }

    // opcode is now the operation code to perform, and arg is the argument
    // that will be used with the operation

    if (verbose)
        printf("OPCODE: %d\n", opcode);

    // (0) Set arg pointer to 0
    if (opcode == 0)
    {
        if (instPtr)
            ptr0 = 0;
        else
            ptr1 = 0;
    }

    // (1) Do nothing (this is required for most programs, trust me)

    // (2) Push arg to the stack
    else if (opcode == 2)
        push(stack, arg);

    // (3) Set the arg pointer to the next stack item
    else if (opcode == 3)
    {
        if (instPtr)
            ptr0 = pop(stack);
        else
            ptr1 = pop(stack);
    }

    // (4) Go back arg letters
    else if (opcode == 4)
        fileIndex -= arg;

    // (5) Go back arg letters if the next stack item is not zero
    else if (opcode == 5)
        fileIndex -= arg * !!pop(stack);

    // (6) Kill the program with arg as the exit code
    else if (opcode == 6)
        quit(arg);

    // (7) Print the integer value of arg
    else if (opcode == 7)
        printf("%d", arg);

    // (8) Print arg as a character
    else if (opcode == 8)
        printf("%c", arg);

    // (9) Add arg to ptr2 (ptr2 += arg)
    else if (opcode == 9)
        ptr2 += arg;

    // (10) Subtract the next stack item from arg (arg -= pop(stack))
    else if (opcode == 10)
    {
        if (instPtr)
            ptr0 -= pop(stack);
        else
            ptr1 -= pop(stack);
    }

    // (11) Multiply the next stack item with arg (arg *= pop(stack))
    else if (opcode == 11)
    {
        if (instPtr)
            ptr0 *= pop(stack);
        else
            ptr1 *= pop(stack);
    }

    // (12) Divide arg into the next stack item (arg /= pop(stack))
    else if (opcode == 12)
    {
        if (instPtr)
            ptr0 /= pop(stack);
        else
            ptr1 /= pop(stack);
    }

    // (13) Swap ptr2 and arg
    // else if (opcode == 14)
    // {
    //     int temp = ptr2;
    //     ptr2 = arg;

    //     if (instPtr)
    //         ptr0 = temp;
    //     else
    //         ptr1 = temp;
    // }
}

int main(int argc, char ** argv)
{
    char ** args = malloc(argc * sizeof(char *));
    int newargc = 0;

    for (int i = 1; i < argc; i++)
    {
        if (!strcmp(argv[i], "-v") || !strcmp(argv[i], "--version"))
        {
            printf("Char %s\n", VERSION);
            free(args);
            return 0;
        }
        if (!strcmp(argv[i], "-m") || !strcmp(argv[i], "--minify"))
            minify = 1;
        if (!strcmp(argv[i], "-V") || !strcmp(argv[i], "--verbose"))
            verbose = 1;
        else
        {
            args[newargc] = argv[i];
            newargc++;
        }
    }

    if (!newargc)
        return 0;

    current_file = args[0];

    long length;
    FILE * f = fopen(current_file, "rb");

    if (!f)
    {
        printf("File at path '%s' does not exist or is not accessible\n", current_file);
        return 1;
    }

    fseek(f, 0, SEEK_END);
    length = ftell(f);
    fseek(f, 0, SEEK_SET);
    buffer = malloc(length);
    if (buffer)
        fread(buffer, 1, length, f);
    fclose(f);

    if (!buffer)
        return 0;

    if (minify)
    {
        char * minified = minify_code(buffer);

        printf("%s\n", minified);

        free(minified);
        free(buffer);

        return 0;
    }

    free(args);

    // Interpreter vars
    stack = newStack(512); // Block size is 256
    // (Pointers are also global but are not defined here)

    // Previous instructions (0 or 1)
    int secondLastInst = -1;
    int lastInst = -1;

    // (fileIndex is global)
    for (fileIndex = 0; fileIndex < length; fileIndex++)
    {
        char ch = buffer[fileIndex];

        if (verbose && (ch == '0' || ch == '1'))
        {
            printf("[%c] ptr0: %d, ptr1: %d, [", ch, ptr0, ptr1);

            for (int a = 0; a < stack->top + 1; a++)
                printf("%d,", stack->items[a]);

            if (stack->top + 1)
                printf("\b");

            printf("]\n");
        }

        if (ch == '0')
        {
            // 000 was found
            if (!(secondLastInst || lastInst))
            {
                // Take away 2 from ptr0 to counter what happens due to 000
                // executing as two ptr0 additions
                ptr0 -= 2;

                run_instruction(0);

                // Reset ptr0 to 0
                ptr0 = 0;

                secondLastInst = lastInst;
                lastInst = -1;
                continue;
            }

            // Otherwise, handle instruction normally and set lastInst to 0
            ++ptr0;
            secondLastInst = lastInst;
            lastInst = 0;
        }

        else if (ch == '1')
        {
            // 111 was found
            if (secondLastInst == 1 && lastInst == 1)
            {
                // Take away 2 from ptr1 to counter what happens due to 111
                // executing as two ptr1 additions
                ptr1 -= 2;

                run_instruction(1);

                // Reset ptr1 to 0
                ptr1 = 0;

                secondLastInst = lastInst;
                lastInst = -1;
                continue;
            }

            // Otherwise, handle instruction normally and set lastInst to 1
            ++ptr1;
            secondLastInst = lastInst;
            lastInst = 1;
        }
    }

    quit(0);

    return 0;
}
