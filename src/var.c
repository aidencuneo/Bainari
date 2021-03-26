int charCount(char * st, char ch)
{
    int count = 0;

    for (int i = 0; st[i]; i++)
        if (st[i] == ch)
            count++;

    return count;
}

char * readfile(char * fname)
{
    char * buffer;
    long length;

    FILE * f = fopen(fname, "rb");

    if (!f) return 0;

    fseek(f, 0, SEEK_END);
    length = ftell(f);
    fseek(f, 0, SEEK_SET);

    if (!length)
    {
        fclose(f);
        return 0;
    }

    buffer = malloc(length);
    strcpy(buffer, "");

    if (buffer)
        fread(buffer, 1, length, f);

    fclose(f);

    buffer = realloc(buffer, length + 1);
    buffer[length] = '\0';

    return buffer;
}
