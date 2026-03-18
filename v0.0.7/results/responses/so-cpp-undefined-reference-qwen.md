The "undefined reference" or "unresolved external symbol" error in C++ typically occurs when a function that was declared in your source code is not linked with the executable file at runtime. This can happen for several reasons:

### Root Cause:
1. **Function Declaration but No Definition**: The function you are trying to call does not have an implementation (definition) in your program.
2. **Missing Header Files or Include Directives**: If a function is declared in one header file, it must be included in the source files where that function is called.
3. **Incorrect Linker Command**: When linking the executable, you might forget to link against certain libraries or include specific headers.

### Steps to Fix:

#### 1. Check Function Declaration:
Ensure that all functions used are declared and defined properly. For example, if a function `calculateSum` is used in multiple files, it should be included in each file where it's called.

```cpp
// In one header file (e.g., main.cpp)
#include "math.h" // Assuming math.h contains the declaration of calculateSum

void calculateSum(int a, int b) {
    return a + b;
}

int main() {
    std::cout << calculateSum(5, 3); // This will work if calculateSum is defined somewhere
}
```

#### 2. Include Necessary Headers:
Make sure all headers that contain declarations of functions you are using are included in your source files.

```cpp
// In one header file (e.g., math.h)
#ifndef MATH_H
#define MATH_H

void calculateSum(int a, int b);

#endif // MATH_H
```

#### 3. Link Against Necessary Libraries:
If the function is part of a library that needs to be linked at runtime, ensure you link against it.

```sh
g++ -o myprogram main.cpp math.h # Ensure math.h is in your include path
```

#### 4. Check for Typos or Incorrect Function Names:
Ensure there are no typos in the function name and that the function exists in the correct file.

#### 5. Use `extern` Keyword:
If a function is declared but not defined, you can declare it as `extern` to avoid errors:

```cpp
// In one header file (e.g., math.h)
#ifndef MATH_H
#define MATH_H

void calculateSum(int a, int b);

#endif // MATH_H

// In another source file (e.g., main.cpp)
#include "math.h"

int main() {
    std::cout << calculateSum(5, 3); // This will work if calculateSum is defined somewhere
}
```

#### 6. Use `#pragma GCC diagnostic push` and `#pragma GCC diagnostic pop`:
If you are using a compiler that supports it (like Clang), you can use these pragmas to suppress warnings:

```cpp
// In one header file (e.g., math.h)
#ifndef MATH_H
#define MATH_H

void calculateSum(int a, int b);

#endif // MATH_H

// Suppress warning for this function
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Werror=unused-function"
void calculateSum(int a, int b) {
    return a + b;
}
#pragma GCC diagnostic pop
```

#### 7. Check Your Build System:
If you are using a build system like CMake or Makefile, ensure that your `CXXFLAGS` and `LDFLAGS` include the necessary libraries.

```sh
# In CMakeLists.txt
cmake_minimum_required(VERSION 3.10)
project(MyProject)

add_executable(myprogram main.cpp math.h)

target_link_libraries(myprogram math) # Ensure math is linked

# Or in Makefile:
CXXFLAGS += -lmath
```

By following these steps, you should be able to resolve the "undefined reference" error and successfully compile your program.
