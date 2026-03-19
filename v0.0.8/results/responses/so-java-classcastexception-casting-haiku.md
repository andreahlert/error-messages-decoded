## Root Cause

In Java, you can only cast an object **down** the inheritance hierarchy if that object was **actually created as** the target subclass. If you create an `Animal` instance and try to cast it to `Dog`, it fails because the object's runtime type is `Animal`, not `Dog`.

```java
Animal animal = new Animal();  // Runtime type: Animal
Dog dog = (Dog) animal;        // ClassCastException - animal is NOT a Dog
```

The JVM performs a runtime type check. The cast only succeeds if the actual object is an instance of (or a subclass of) the target type.

## How to Fix

**Option 1: Create the correct type from the start**
```java
Dog dog = new Dog();  // Correct - create a Dog, not an Animal
```

**Option 2: Check the type before casting (instanceof)**
```java
Animal animal = getAnimal();  // Returns either Dog or Cat

if (animal instanceof Dog) {
    Dog dog = (Dog) animal;  // Safe - we know it's a Dog
}
```

**Option 3: Use polymorphism instead of casting**
```java
// Instead of casting to access Dog-specific methods
animal.makeSound();  // Call common method on Animal interface/abstract class

// Design your classes so subclass-specific behavior goes through overridden methods
```

**Option 4: Cast to the actual type**
```java
// If animal is actually a Dog, cast correctly:
Dog dog = (Dog) animal;  // Only if animal was created as new Dog()
```

## Best Practice

Use `instanceof` before casting (Java 16+ pattern matching):
```java
if (animal instanceof Dog dog) {
    dog.dogSpecificMethod();  // Type-safe, no redundant cast
}
```

The exception exists to protect you from accessing methods that don't exist on the actual runtime object.
