# Root Cause

When you access a non-existent key in a Ruby hash, it returns `nil`. Calling a method on `nil` raises `NoMethodError`:

```ruby
hash[:missing_key].some_method  # => undefined method `some_method' for nil:NilClass
```

# Solutions

**1. Safe Navigation Operator (`&.`)** — Recommended for Ruby 2.3+
```ruby
hash[:key]&.some_method
# Returns nil if :key doesn't exist, otherwise calls the method
```

**2. `dig()` method** — Best for nested hashes
```ruby
hash.dig(:key, :nested, :value)
# Returns nil safely if any key doesn't exist
```

**3. `fetch()` with default**
```ruby
hash.fetch(:key, nil)&.some_method
# Explicitly define what happens if key is missing
```

**4. Explicit nil check**
```ruby
hash[:key]&.some_method if hash.key?(:key)
# Only call if key exists
```

The **safe navigation operator (`&.`)** is the simplest and most idiomatic modern Ruby solution. It short-circuits and returns `nil` if the receiver is `nil`, preventing the error entirely.
