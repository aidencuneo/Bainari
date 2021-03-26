struct varlist
{
    char * names;
    int * values;
    int size;

    int alloc;
    int alloc_size;
};

struct varlist * newVarlist(int block_size)
{
    struct varlist * self = malloc(sizeof(struct varlist));

    self->names = malloc(block_size);
    self->values = malloc(block_size * sizeof(int));
    self->size = 0;

    self->alloc = block_size;
    self->alloc_size = block_size;

    return self;
}

void varlistResize(struct varlist * self)
{
    if (self->size > self->alloc - 1)
    {
        self->alloc += self->alloc_size;
        self->names = realloc(self->names, self->alloc);
        self->values = realloc(self->values, self->alloc * sizeof(int));
    }
}

void varlistAdd(struct varlist * self, char name, int value)
{
    varlistResize(self);

    int ind = self->size;

    for (int i = 0; i < self->size; i++)
        if (self->names[i] == name)
        {
            ind = i;
            break;
        }

    self->names[ind] = name;
    self->values[ind] = value;

    ++self->size;
}

// Get an item from a varlist, but return a
// specified default value if not found
int varlistGetDef(struct varlist * self, char name, int def)
{
    if (self->size <= 0)
        return def;

    for (int i = 0; i < self->size; i++)
        if (self->names[i] == name)
            return self->values[i];

    return def;
}

int varlistGet(struct varlist * self, char name)
{
    return varlistGetDef(self, name, 0);
}
