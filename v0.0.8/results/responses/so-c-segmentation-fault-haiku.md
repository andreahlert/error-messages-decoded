A **segmentation fault** occurs when your program tries to access memory it shouldn't: unmapped pages, kernel memory, or addresses outside the process's allocated heap/stack.

## Common Root Causes

1. **Null pointer dereference**
   ```c
   int *ptr = NULL;
   printf("%d\n", *ptr);  // segfault
   ```

2. **Buffer overflow**
   ```c
   char buf[10];
   strcpy(buf, "this is way too long");  // overflow, corrupts stack
   ```

3. **Use-after-free**
   ```c
   int *ptr = malloc(sizeof(int));
   free(ptr);
   printf("%d\n", *ptr);  // ptr points to freed memory
   ```

4. **Stack overflow**
   ```c
   void recurse() {
       recurse();  // infinite recursion exhausts stack
   }
   ```

5. **Array out of bounds**
   ```c
   int arr[10];
   arr[100] = 5;  // accessing beyond allocated memory
   ```

## How to Debug

**Use Valgrind** (best for C):
```bash
gcc -g your_program.c -o your_program
valgrind --leak-check=full ./your_program
```
This shows exactly where memory corruption happens.

**Use GDB** (GNU debugger):
```bash
gcc -g your_program.c -o your_program
gdb ./your_program
run
# when it crashes, type: bt (backtrace)
```
Shows the exact line where it crashed.

**Compile with debug flags**:
```bash
gcc -g -O0 -Wall -Wextra your_program.c
```

## Most Common Fix

9 out of 10 times it's **dereferencing a NULL or invalid pointer**. Check:
- Are you initializing pointers before use?
- Are you checking malloc() return values for NULL?
- Are you freeing pointers and then using them?

If you have specific code to share, I can pinpoint it exactly.
