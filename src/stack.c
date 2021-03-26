struct stack
{
    int alloc;
    int alloc_size;
    int top;
    int * items;
};

struct stack * newStack(int block_size)
{
    struct stack * pt = malloc(sizeof(struct stack));

    pt->alloc = block_size;
    pt->alloc_size = block_size;
    pt->top = -1;
    pt->items = malloc(block_size * sizeof(int));

    return pt;
}

int stackSize(struct stack * pt)
{
    return pt->top + 1;
}

int isEmpty(struct stack * pt)
{
    return pt->top == -1;
}

void autoSize(struct stack * pt)
{
    if (pt->top + 1 > pt->alloc - 1)
    {
        pt->alloc += pt->alloc_size;
        pt->items = realloc(pt->items, pt->alloc * sizeof(int));
    }
}

void push(struct stack * pt, int x)
{
    autoSize(pt);

    pt->items[++pt->top] = x;
}

int peek(struct stack * pt)
{
    if (!isEmpty(pt))
        return pt->items[pt->top];

    return 0;
}

int pop(struct stack * pt)
{
    autoSize(pt);

    if (isEmpty(pt))
        return 0;

    return pt->items[pt->top--];
}

void pushBottom(struct stack * pt, int x)
{
    autoSize(pt);

    for (int i = ++pt->top; i >= 0; i--)
        pt->items[i] = pt->items[i - 1];
    pt->items[0] = x;
}

int popBottom(struct stack * pt)
{
    autoSize(pt);

    if (isEmpty(pt))
        return 0;

    int ptr = pt->items[0];
    for (int i = 0; i < pt->top; i++)
        pt->items[i] = pt->items[i + 1];
    pt->items[pt->top] = 0;
    if (pt->top > -1)
        --pt->top;

    return ptr;
}
