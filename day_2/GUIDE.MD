# Day 2️⃣
- Tuples (Product type)
- Variant (Sum type)
- Comments
- Optional types
- Structural typing / Named typing
- Shared types
- Buffer 
- List
- Array


## 📚 Using Modules & the **Base** library
Yesterday, we've only looked at operations that are built-in to the language. To perform more complex operations, we'll need to import and use modules, especially those from the [Base library](https://internetcomputer.org/docs/current/motoko/main/base/).

The Base library is a set of modules & functions that provide functions for commonly used types (such as `Bool`, `Nat`, `Int`, `Text` and more).

A module is a collection of code written by someone else that you can use in your own program. <br/>
We will explore different methods for importing modules and even creating our own modules, but for today we will focus on importing modules from the **Base** library.

The source code for this library is [available on Github](https://github.com/dfinity/motoko-base/) and is maintained by engineers from the DFINITY foundation and community members. 
<br/>
Each module has its own documentation page, where you can learn about the available functions. For example, here is the [documentation page for the Nat module](https://internetcomputer.org/docs/current/motoko/main/base/Nat).

<p align="center"> <img src="./img/base_library_nat.png" width="800px" style="border: 2px solid black;"></p>

> The source code is meant to understand how a specific module was written, whereas the documentation is meant to understand how you can use a module.

There is a module for each type: 
- A module `Nat` corresponding to operations on `Nat`.
- A module `Int` corresponding to operations on `Int`.
- A module `Text` corresponding to operations on `Text`.
- A module `Char` corresponding to operations on `Char`.
- And way more..

Importing a module is done at the top of the file before the `actor` declaration.
```
import Nat "mo:base/Nat";
actor {
    public func convertToText(n : Nat) : async Text {
        return Nat.toText(n);
    };
};
```
## 🔎 Debug 
**Debug** is a module that provides utility functions for debugging and printing informations. 

`Debug.print()` will print text to the output stream (i.e your terminal).

```motoko
import Debug "mo:base/Debug";
actor {
    Debug.print("Hello!");
};
```
<p align="center"> <img src="./img/debug_print.png" width="800px" style="border: 2px solid black;"></p>
<p align="center"> The text will be printed in the same tab that is running your replica. Make sure to check out the correct place!</p>

> Unfortunately, `print` can only be used locally. On the mainnet or when using Motoko Playground there is no concept of output stream so `Debug.print` has no effect.

`Debug.print()` only accepts a value of type `Text` as input. If you have any  object, you can use the `debug_show` command to automatically convert it to `Text`. 
```motoko
let array : [Nat] = [19, 8, 2, 5];
Debug.print(debug_show(array));
```
You can also use convertion functions
```motoko
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";
actor {
    let n : Nat = 5;
    Debug.print(Nat.toText(n));
}
```
## 💬 Text 
In Motoko, strings can be written surrounded by double quotes `"`
```motoko
"Hello Motoko Bootcamp!"
```
The type for string is `Text` (pretty easy to remember).
```motoko
let welcomePhrase : Text = "Hello Motoko Bootcamp!";
```

We can use the concatenation operator `#` to join two `Text` together.
```motoko
let firstName : Text = "Motoko";
let surname : Text = "Bootcamp";
let completeName : Text = firstName # surname;
```

We can access the size of a `Text` by calling the `size()` method.
```motoko
let name : Text = "Motoko";
let size = name.size()  // 6
```
## 🔤 Char
A value of type `Text` is actually composed of values from another type: `Char`. A `Text` is the concatenation of multiple characters. Characters are single-quote delimited `'`
```motoko
let character_1 : Char = 'c';
let character_2 : Char = '8';
let character_3 : Char = '∏';
```
`Char` are represented by their [Unicode code points](https://deliciousbrains.com/how-unicode-works/). We can use the `Char` module from the Base library to check the unicode value. 
```motoko
import Char "mo:base/Char";
import Debug "mo:base/Debug";
actor {
    let a : Char = 'a';
    Debug.print(debug_show(Char.toNat32(a)));   // 97
}
```
We can easily iterate over all the characters in a `Text`, by calling the `chars()` method. We can then use this iterator to create a `for` loop.
```motoko
import Debug "mo:base/Debug";
import Char "mo:base/Char";
actor {
    let name : Text = "Motoko";
    for (letter in name.chars()){
        Debug.print(Char.toText(letter));
    };
};
```
> Notice how when we iterate `letter` is a `Char` and we need to convert it back to `Text` to use `Debug.print`.

The `Char` module also contains a few functions that can be used to test properties of characters:
- `isDigit`
```motoko
Char.isDigit('9');  // true
```
- `isWhitespace`
```motoko
Char.isWhitespace('a'); // false
```
- `isLowercase`
```motoko
Char.isLowercase('c');  //  true
```
- `isUppercase`
```motoko
Char.isUppercase('D');  // true
```
- `isAlphabetic`
```motoko
Char.isAlphabetic('|'); // false
```
## Float
`Float` are numbers that have a decimal part.
```motoko
let pi = 3.14;
let e = 2.71;
```
If you want to use `Float` for whole numbers, you need to add the type descriptor otherwise they would automatically be casted to `Ìnt` or `Nat`. 
```motoko
let f : Float = 2;
let n = 2;  // Automatically casted to type Nat
```

`Float` are implemented on 64-bits folowing the [IEEE 754 representation](https://www.geeksforgeeks.org/ieee-standard-754-floating-point-numbers/). Due to the limited precision, operations may result in numerical errors.
```motoko
0.1 + 0.1 + 0.1 == 0.3 // => false
```
```motoko
1e16 + 1.0 != 1e16 // => false
```

`Float` supports all arithmetic operations and comparison seen before on `Nat`and `Int`.
## 👯 Tuples

## 🌈 Variants

## Object (records)

## Optional type

