
# Hadron

Hadron is a **Stack based** language which provides on ly basic types and operations to act on the value like stacks with two operators.

Its syntax is really easy: one line equals to one instruction.

## Basic stacks

`inputStream` and `outputStream` are the only two global stacks.

+ `inputStream`
    + Provides an input stream, it reads the standard input
    + The only action possible is to `pop` something out of this stack

+ `outputStream` 
    + Provides an output stream, it prints into the standard output
    + The only action possible is to `push` something into this stack

The concept of "void" (`()`) exists in Hadron. Pushing something into the void deletes it forever.

It can be usefull to remove some elements of a simple stack.

```
var a: Integer = 0
a +> ()
// is the strict equivalent of
() <+ a
```

The example above deletes the `a` stack.

## Operators

The two following are equivalent, so that you'll be able to use these with whatever you want.
Just be coherent.

`a +> b` pushes `a` in front of `b`

`a <+ b` pushes `b` in front of `a`

The same principle applies below.

`a -> b` pops from `a` and stores into `b`
`a <- b` does the same thing as above

### Source and Target

Those concepts are simple:

+ the keyword `source` represents the source of the operation
+ the keyword `target` represents the target of the operation

**Example:**

```
a -> b
// Or alternatively
b <- a
```

```
var aStack: Integer
aStack <+ 3 <+ 2 <+ 1 <+ 0
// aStack now looks like [0, 1, 2, 3]

var other: Integer
other <- aStack
other <- aStack
// other looks like [1, 0]
```

Here we have:

+ `a`: the source of the pop, where the first element will be moved out
+ `b`: the target of the pop, the ontop value of the `a` stack will be added onto the `b` stack


## Predefined behaviours

On classic types like Integer, Double, String, ..., `push` and `pop` have a predefined behaviour.
Later, you'll be able to define your own types and behaviours

## Examples

```
var someInteger: Integer = 0
var anOtherInteger: Integer = 15

someInteger +> anOtherInteger
someInteger +> anOtherInteger

anOtherInteger +> ' ' +> "\nString literal\n" +> outputStream
```

The code above has three main instructions.

 - It declares two stacks : `someInteger` and `anOtherInteger`.
 - Then it pushes two times `someInteger` into `anOtherInteger`, which results
   in Integer stacks of an addition.
 - Finally it prints out the result below

```
30 
String literal
```
