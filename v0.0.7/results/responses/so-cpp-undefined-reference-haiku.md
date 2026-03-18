## Root Cause

An **undefined reference** error means the linker can't find the **definition** of a function you're calling. Your code compiles because the compiler sees the declaration (the function signature), but the linker fails because it can't locate the actual implementation.

**Key distinction:**
- **Declaration**: tells the compiler a function exists (usually in a header file)
- **Definition**: the actual implementation of the function (must exist somewhere)

## Common Causes & Fixes

### 1. **Missing Implementation File in Linker Input**
You declared the function but didn't compile/link its `.cpp` file.

```cpp
// header.h
void myFunction();

// mylib.cpp
void myFunction() { /* ... */ }

// main.cpp
int main() {
    myFunction(); // Error if mylib.cpp not linked
}
```

**Fix:** Include the `.cpp` file in your build:
- Add to Makefile/CMakeLists.txt
- Add to Visual Studio project
- Pass to compiler: `g++ main.cpp mylib.cpp -o program`

### 2. **Function Not Defined, Only Declared**
You declared it in a header but forgot to implement it.

```cpp
// header.h
void myFunction();  // declaration only

// main.cpp uses it, but no .cpp file implements it
```

**Fix:** Implement the function in a `.cpp` file.

### 3. **Wrong Library Not Linked**
You're using a function from an external library that isn't linked.

```cpp
#include <some_lib.h>
// Calls function from some_lib
```

**Fix:** Link the library:
- `g++ main.cpp -o program -lsomelib`
- CMake: `target_link_libraries(myapp somelib)`
- Visual Studio: add library to linker input

### 4. **Name Mangling Mismatch** (C++ only)
You declared a C function as C++ or vice versa.

```cpp
// header.h
void cFunction();  // treated as C++ (mangled name)

// lib.c
void cFunction() { }  // compiled as C (unmangled name)
```

**Fix:** Use `extern "C"`:
```cpp
extern "C" {
    void cFunction();
}
```

### 5. **Symbol Hidden by Namespace**
Function defined in a namespace but called without it.

```cpp
namespace myns {
    void func() { }
}

// main.cpp
void func();  // declares different function
func();       // undefined
```

**Fix:** Use fully qualified name or `using`:
```cpp
myns::func();
// or
using myns::func;
func();
```

## Quick Debugging Checklist

1. **Check your build command** - are all `.cpp` files being compiled?
2. **Check your linker flags** - are required libraries linked? (`-l` flags, `target_link_libraries()`)
3. **Check the function exists** - search for the implementation in your source
4. **Check for typos** - mismatched function names or signatures
5. **Check namespaces** - is the function in a different namespace?
6. **Check `extern "C"`** - mixing C and C++ code?

Look at your **full linker error message** - it usually shows the exact symbol name the linker can't find, which helps identify namespace or mangling issues.
