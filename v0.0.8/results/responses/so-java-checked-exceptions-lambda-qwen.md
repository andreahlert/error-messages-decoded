The error you're encountering typically occurs when a checked exception is thrown inside a lambda expression or within an `if` statement that evaluates to `true`. In Java, unchecked exceptions can be caught using try-catch blocks, but checked exceptions must be explicitly handled by the caller of the method.

### Root Cause:
- **Checked Exceptions**: These are exceptions that need to be declared in your class's methods. They cannot be thrown directly from within a lambda expression or an `if` statement.
  
  ```java
  public void someMethod() throws IOException {
      if (someCondition()) {
          throw new IOException("Some error occurred");
      }
  }

  // This will cause a compile-time error because IOException is checked and needs to be declared in the method signature.
  ```

- **Unchecked Exceptions**: These are exceptions that can be caught using try-catch blocks. They do not need to be declared in your class's methods.

### How to Fix It:
1. **Declare Checked Exceptions Explicitly**:
   - If you want to handle checked exceptions, declare them explicitly in the method signature.
   
   ```java
   public void someMethod() throws IOException {
       if (someCondition()) {
           throw new IOException("Some error occurred");
       }
   }

   // This is fine because IOException is declared as a checked exception.
   ```

2. **Use Try-Catch Blocks**:
   - If you want to catch and handle the checked exceptions, use try-catch blocks.

   ```java
   public void someMethod() {
       if (someCondition()) {
           throw new IOException("Some error occurred");
       }
   }

   // This is fine because IOException can be caught using a try-catch block.
   ```

3. **Use `Optional` for Nullable Values**:
   - If you're dealing with nullable values and want to handle them without throwing checked exceptions, use `Optional`.

   ```java
   public void someMethod() {
       Optional.ofNullable(someValue).ifPresentOrElse(
           value -> { /* do something */ },
           () -> System.out.println("Some error occurred")
       );
   }

   // This is fine because the exception can be caught using an if statement.
   ```

4. **Use `Optional` for Nullable Values in Lambdas**:
   - If you're dealing with nullable values and want to handle them without throwing checked exceptions, use `Optional`.

   ```java
   public void someMethod() {
       Optional.ofNullable(someValue).ifPresentOrElse(
           value -> { /* do something */ },
           () -> System.out.println("Some error occurred")
       );
   }

   // This is fine because the exception can be caught using an if statement.
   ```

### Example:
```java
public class Main {
    public static void main(String[] args) {
        List<String> list = Arrays.asList("apple", "banana", null, "cherry");

        // Using Optional to handle nullable values without throwing checked exceptions.
        list.stream()
            .filter(s -> s != null)
            .map(s -> s.toUpperCase())
            .forEach(System.out::println);
    }
}
```

### Conclusion:
- **Declare Checked Exceptions Explicitly**: If you want to handle the exception, declare it in your method signature.
- **Use Try-Catch Blocks**: If you want to catch and handle the exception, use try-catch blocks.

By following these guidelines, you can effectively manage checked exceptions within Java 8 streams/lambdas.
