# Undefined Reference/Unresolved External Symbol - Root Cause & Fixes

## Root Cause
The **linker** can't find the implementation (definition) of a function/variable that your code is trying to use. The compiler found the declaration (in headers), so compilation succeeds, but linking fails because the actual code doesn't exist or isn't reachable.

## Most Common Causes & Fixes

### 1. **Missing Function Implementation**
You declared a function but never defined it.

```cpp
// header.h
void myFunction();  // declaration

// main.cpp
int main() {
    myFunction();  // compiler: "ok, it exists somewhere"
}
// linker: "...but where's the actual code?"
```

**Fix**: Implement the function in a `.cpp` file:
```cpp
// impl.cpp
void myFunction() { /* code */ }
```

---

### 2. **Function/Object Not Compiled Into The Link**
The implementation exists, but the `.cpp` file containing it isn't being compiled/linked.

**Fix**: Ensure the file is in your build system:
- **CMake**: Add it to `add_executable()` or a library target
- **Makefile**: List it in your source files
- **IDE**: Add file to the project

---

### 3. **Library Not Linked**
You're using a library function, but the library isn't linked.

```cpp
// Uses std::string (works, stdlib is linked automatically)
// But uses some_lib::function() and libsomelib.a isn't linked
```

**Fix**: Link the library:
- **CMake**: `target_link_libraries(myapp somelib)`
- **g++/clang**: `g++ main.cpp -lsomelib`
- **MSVC**: Add `.lib` in linker settings

---

### 4. **Wrong Name Mangling / Extern C**
C++ mangles function names; C doesn't. Mixing them causes mismatches.

```cpp
// c_lib.c (compiled as C)
void c_function() { }

// main.cpp (compiled as C++)
void c_function();  // linker looks for "_Z11c_functionv" (mangled)
                    // but library has "c_function" (unmangled)
```

**Fix**: Wrap C declarations:
```cpp
extern "C" {
    void c_function();
}
```

---

### 5. **Template Not Instantiated**
Template implementations must be visible at compile time. If you define templates in `.cpp` files, they won't instantiate.

**Fix**: Define templates in headers or use explicit instantiation in the `.cpp` file:
```cpp
// template.h
template<typename T>
void func(T x);

// template.cpp
template<typename T>
void func(T x) { /* code */ }

// explicit instantiation
template void func<int>(int);
template void func<double>(double);
```

---

### 6. **Circular Dependencies / Order Issues**
Libraries listed in wrong order in linker command.

**Fix**: On Unix-like systems, order matters:
```bash
g++ main.o -lmylib -ldependency  # correct
g++ main.o -ldependency -lmylib  # might fail
```

---

## Quick Debugging Checklist
1. **Search your code** for the function definition (Ctrl+Shift+F)
2. **Check build output** - which `.cpp` files are being compiled?
3. **Verify library paths**: `-L/path/to/lib`, `-l<libname>`
4. **Run linker in verbose mode**: `g++ -v` or `--verbose` to see what's linked
5. **Use `nm` to inspect**: `nm libmylib.a | grep myfunction`

What's the specific error message and your build setup (CMake, Makefile, IDE)?
