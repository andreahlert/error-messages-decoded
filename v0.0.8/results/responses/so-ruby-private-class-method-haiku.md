# Root Cause

In Ruby, `private`, `protected`, and `public` are **visibility modifiers for instance methods only**. They don't apply to class methods (singleton methods defined with `def self.method_name`).

When you write:
```ruby
class MyClass
  private
  
  def self.my_method
    puts "hello"
  end
end
```

The `private` keyword is ignored because it only affects subsequent instance methods, not class methods.

# Solutions

**1. Use `private_class_method` (most explicit):**
```ruby
class MyClass
  def self.my_method
    puts "hello"
  end
  private_class_method :my_method
end
```

**2. Use the singleton class with `private` block (cleanest):**
```ruby
class MyClass
  class << self
    private
    
    def my_method
      puts "hello"
    end
  end
end
```

**3. Use the newer syntax (Ruby 2.1+):**
```ruby
class MyClass
  private_class_method def self.my_method
    puts "hello"
  end
end
```

The **singleton class approach (#2)** is most idiomatic because it mirrors the instance method pattern and groups all private class methods together visibly.
