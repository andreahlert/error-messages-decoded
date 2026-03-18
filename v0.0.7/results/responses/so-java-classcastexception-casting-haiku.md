## Root Cause

You're trying to cast an `Animal` object to `Dog` when the actual object is **not** an instance of `Dog`. At compile time, Java allows this syntax because `Dog` is a subclass of `Animal`. At runtime, the JVM checks if the object actually *is* a `Dog` — if it's not, it throws `ClassCastException`.

**Example of the problem:**
```java
Animal animal = new Animal();  // actual instance is Animal
Dog dog = (Dog) animal;        // ClassCastException — animal is not a Dog
```

## Fix

**Check the type before casting** using `instanceof`:

```java
Animal animal = getAnimal();  // could be Animal, Dog, Cat, etc.

if (animal instanceof Dog) {
    Dog dog = (Dog) animal;
    // safely use dog
}
```

**Java 16+ pattern matching** (cleaner):
```java
if (animal instanceof Dog dog) {
    // dog is already cast and available here
}
```

## Key Point

Casting only works when the actual runtime object **is** an instance of the target class. Subclass ← Superclass casting requires the object to already be that subclass, not just compatible at compile time.
