# RSpec: Allow, Receive, and Argument Matching

Welcome to Lesson 17! In this lesson, we're going to unlock the magic of stubbing and spying in RSpec. You'll learn how to use `allow(...).to receive` to stub methods, set return values, and use argument matchers to control and verify how your code interacts with its dependencies. These tools are essential for isolating your tests, making them faster, and ensuring your code behaves as expected—even when it depends on other objects, services, or APIs. We'll break down each concept, show you lots of examples, and give you practice prompts to reinforce your learning.

---

## What is Stubbing?

**Stubbing** means telling an object to "pretend" to respond to a method in a certain way. This is super useful when you want to:

- Avoid calling real methods (which might be slow, unpredictable, or have side effects)
- Control what a method returns
- Test code in isolation

Think of it like this:

```zsh
method call
    ↓
  stub
    ↓
return value
```

---

## Stubbing with `allow(...).to receive`

The most common way to stub a method in RSpec is with `allow(...).to receive`. This lets you control what a method returns, without calling the real implementation.

### Basic Example

Here’s how you can stub a method on a double:

```ruby
# /spec/allow_receive_spec.rb
RSpec.describe "allow(...).to receive" do
  it "stubs a method" do
    user = double("User")
    allow(user).to receive(:admin?).and_return(true)
    expect(user.admin?).to be true
  end
end
```

In this example, we create a double called "User" and tell it to respond to `admin?` with `true`. When we call `user.admin?`, it returns `true`—no real User class needed!

Run this file with `rspec /spec/allow_receive_spec.rb` to see the stub in action.

**Example Output:**

```zsh
allow(...).to receive
  stubs a method

Finished in 0.00123 seconds (files took 0.12345 seconds to load)
1 example, 0 failures
```

---

## Setting Return Values

You can control what a stubbed method returns, even based on the arguments passed in. This is helpful for simulating different scenarios in your tests.

### Example: Stubbing with Arguments

Here, we stub a method to return a value only for specific arguments:

```ruby
# /spec/return_values_spec.rb
RSpec.describe "Return Values" do
  it "sets a return value" do
    calc = double("Calculator")
    allow(calc).to receive(:add).with(2, 2).and_return(4)
    expect(calc.add(2, 2)).to eq(4)
  end
end
```

Try running this file with `rspec /spec/return_values_spec.rb` to see the stub in action.

### Example: Stubbing Multiple Return Values

You can stub the same method with different arguments and return values:

```ruby
# /spec/return_values_spec.rb
calc = double("Calculator")
allow(calc).to receive(:add).with(1, 1).and_return(2)
allow(calc).to receive(:add).with(2, 2).and_return(4)
expect(calc.add(1, 1)).to eq(2)
expect(calc.add(2, 2)).to eq(4)
```

Run this code and see what happens if you call `calc.add(3, 3)` (hint: it returns nil).

### Example: Returning Different Values on Each Call

You can also return a sequence of values for multiple calls to a stubbed method, which simulates changing state over time:

```ruby
# /spec/return_values_spec.rb
counter = double("Counter")
allow(counter).to receive(:next).and_return(1, 2, 3)
expect(counter.next).to eq(1)
expect(counter.next).to eq(2)
expect(counter.next).to eq(3)
```

Run this file with `rspec /spec/return_values_spec.rb` to see the sequence in action.

---

## Argument Matchers

Argument matchers let you stub or verify methods regardless of the exact arguments. This is great when you care about the method being called, but not the specific values.

### Example: any_args

You can match any arguments passed to a method:

```ruby
# /spec/argument_matchers_spec.rb
RSpec.describe "Argument Matchers" do
  it "matches any arguments" do
    logger = double("Logger")
    allow(logger).to receive(:log).with(any_args)
    logger.log("info", "message")
    expect(logger).to have_received(:log)
  end
end
```

Run this file with `rspec /spec/argument_matchers_spec.rb` to see how any_args works.

### Example: anything

You can match any value for a specific argument:

```ruby
# /spec/argument_matchers_spec.rb
allow(obj).to receive(:foo).with(anything, 42)
obj.foo("hello", 42)
```

This will match any first argument, as long as the second is 42.

### Example: hash_including

You can match a hash that includes certain keys:

```ruby
# /spec/argument_matchers_spec.rb
allow(api).to receive(:post).with(hash_including(:token))
api.post({ token: "abc", data: "payload" })
```

### Example: array_including

You can match an array that includes certain elements:

```ruby
# /spec/argument_matchers_spec.rb
allow(arr).to receive(:concat).with(array_including(1, 2))
arr.concat([1, 2, 3])
```

---

## Verifying Method Calls

You can also check that a method was called, and with what arguments, using `expect(...).to have_received`. This is useful for verifying interactions in your code.

### Example: Verifying a Method Call

Here’s how you can check that a method was called with specific arguments:

```ruby
# /spec/argument_matchers_spec.rb
logger = double("Logger")
allow(logger).to receive(:log)
logger.log("info", "message")
expect(logger).to have_received(:log).with("info", "message")
```

Try running this code and see what happens if you change the arguments.

---

## More Scenarios & Edge Cases

- If you stub a method with specific arguments, calling it with different arguments returns nil (unless you use argument matchers).
- You can combine argument matchers for more flexible stubbing.
- You can stub methods on real objects, not just doubles! (Note: Stubbing real objects can sometimes hide bugs—use with care. We’ll explore this more in the next lesson.)
- If you want to allow any arguments, use `.with(any_args)`.

---

## Practice Prompts

Try these exercises to reinforce your learning. For each, write your own spec in `/spec/argument_matchers_spec.rb` unless otherwise noted.

**Exercise 1: Basic stubbing with allow/receive**
Stub a method with `allow(...).to receive` and set a return value. What happens if you call it with different arguments?

**Exercise 2: Argument matcher with any_args**
Use argument matchers to stub a method for any arguments, and test that it works for multiple calls.

**Exercise 3: Verifying method calls with have_received**
Write a spec that verifies a method was called with specific arguments using `expect(...).to have_received`.

**Exercise 4: Stubbing with hash_including or array_including**
Use `hash_including` or `array_including` to stub a method that takes a hash or array.

**Exercise 5: Stubbing real objects**
Stub a method on a real Ruby object (not a double) and verify it was called.

_Reflection: Why might we prefer argument matchers over hardcoding specific arguments in our stubs?_

---

## Resources

- _Check out the official RSpec documentation on stubbing methods for more details and examples:_
  - [RSpec: Stubbing Methods](https://relishapp.com/rspec/rspec-mocks/v/3-10/docs/basics/allowing-messages)
- _See the full list of argument matchers here:_
  - [RSpec: Argument Matchers](https://relishapp.com/rspec/rspec-mocks/v/3-10/docs/built-in-matchers/argument-matchers)
- _Learn how to verify method calls with have_received:_
  - [RSpec: have_received](https://relishapp.com/rspec/rspec-mocks/v/3-10/docs/built-in-matchers/have-received-matcher)
- _For best practices on using doubles in your specs:_
  - [Better Specs: Doubles](https://www.betterspecs.org/#doubles)
