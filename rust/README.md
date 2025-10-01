# Rust

## Cargo

The official package manager and the build system for Rust. It is used to initialise Rust projects, build existing Rust projects, install external dependencies and perform tests.

- `cargo init <project_name>` - Initialises a new Rust project.
- `cargo build` - Builds/Compiles all files under `src` folder.
- `cargo fmt` - Formats the code under `src` folder.
- `cargo run` - Looks for the `main.rs` file under the `src` folder and executes everything defined inside the `main()` function.

  **Note:** `cargo run --example hello`: Executes the file or binary named `hello.rs` under the `/example` folder in the project root.

- `cargo test` - Executes all the defined tests.

## Concepts

### **Macros**

Functions that end with an exclamation mark (!). These functions generate code at compile time. **Example:** `println!("Howdy!)`.

### **Variables**:

- Variables in Rust are **_immutable by default_**, so it's value can't be changed once assigned.

```rust
// Immutable by default
fn main() {
  let x = 1;
  x += 1; // Throws error
}

// Variable is made mutable by using the `mut` keyword
fn main() {
  let mut x = 1;
  x += 1; // Works!
}
```

- Although Rust is a statically typed language, it has **type inference** built-in.

```rust
// Both variable declarations work the same way.
fn main() {
 let y: i32 = -1;
 let z = -1;
}
```

- **Shadowing**: We can re-declare a variable with different values and types.

```rust
fn main() {
 let x: i32 = 1;
 let x: i32 = 2;     // Shadows the previous x = 1
 let x: bool = true; // Shadows the previous x = 2
 println!("{x}") // true
}
```

- **Type placeholder**: By defining `_` as the type we can tell Rust to figure out the type of a variable.

  ```rust
  fn main() {
  let x: _ = 1;
  }
  ```

- **Constants:** A constant's value is **_hardcoded_** and it can be defined outside the scope of the `main()` function.

  ```rust
  const NUM: i32 = 100;
  fn main() {
   println!("{NUM}") // 100
  }
  ```

  > Note: **Normal variables** (`let`, `let mut`) live inside the memory whereas **constants** live inside the compiled code.

  **println!**:

  ```rust
  let x = 1;
  println!("x is {}", x) // x is 1
  // Inline
  println!("x is {x}", x);` // x is 1
  // Positional arguments
  println!("{0} + {0} = {1}", x, x + x);` // x is 1

  // DEBUGGING A VARIABLE
  println!("DEBUG: x {:?}", x); // x is 1
  println!("DEBUG: x {:#?}", x); // x is 1
  ```

### Functions

Functions can be defined in the following way:

```rust
// Both add and add_with_return do the exact same thing and return x + y at the end.
fn add (x: u32, y: u32) -> u32 {
    x + y
}

fn add_with_return (x: u32, y: u32) -> u32 {
    return x + y;
}
```

**Handling multiple returns**

```rust
fn add_and_boolean (x: u32, y: u32) -> (u32, bool) {
  (x + y, false)
}

fn main() {
    let z = add_and_boolean(1, 2);
    println!("{:?}", z); // (3, false)
    println!("add = {}, bool = {}", z.0, z.1); // add = 3, bool = false
    let (sum, flag) = add_and_boolean(1, 2);
    println!("add = {}, bool = {}", sum, flag); // add = 3, bool = false
}
```

return declaration (`-> <return_type>`) can be omitted in case a function does not return anything:

```rust
fn print(s: String) {
  print("3 Times: {s}{s}{s}");
}

fn main() {
  print("rust".to_string()); // 3 Times: rustrustrust
}
```

- Type annoataions in function params are **mandatory**, Rust cannot infer them on its own.

### Data Types

#### Scalar Types

Data types that represent a single value.

**Types**:

