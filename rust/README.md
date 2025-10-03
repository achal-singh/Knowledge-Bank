# Rust

## Cargo

The official package manager and the build system for Rust. It is used to initialise Rust projects, build existing Rust projects, install external dependencies and perform tests.

- `cargo init <project_name>` - Initialises a new Rust project.
- `cargo build` - Builds/Compiles all files under `src` folder.
- `cargo fmt` - Formats the code under `src` folder.
- `cargo run` - Looks for the `main.rs` file under the `src` folder and executes everything defined inside the `main()` function.

  **Note:** `cargo run --example hello`: Executes the file or binary named `hello.rs` under the `/example` folder in the project root.

- `cargo test` - Executes all the defined tests.

### **Macros**

Functions that end with an exclamation mark (!). These functions generate code at compile time and prevent runtime errors. Some common macros are listed below:

- **println!()** - allows printing values on the console.
- **format!** - Brings String Interpolation in Rust (like we have `Hello ${name}` in Typescript).
- **derive()** - #[derive(T1, T2, …)] asks the compiler (or a proc-macro) to auto-generate trait impls for your type based on its fields. You slap it on a **_struct_** or **_enum_**, and you get boilerplate implementations for free.
  > Note: We don't need to mention the derive macro on top of a struct if the value we intend to print is of type other than Struct itself. For ex: to print a value which is of primitive type we don't need to use derive.
  ```rust
  #[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, Default)]
  struct Point {
    x: i32,
    y: i32,
  }
  ```

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

- **String and &str**: **String** is when we need ownership or mutability. **&str** is used for read-only string or string literals.
  Stack: (fixed size, lives in the function frame)

  ```md
  # String (a struct) lives on a stack, but has a ptr to the bytes (the contents of the string) stored in the heap

  Stack: (fixed size, lives in the function frame)
  ┌──────────────────────┐
  │ s.ptr ──────────────────► Heap: [ 'h', 'e', 'l', 'l', 'o' ]
  │ s.len = 5 │
  │ s.cap = 5 │
  └──────────────────────┘
  ```

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

- **Enums**: An enum (short for enumeration) is a type that can represent one of several possible variants. Enums are powerful because they let you encode states in a type-safe way.

  > Note: If we wish to print the value of an enum we must define `#[derive(Debug)]` just above the enum declaration.

  ```rust
  // A simple enum declaration
  enum Direction {
    North,
    South,
    East,
    West,
  }

  let dir = Direction::North;

  // An enum that can carry values (like structs)
  #[derive(Debug)]
  enum Message {
    Quit,                    // no data
    Move { x: i32, y: i32 }, // struct-like
    Write(String),           // tuple-like
    ChangeColor(u8, u8, u8), // tuple-like
  }
  let msg: Message = Message::Move{ x: 100, y: 50};
  println!("{:?}", msg);
  ```

  - **Option<T>**: A generic enum in Rust that represents an optional value.
    - **`Some(T)`** means a value of type `T` is present.
    - **`None`** means no value is present.

  This allows handling the possibility of absence **_safely_** without resorting to nulls or panics. Many APIs return Option when a value may or may not exist (e.g., looking up a key in a map, accessing an array element by index). By explicitly handling both cases, it prevents runtime errors like null pointer exceptions.

  - **Result<T, E>**: A generic enum used for error handling in Rust.
    - **`Ok(T)`** means an operation succeeded and returns a value of type T.
    - **`Err(E)`** means the operation failed and returns an error value of type E.

  This makes error handling explicit and type-safe. Instead of panicking or throwing exceptions, functions return a Result and the caller decides how to handle success or failure.

- **Structs**: A data type that can be used to group different data types into a single data type.

  ```rust
  // Different ways to define a struct
  // 1. With Curly braces
  struct Point {
    x: i32,
    y: i32
  }
  // 2. with Circular braces
  struct Point3D(i32,i32,i32);

  // 3. Empty struct
  struct Im_Empty;

  // 4. Nested Struct
  struct Circle {
    radius: u32,
    center: Point // <--- another struct
  }

  // Exported struct with public fields in order to be accessible
  pub struct Circle {
    pub radius: u32,
    pub center: Point
  }

  fn main() {
    let p = Point {x: 1, y: 1};
    println!("X: {} | Y: {}", p.x, p.y);
    let p = Point3D(-1, 0, 1);
    println!("Point 3D ({:?}, {:?}, {:?})", p.0, p.1, p.2);
    let circle = Circle{
      radius: 5,
      center: Point { x: 0, y: 0}
    }
  }

  // Copy fields
  let p0 = Point {x: 1, y: 2};
  let p1 = Point {x: 1, y: p0.y}
  let p1 = Point {x: 2, ..p0}; // Copy all other fields of p0, except x.

  // Update
  let mut p = Point { x: 0, y: 0};
  p.x += 1;   // Point {x: 1, y: 0}
  p.y = 100;  // Point {x: 1, y: 100}
  ```

