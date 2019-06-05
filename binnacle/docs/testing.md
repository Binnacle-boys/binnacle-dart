# Testing in Flutter

## Contents

1. [Overview](#overview)
2. [Unit Testing](#unit-testing)
4. [Widget Testing](#widget-testing)
3. [Integration Testing](#integration-testing)
5. [References](#references)

## Overview

![An example testing pyramid model. Unit tests make up the bulk of the tests, then integration, and lastly UI tests. Rarely are there some manual tests that must be performed.](resources/testing_pyramid.jpg)

Automated tests helps ensure that an application runs as designed, and helps maintain the application as new features are added.

There are three core types of tests for Flutter projects:

**Unit Test:** Test a single class, method, or function.

**Widget Tests:** Test the UI of the application. Helpful for documenting design features that may not be clear in the codebase.

**Integration Test:** Tests the coupling of pieces of the project (widgets being interacted with by a user). Such as the BluetoothManager with Bluetooth Services and how that feeds data into the user interface.

A helpful note, these tests range in orders of magnitude. Just like the pyramid, we should have more unit tests than integration tests, and so on. Additionally, how long they take to run is orders of magnitude different too. Unit tests are the quickest to run and widget tests are the slowest. This is why it is encouraged to try and have everything done as a unit test even though they could be done as any other type of test.

When writing tests, usually creating a test file counterpart to the files in the codebase is enough. Not all files in the codebase require a test file (such as painter classes used for drawing code), but also we may add some test files that do not have a counterpart. One example of this might be tests that ensure external APIs are returning the same data model. When a test like this stops passing, it's very easy to find the issue and fix it.

## Unit Testing

Unit tests check a specific piece of code under several different conditions. It tries to capture the average case and all possible edge cases. Normally, when an edge case is forgotten about and creates a bug, a test case can be added to prevent **regression**. Regression is when a bug comes back into the project because the tests were not updated to handle that case.

Unit tests should be very quick to run, and shouldn't be time constrained (such as waiting 10 seconds to see if a timer is working).

Extra dependencies not relevant to the test at hand can be [mocked](https://flutter.dev/docs/cookbook/testing/unit/mocking).

### Streams

Using `emits(...)` group of functions we can easily test streams. There are several different types of emit functions that offer different methods of testing (such as checking for errors, several repeats of a value, etc). Anything that can be functionally programmed on a Stream can easily be verified with the emits family of functions.

## Widget Testing

Widget tests let us mock widgets and see if data pumped is being properly inserted into the right elements.

### Snapshot Testing

*Also known as golden testing.*

Involves constructing an emulator of the app with the widget at test, and taking a screenshot. This screenshot is compared to what is currently on file. If they are the same, the test passes. Otherwise an error is thrown. If this new UI is desired, we can update the *golden* image to be the current.

Commonly used with tracking design decisions made in the application.

## Integration Testing

Integration testing lets us combine unit tests with widget tests. We can test wholes systems based off pumping data into the systems that power our widgets.

Additionally, we can use `flutter_driver` to use the app like a user would.

## References

[Flutter Testing (Official Docs)](https://flutter.dev/docs/testing)