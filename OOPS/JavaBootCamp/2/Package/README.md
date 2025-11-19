# Package Shipping System

---

## Problem Description

You are tasked with building a simplified **Package Shipping System**.

There are two types of packages:
1. A **standard package** (`Package` class).
2. An **express package** (`ExpressPackage` class), which adds an additional fixed shipping fee.

Every package has:
- A **unique ID** (cannot be overridden).
- A **weight**.

Your job is to complete the missing parts of the code.

---

## Files Provided

### `Package.java`
- Implements the base `Package` class.
- Defines attributes: `id` and `weight`.
- Provides **overloaded** methods `calculateCost()`:
  - `calculateCost(double ratePerKg)`
  - `calculateCost(double ratePerKg, double insuranceFee)`
- Provides a `getID()` method that **must not be overridden**.

### `ExpressPackage.java` (to be implemented)
- Constructor should accept `(int id, double weight, double expressFee)`.
- Make appropriate modifications to the `calculateCost` method to account for the express fee.
- **Do not override `getID()`**.

### `Main.java`
- Contains code for testing.

---

## Execution Instructions
- All three .java files need to be compiled before `Main` can be executed.
- Compile them using `javac *.java`, then run `java Main`.