- **Vector**: A Vector is like an array, a collection of items of the same type. But unlike arrays in Rust that have a fixed length at compile time, Vectors can be dynamically sized at run time.

  ```rust
  // In order to be able to push elements to it, we must add `mut`.
  let mut v: Vec<i32> = Vec::new();
  v.push(1);
  v.push(2);
  v.push(3);
  println!("{:?}", v);

  // In-line intialisation and assignment of values
  // Uses the `vec!` macro.
  let v: Vec<i8> = vec![1,2,3];
  // OR
  let v = vec![1i8, 2, 3];
  // Creating a vector of 100 0s.
  let v = vec![0i8; 100];

  // Get function - allows for safely accessing values (preventing panic calls)
  // Option<&i8>
  // Index valid => Some(&val)
  // Index invalid => None
  println!("{:?}", v.get(0));   // Some(0)
  println!("{:?}", v.get(100)); // None

  // Update a vector
  let mut v: Vec<i8> = vec![1,2,3];
  v[0] = 99;
  // pop - removing last element
  let x: Option<i8> = v.pop();
  println!("{:?}", x); // Some(3)

  // Slice
  let v = vec![1,2,3, 4, 5];
  let s = &v[0..3];
  println!("{:?}", s); // [1,2,3]
  ```

- **HashMap**: It's a data structure used to store key-value pairs. HashMap is needed to be imported from **`use std::collections::HashMap;`**.

  ```rust
  use std::collections::HashMap;

  fn main() {
    let mut scores: HashMap<String, u32> = HashMap::new(); // init
    scores.insert("India".to_string(), 200);
    scores.insert("Australia".to_string(), 150);
    println!("{:#?}", scores);
    // Getting the value: Returns either Some(val) or None.
    let score: Option<&u32> = scores.get("India");
    // Update
    // score is a mutable reference => can read and write this value.
    let score: &mut u32 = scores.entry("India".to_string()).or_insert(0);
    *score += 100; // dereference
    println!("{:?}", scores.get("India")); // Some(300)

  }
  ```

### Control Flow

- **if-else**

  ```rust
  let x: i32 = 10;

  // Conditionally assigning the value to z
  let z: i32 = if x > 0 {
    println!("x > 0");
    return 1
  } else if x < 0 {
    println!("x < 0");
    -1
  } else {
    println!("x = 0");
    0
  };

  println!("{z}")
  ```

- **Loop**:

  ```rust
  // Loop
  let mut i = 0;
  // loop being used an expression (only possible for loop)
  let z: &str = loop {
    if i > 5 {
     break "Loop ends here"; // <- returns the string literal on breaking
    }
    i += 1;
    println!("{i}");
    "hi"
  };


  // While Loop
  let mut i = 0;
  while i <= 5 {
    println!("{i}");
    i += 1;
  }

  // for loop
  for i in 0..6 {
     println!("{i}")
  }

  // Iterating over an array
  let arr = [2,3,4,5,99];
  let n: usize = arr.len();
  for i in 0..n {
   println!("At Index: {i}: {}", arr[i])
  }
  for n in arr {
   println!("arr {}", n); // prints the values in arr
  }

  // Iterating over a vector
  let v = vec![10, 20, 30, 40, 50];
  // iter():
  for x in v.iter() {
    println!("{x}")
  }
  ```

  **`.iter()`**:

  - Borrows the collection immutably.
  - Yields references (&T).
  - Collection is not consumed (you can still use it after).

  **`.iter_mut()`**:

  - Borrows mutably.
  - Yields mutable references (&mut T).
  - Lets you modify elements in place.

  **`into_iter()`**

  - Consumes the collection (takes ownership).
  - Yields owned values (T).
  - After calling, the collection is moved and can’t be used again.

- **match**: Similar to switch-case but with more powerful features. maps matching values/expressions to operations. **`_`** repsents default case, if nothing else matches.

  ```rust
  // With Option enum
  let x: Option<i32> = Some(9);
  match x {
    Some(val) => println!("Option is {val}"),
    None => println!("None")
  }
  // result of a match can be stored in a variable.
  let z = match x {
     Some(val) => val,
     None => 0
  };
  println!("Match returned: {z}");

  // With Result enum
  let res: Result<i32, String> = Err("Oops!".to_string());
  match res {
   Ok(val) => println!("Result is Ok: {val}"),
   Err(err) => println!("ERROR: {err}")
  }

  let x = 5;
  match x {
      0 => println!("zero"),
      i @ 1..=5 => println!("From 1 to 5, i: {i}"), // assigning the matched value to i. (1 and 5 inclusive).
      6 | 7 => println!("six or seven"),
      _ => println!("other"),
  }

  enum Direction { Up, Down, Left, Right }
  fn move_dir(dir: Direction) {
    match dir {
        Direction::Up => println!("Moving up"),
        Direction::Down => println!("Moving down"),
        Direction::Left => println!("Moving left"),
        Direction::Right => println!("Moving right"),
    }
  }
  ```

