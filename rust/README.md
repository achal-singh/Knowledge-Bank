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

1. **Macros** - Functions that end with an exclamation mark (!). These functions generate code at compile time. **Example:** `println!("Howdy!)`.

2. **Variables**:

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
