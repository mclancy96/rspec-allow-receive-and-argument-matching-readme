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

### Basic Example (WeatherStation domain)

Here’s how you can stub a method on a double:

```ruby
# /spec/allow_receive_spec.rb
RSpec.describe 'allow/receive and argument matching (WeatherStation examples)' do
  it 'allows a method to be stubbed on a double' do
    station = double('WeatherStation')
    allow(station).to receive(:temperature).and_return(68.5)
    expect(station.temperature).to eq(68.5)
  end
end
```

In this example, we create a double called "WeatherStation" and tell it to respond to `temperature` with `68.5`. When we call `station.temperature`, it returns `68.5`—no real WeatherStation class needed!

Run this file with `rspec spec/allow_receive_spec.rb` to see the stub in action.

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
# /spec/allow_receive_spec.rb
it 'returns a value for specific arguments' do
  station = double('WeatherStation')
  allow(station).to receive(:humidity).and_return(nil)
  allow(station).to receive(:humidity).with('NYC').and_return(55)
  expect(station.humidity('NYC')).to eq(55)
  expect(station.humidity('LA')).to be_nil # not stubbed
end
```

### Example: Stubbing Multiple Return Values

You can stub the same method with different arguments and return values:

```ruby
# /spec/allow_receive_spec.rb
station = double('WeatherStation')
allow(station).to receive(:forecast).and_return(nil)
allow(station).to receive(:forecast).with(:today).and_return('Sunny')
allow(station).to receive(:forecast).with(:tomorrow).and_return('Rainy')
expect(station.forecast(:today)).to eq('Sunny')
expect(station.forecast(:tomorrow)).to eq('Rainy')
expect(station.forecast(:friday)).to be_nil
```

### Example: Returning Different Values on Each Call

You can also return a sequence of values for multiple calls to a stubbed method, which simulates changing state over time:

```ruby
# /spec/allow_receive_spec.rb
sensor = double('Sensor')
allow(sensor).to receive(:read).and_return(10, 20, 30)
expect(sensor.read).to eq(10)
expect(sensor.read).to eq(20)
expect(sensor.read).to eq(30)
expect(sensor.read).to eq(30) # repeats last value
```

---

## Argument Matchers

Argument matchers let you stub or verify methods regardless of the exact arguments. This is great when you care about the method being called, but not the specific values.

### Example: any_args

You can match any arguments passed to a method:

```ruby
# /spec/allow_receive_spec.rb
logger = double('Logger')
allow(logger).to receive(:log_event).with(any_args)
logger.log_event('rain', { amount: 2 })
logger.log_event('wind')
expect(logger).to have_received(:log_event).twice
```

### Example: anything

You can match any value for a specific argument:

```ruby
# /spec/allow_receive_spec.rb
station = double('WeatherStation')
allow(station).to receive(:report).and_return(nil)
allow(station).to receive(:report).with(anything, 'high').and_return('Alert!')
expect(station.report('temp', 'high')).to eq('Alert!')
expect(station.report('humidity', 'high')).to eq('Alert!')
expect(station.report('temp', 'low')).to be_nil
```

### Example: hash_including

You can match a hash that includes certain keys:

```ruby
# /spec/allow_receive_spec.rb
station = double('WeatherStation')
allow(station).to receive(:log_event).and_return(nil)
allow(station).to receive(:log_event).with(hash_including(:event)).and_return('Logged!')
expect(station.log_event({ event: 'storm', severity: 'high' })).to eq('Logged!')
expect(station.log_event({ severity: 'high' })).to be_nil
```

### Example: array_including

You can match an array that includes certain elements:

```ruby
# /spec/allow_receive_spec.rb
sensor = double('Sensor')
allow(sensor).to receive(:calibrate).and_return(nil)
allow(sensor).to receive(:calibrate).with(array_including('temp', 'humidity')).and_return('Calibrated')
expect(sensor.calibrate(['temp', 'humidity', 'pressure'])).to eq('Calibrated')
expect(sensor.calibrate(['pressure'])).to be_nil
```

---

## Verifying Method Calls

You can also check that a method was called, and with what arguments, using `expect(...).to have_received`. This is useful for verifying interactions in your code.

### Example: Verifying a Method Call

Here’s how you can check that a method was called with specific arguments:

```ruby
# /spec/allow_receive_spec.rb
logger = double('Logger').as_null_object
allow(logger).to receive(:log_event)
logger.log_event('rain', { amount: 2 })
expect(logger).to have_received(:log_event).with('rain', { amount: 2 })
```

---

## More Scenarios & Edge Cases

- If you stub a method with specific arguments, calling it with different arguments returns nil (unless you use argument matchers).
- You can combine argument matchers for more flexible stubbing.
- You can stub methods on real objects, not just doubles! (Note: Stubbing real objects can sometimes hide bugs—use with care. We’ll explore this more in the next lesson.)
- If you want to allow any arguments, use `.with(any_args)`.

---

## Getting Hands-On

You can fork and clone this lesson's repo, run the specs, and try implementing the two pending specs marked as student exercises in `spec/allow_receive_spec.rb`.

To run the specs:

```sh
bin/rspec
```

Look for the two pending specs (marked as 'Student exercise') and try to implement them yourself! All the examples use the WeatherStation domain, so you can see real-world usage of allow/receive and argument matchers in a practical context.

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