- Signed Integers: `Range: -(2 ^ (n - 1)) to 2 ^ (n - 1) - 1`. (Ex: i8, i16, i32, i64, i128).
- Un-Signed Integers: `Range: 0 to 2 ^ (n - 1) - 1`. (Ex: u8, u16, u32, u64, u128).
- `usize` and `isize`: hold values depending upon the computer arch (32-bit or 64-bit).
- Floating point numbers: Represent decimals. (Ex: f32, f64).
- Boolean (`bool`): Holds either `true` or `false`.
- Characters (`char`): Holds a single character from `a` to `z`.

  ```rust
  // Signed integers
    // Range: -(2^(n-1)) to 2^(n-1) - 1
    let i0: i8 = -1;
    let i1: i16 = 2;
    let i2: i32 = 3;
    let i3: i64 = -4;
    let i4: i128 = 5;
    // Depends on computer architecture
    let i5: isize = -6;

    // Unsigned integers
    // 0 to 2^n - 1
    let u0: u8 = 1;
    let u1: u16 = 2;
    let u2: u32 = 3;
    let u3: u64 = 4;
    let u4: u128 = 5;
    // Depends on computer architecture
    let u5: usize = 6;

    // Floating point numbers
    let f0: f32 = 0.01;
    let f1: f64 = 0.02;

    // Boolean
    let b: bool = true;

    // Character
    // Declared with single quote
    let c: char = 'c';

    // Type conversion
    let i: i32 = -1;
    let u: u32 = i as u32;
    println!("i32: {} to u32: {}", i, u);

    // Min and max
    let max = i32::MAX;
    let min = i32::MIN;

    // Overflow
    let mut u: u32 = u32::MAX;
    u += 1;
    // Overflow doesn't panic when compiled with --release
    println!("u32 silent overflow: {}", u);

    // Return None on overflow
    // The following check returns 'None' in case of an error or 'Some' (with the correct value, Some(value)) in case of a valid operation.
    println!("u32 check overflow: {:?}", u32::checked_add(u32::MAX, 1));

    // Explicitly allow overflow
    // THis returns 0 in case of an overflow (instead of throwing) and the value in case of a non-overflow case.
    println!("u32 allow overflow: {}", u32::wrapping_add(u32::MAX, 1));
  ```

- **Tuple**: A data type that represents a collection of values, has fixed size and its values are known at compile-time.

```rust
let t: (bool, char, u32) = (true, 'a', 1);
println!("{} {} {}", t.0, t.1, t.2);
```

- **Empty Tuple** (a.k.a. **Unit Type**): Is used in cases where the intention is to not return anything.

```rust
// Returning a successful (or Ok) result without any data in it.
Result<(), String> = Ok(()) | Error("ERROR!");
// OR a function that does nothing and returns nothing.
fn ret_empty_tuple() -> () {}
```

- **Nested Tuple**: A tuple with multiple tuples of various sizes and types.

```rust
// Note: In Rust, numeric literals (integers and floats) can have a suffix to specify their type (like 1.23f64)
let nested = (('a', 1.23), (true, 1u32, -1i32), ())

// Accessing elemets inside the tuple
println!("nested.0.1: {}", (nested.0).1); // 1.23

// Destructuring a tuple
let t: (bool, char, u32) = (true, 'a', 1)
let (a, b, c) = t;
// Partial Destructuring
let (_, b, _) = t; // ex: if we only want the second value

fn return_many() -> (u32, bool) {
  (100, true);
}
let (num, flag) = return_many();
```

- **Arrays**: They're collection of elements with length known at compile-time, while **slices** are collection with length **_not known_** a compile-time.

```rust
// Array declaration [type; size]
let arr: [u32; 3] = [1, 2, 3];
println!("arr[0]: {}", arr[0]);

// Length
let len = arr.len();
// Mutable Array
let mut arr: [u32; 3] = [1, 2, 3];
arr[1] = 99;

// Creates an array with 10 elements all set to 0.
let arr: [u32; 10] = [0; 10];
println!("arr: {:?}", arr);

let nums: [u32; 10] = [-1, 0, 1, 2, 3, 4, 5, 6, 7, 8];

// SLICE
// &[i32] means reference to an array of type i32.
// [0..3] OR [..3] fetches the first 3 elements, excl. the element at index 3.
let s: &[i32] = &nums[0..3]; // &nums[..3]
// Last 3 indexes
let s: &[i32] = &nums[7..10] // &nums[7..]
// Middle 4 indexes
let s: &[i32] = &nums[3..7] // &nums[..10]
```

- **String vs &str**: **String** is when we need ownership or mutability. **&str** is used for read-only string or string literals.
  **String** is an **owned, heap-allocated string**. It’s a growable, mutable collection of UTF-8 bytes.
  In the code below, `String::from(...)` (or `"HEY!".to_string()`) - explicitly asking Rust to allocate and take ownership.

  ```rust
  let msg: String = String::from("HEY!");
  ```

  **&String** and **&str** are called references to a string and a slice respectively.
  **Implicit conversion from a `String` -> `str`** works but not the other way round. Checkout this in action below:

  ```rust
  fn print(s: &str) {
    println!("Slice: {s}");
  }
  let msg: String = String::from("HEY!");
  print(&msg); // passing reference to a String, which Rust converts implicitly to a slice (str)/
  ```

  **Mutability in `String`**

  ```rust
  // 1. By declaring a String variable `mut`
  let mut msg = String::from("Hello Rust!");
  msg += " World";
  println!("{msg}"); // Hello Rust! World

  // 2. String Interpolation - by using the `format!` macro ()
  let a = "Rust";
  let mut msg = format!("Hello {a}");
  println!("{msg}"); // Hello Rust
  ```