- **if-let**: Used when we only need to handle one variant of an enum like `Option` or `Result`. This approach avoids the boilerplate of a full `match` statement,

```rust
let x: Option<i32> = Some(9);
if let Some(val) = x {
  println!("Option is {val}");
} else {}
// The if-let written above and match written below do the exact same thing.
let x: Option<i32> = Some(9);
match x {
   Some(val) => println!("Option is {val}"),
   None => {}
}
```

## Ownership

Ownership in Rust is primarily defined by ownersip and borrowing rules. they ensure Rust's memory safety.

### **Stack & Heap**:

- **Stack**:

  - Memory location where data of fixed size known at compile-time is stored. Primitives like: u32, i32, bool or the ones whose size is known at compile time are all stored in the Stack.

  - Data access on the stack is fast. Data is stored in LIFO way.

- **Heap**: Stores data of unknown size at compile team. Dynamically sized types like String, Vector, are all stored in a heap. Data acccess is slower than stack.
  **Note**: If we wish to intentionally store a primitive value in heap instead of stack, we can use Box:
  ```rust
  let boxed: Box<i32> = Box::new(1i32);
  ```

### Ownership Rules

1. Each value has an owner.

```rust
let s = String::from("Rust is good!"); // owner of the string is s
let i = 1.234; // owner of the float value is i.
```

2. There can only be one owner at a time.

```rust
let s = String::from("Rust is good!");
let s1 = s; // ownership of string in `s` tranferred to s1
let s2 = s1; // ownership of string in `s` tranferred to s2
println!("{s2}") // works fine
println!("{s1}") // gives compilation error
println!("{s}") // gives compilation error
```

3. **When the owner goes out of scope, the value will be dropped.**

   **Built-in Copy Types**:

   - Integer types: (`u8, i8, u16, i16, u32, i32, u64, i64, u128, i128, usize, isize`).
   - floating-point: (`f32`, `f64`).
   - `bool`.
   - `char`.

   **Non-Copy Types**:

   - Heap-allocating types like **String**, **Vec<T>**, **Box<T>**.
   - Smart pointers like Rc<T>, Arc<T>.
   - Anything that implements Drop.

   ```rust
   // ### Example 1 ###
   // Example fn
   fn take(s: String) {
     println! ("take {s}");
     // s is dropped here, when the function is done executing.
   }
   let s = String::from("cat"); // s is the owner of string `cat`.
   take(s); // ownership of `cat` is transferred to scope of the function.
   println!("{s}"); // will throw error, since s doesn't own the string `cat`.

   // ### Example 2 ###
   // If we introduce a scope in between, then also the ownership changes.
   let s = String::from("cat"); // s is the owner of string `cat`.
   {
     let s1 = s;
     // s1 is dropped here
   } // scope ends here
   println!("{s}"); // will throw error, since s doesn't own the string `cat`.
   ```

### Borrowing Rules

Borrowing allows to temporarily use a value without actually taking ownership.

- Creates a reference (either mutable or immutable).
- **Immutable Reference**: Allows for read-only access to the variable, doesn't allow to change its value. We can have multiple immutable refereces simultaneously.
- **Mutable Reference**: Allows for read and write access, allows ONLY ONE read and write access to the value at a time. Can't have multiple simulateous mutable references.
- Either mutable or immutable reference is allowed, not both.
- References must not outlive the value (value must live longer than the reference).

```rust
let s = String::from("Hey!");
// Here, s1, s2 and s3 all have read-only (immutable) access to s.
let s1 = &s;
let s2 = s1;
let s3 = &s;

// Mutable reference
let mut s = String::from("Change ME!");
let s1 = &mut s;
s1.push_str("NEW ADD");

// s2 can mutate s once s1 is done pushing.
let s2 = &mut s;
s1.push_str("NEW ADD 2");
println!("{s}") // Change ME!NEW ADDNEW ADD 2

// Can't have 2 mutable references at a time
let mut s = String::from("Change ME!");
let s1 = &mut s;
let s2 = &mut s;

// A mutable and immutable reference cannot exist simultaneoulsy
let mut s = String::from("YO!");
let s1 = &s;
let s2 = &mut s;


// Here the ownership of s is first transferred to s1 and then to s2.
let s = String::from("Hello!");
let s1 = s;
let s2 = s1;

// Example - Reference must not outlive the value
let s = String:: from ("rust") ;
let s1 = &s;
{
  let s2 = s;
  // s2 is dropped here
} // s2 and s no longer exist
// s1 still references s, it is outliving the original value


```
