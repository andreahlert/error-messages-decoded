A **segmentation fault** occurs when your program tries to access memory it doesn't own or that's invalid. The kernel terminates it to prevent corruption.

## Common causes:

1. **Dereferencing NULL or invalid pointer**
   ```c
   int *ptr = NULL;
   *ptr = 5;  // Seg fault
   ```

2. **Buffer overflow** - Writing past allocated memory
   ```c
   char buf[10];
   strcpy(buf, "this is way too long");  // Overflows
   ```

3. **Use-after-free** - Accessing freed memory
   ```c
   int *ptr = malloc(sizeof(int));
   free(ptr);
   *ptr = 5;  // Seg fault
   ```

4. **Stack overflow** - Infinite recursion or huge local arrays
   ```c
   void recursive() { recursive(); }  // No base case
   ```

5. **Uninitialized pointers**
   ```c
   int *ptr;
   *ptr = 5;  // ptr contains garbage
   ```

## How to debug:

1. **Run with GDB** (debugger)
   ```bash
   gdb ./program
   (gdb) run
   (gdb) bt  # backtrace to see where it crashed
   ```

2. **Add debugging symbols** when compiling
   ```bash
   gcc -g program.c -o program
   ```

3. **Use Valgrind** (memory error detector)
   ```bash
   valgrind --leak-check=full ./program
   ```

4. **Enable Address Sanitizer**
   ```bash
   gcc -fsanitize=address program.c -o program
   ```

## Quick fixes:

- Check all pointer dereferences before use
- Validate array bounds before access
- Free memory only once; set pointers to NULL after free
- Use `malloc()` before dereferencing pointers
- Add null checks: `if (ptr != NULL) { ... }`

Share your code if you need help pinpointing the exact issue.
