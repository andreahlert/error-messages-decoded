# Ruby Backtrace Truncation

**Root Cause**: Ruby automatically truncates exception backtraces to keep them readable. By default, it shows only the first 16 and last 16 stack frames, replacing the middle with `...`.

**How to Fix**:

## 1. **Increase the limit globally** (recommended)
```ruby
# In your code before the exception occurs
Exception.limit_backtrace = 1000  # or any large number

begin
  # your code
rescue => e
  puts e.backtrace
end
```

## 2. **Print full backtrace in rescue blocks**
```ruby
begin
  # your code
rescue => e
  puts e.backtrace.join("\n")  # prints all frames
end
```

## 3. **Via environment variable**
```bash
RUBY_DEBUG_BACKTRACE=1 ruby your_script.rb
```

Or use the `--verbose` flag:
```bash
ruby -v your_script.rb
```

## 4. **Using backtrace_locations for more detail**
```ruby
begin
  # your code
rescue => e
  e.backtrace_locations.each { |loc| puts loc }
end
```

## For Tests/Debugging
If you're using a framework like RSpec or Minitest:
```bash
# Show full backtraces in test output
rspec --backtrace  # or
ruby -w your_test.rb
```

The **simplest fix** is setting `Exception.limit_backtrace = 1000` early in your application, or just print with `e.backtrace.join("\n")` in your rescue block to see everything.
