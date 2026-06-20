# Solidity Data Types — Reference Guide

> Solidity is a statically typed language; every variable must have a type declared at compile time.  
> Compiler version referenced: **^0.8.x**

---

## Table of Contents

1. [Value Types](#1-value-types)
   - [Boolean](#11-boolean)
   - [Integers](#12-integers)
   - [Unsigned Integers](#13-unsigned-integers)
   - [Fixed-Point Numbers](#14-fixed-point-numbers)
   - [Address](#15-address)
   - [Bytes (Fixed-size)](#16-bytes-fixed-size)
   - [Enums](#17-enums)
2. [Reference Types](#2-reference-types)
   - [Arrays](#21-arrays)
   - [Structs](#22-structs)
   - [Mappings](#23-mappings)
   - [Strings](#24-strings)
   - [Bytes (Dynamic)](#25-bytes-dynamic)
3. [Special Types](#3-special-types)
   - [Function Types](#31-function-types)
4. [Type Defaults Quick Reference](#4-type-defaults-quick-reference)
5. [Data Locations](#5-data-locations)

---

## 1. Value Types

Value types are **copied** when assigned or passed to functions. They live on the **stack** (when local) or in **storage** (when state variables).

---

### 1.1 Boolean

| Property      | Detail              |
|---------------|---------------------|
| **Keyword**   | `bool`              |
| **Size**      | 1 byte (8 bits)     |
| **Default**   | `false`             |
| **Values**    | `true` / `false`    |

**Operators:** `!` (not), `&&` (and), `||` (or), `==`, `!=`

```solidity
bool public isActive;          // default: false
bool public isOwner = true;
```

> ⚠️ Short-circuit evaluation applies: in `a && b`, if `a` is `false`, `b` is never evaluated.

---

### 1.2 Integers (Signed)

| Property      | Detail                                         |
|---------------|------------------------------------------------|
| **Keyword**   | `int8`, `int16`, `int32`, … `int256` (`int`)   |
| **Step**      | 8-bit increments                               |
| **Size**      | 1 byte (`int8`) → 32 bytes (`int256`)          |
| **Default**   | `0`                                            |
| **Range**     | −2^(N−1) to 2^(N−1) − 1                       |

| Type      | Min                          | Max                         |
|-----------|------------------------------|-----------------------------|
| `int8`    | −128                         | 127                         |
| `int16`   | −32,768                      | 32,767                      |
| `int32`   | −2,147,483,648               | 2,147,483,647               |
| `int128`  | −1.7 × 10³⁸                 | 1.7 × 10³⁸                 |
| `int256`  | −5.8 × 10⁷⁶                 | 5.8 × 10⁷⁶                 |

```solidity
int8  public temperature;     // default: 0
int256 public balance = -500;
```

> ℹ️ Plain `int` is an alias for `int256`.

---

### 1.3 Unsigned Integers

| Property      | Detail                                               |
|---------------|------------------------------------------------------|
| **Keyword**   | `uint8`, `uint16`, `uint32`, … `uint256` (`uint`)    |
| **Step**      | 8-bit increments                                     |
| **Size**      | 1 byte (`uint8`) → 32 bytes (`uint256`)              |
| **Default**   | `0`                                                  |
| **Range**     | 0 to 2^N − 1                                         |

| Type       | Max Value                    |
|------------|------------------------------|
| `uint8`    | 255                          |
| `uint16`   | 65,535                       |
| `uint32`   | 4,294,967,295                |
| `uint128`  | 3.4 × 10³⁸                  |
| `uint256`  | 1.16 × 10⁷⁷                 |

```solidity
uint256 public totalSupply;        // default: 0
uint8   public decimals = 18;
```

> ⚠️ Overflow/underflow reverts automatically in Solidity `^0.8.0` (use `unchecked {}` to opt out for gas savings).

**Common Operators:** `+`, `-`, `*`, `/`, `%`, `**`, `<<`, `>>`, `&`, `|`, `^`, `~`

---

### 1.4 Fixed-Point Numbers

| Property      | Detail                                      |
|---------------|---------------------------------------------|
| **Keyword**   | `fixed` / `ufixed` (and `fixedMxN`)         |
| **Status**    | ⚠️ **Partially supported — not yet usable** |
| **Default**   | `0.0`                                        |

```solidity
// Declared but cannot yet be assigned or used in arithmetic
fixed128x18 public price;
```

> ⚠️ Fixed-point types are **declared in the spec but not yet implemented** in the compiler. Use integer arithmetic with a manual scaling factor (e.g., divide by `1e18`) as a workaround.

---

### 1.5 Address

| Property        | Detail                                                  |
|-----------------|---------------------------------------------------------|
| **Keyword**     | `address` / `address payable`                           |
| **Size**        | 20 bytes (160 bits)                                     |
| **Default**     | `address(0)` — the zero address (`0x000…000`)           |
| **Holds**       | Ethereum account or contract address                    |

| Variant           | Can receive ETH | Extra members             |
|-------------------|-----------------|---------------------------|
| `address`         | No              | `.balance`, `.code`       |
| `address payable` | Yes             | `.transfer()`, `.send()`  |

```solidity
address public owner;                        // default: address(0)
address payable public treasury;

// Members
uint256 bal    = owner.balance;
bytes   memory code = owner.code;

// Sending ETH (address payable only)
treasury.transfer(1 ether);                  // reverts on failure
bool ok = treasury.send(1 ether);            // returns false on failure
```

> ✅ Prefer low-level `.call{value: amt}("")` for ETH transfers in modern contracts to avoid gas-limit issues.

---

### 1.6 Bytes (Fixed-size)

| Property    | Detail                                           |
|-------------|--------------------------------------------------|
| **Keyword** | `bytes1`, `bytes2`, … `bytes32`                  |
| **Size**    | 1 → 32 bytes                                     |
| **Default** | All bits zero (`0x00`, `0x0000`, etc.)           |

```solidity
bytes1  public flag;        // default: 0x00
bytes32 public merkleRoot;

// Index access (read-only)
bytes1 firstByte = merkleRoot[0];
```

> ℹ️ `byte` is a deprecated alias for `bytes1`. `bytes32` is the most gas-efficient fixed byte type.

---

### 1.7 Enums

| Property    | Detail                                              |
|-------------|-----------------------------------------------------|
| **Keyword** | `enum`                                              |
| **Size**    | 1 byte (supports up to 256 members)                 |
| **Default** | First member (index `0`)                            |

```solidity
enum Status { Pending, Active, Closed }
//            ↑ default (index 0)

Status public state;          // default: Status.Pending

// Casting
uint8 idx = uint8(state);     // 0
state = Status(1);            // Status.Active
```

---

## 2. Reference Types

Reference types store a **reference (pointer)** to data. Must always declare a **data location**: `storage`, `memory`, or `calldata`.

---

### 2.1 Arrays

#### Fixed-size Array

| Property    | Detail                              |
|-------------|-------------------------------------|
| **Syntax**  | `T[N]`                              |
| **Size**    | `N × sizeof(T)`                     |
| **Default** | Each element set to its type default|

```solidity
uint256[3] public scores;      // [0, 0, 0]
```

#### Dynamic Array

| Property    | Detail                    |
|-------------|---------------------------|
| **Syntax**  | `T[]`                     |
| **Size**    | Variable                  |
| **Default** | Empty (`length == 0`)     |

```solidity
uint256[] public ids;          // []

// Storage array operations
ids.push(42);
ids.pop();
uint256 len = ids.length;
delete ids[0];                 // resets element to 0, does not shift
```

> ℹ️ `memory` arrays must have a fixed size at creation and do **not** support `push`/`pop`.

---

### 2.2 Structs

| Property    | Detail                                         |
|-------------|------------------------------------------------|
| **Keyword** | `struct`                                       |
| **Size**    | Sum of member sizes (with padding)             |
| **Default** | Each field set to its type default             |

```solidity
struct Person {
    string name;
    uint256 age;
    bool isActive;
}

Person public alice;
// alice.name    == ""
// alice.age     == 0
// alice.isActive == false

// Initialization
Person memory bob = Person({ name: "Bob", age: 30, isActive: true });
```

---

### 2.3 Mappings

| Property      | Detail                                                    |
|---------------|-----------------------------------------------------------|
| **Syntax**    | `mapping(KeyType => ValueType)`                           |
| **Location**  | **Storage only** — cannot be in memory or calldata        |
| **Default**   | Any unset key returns the value type's default            |
| **Key types** | Any value type, `bytes`, `string`                         |

```solidity
mapping(address => uint256) public balances;
mapping(address => mapping(address => uint256)) public allowances;  // nested

balances[msg.sender] = 1000;
uint256 val = balances[address(0)];   // returns 0 (default)
```

> ⚠️ Mappings are **not iterable** and have no `.length`. Track keys manually with an array if enumeration is needed.

---

### 2.4 Strings

| Property    | Detail                                    |
|-------------|-------------------------------------------|
| **Keyword** | `string`                                  |
| **Encoding**| UTF-8                                     |
| **Size**    | Dynamic                                   |
| **Default** | `""` (empty string)                       |

```solidity
string public name;            // default: ""
string public symbol = "ETH";

// Concatenation (Solidity ^0.8.12+)
string memory full = string.concat("Hello", " ", "World");

// Length (byte count, not character count)
uint256 byteLen = bytes(symbol).length;
```

> ⚠️ Solidity has no native string comparison. Use `keccak256(bytes(a)) == keccak256(bytes(b))` to compare strings.

---

### 2.5 Bytes (Dynamic)

| Property    | Detail                              |
|-------------|-------------------------------------|
| **Keyword** | `bytes`                             |
| **Size**    | Dynamic                             |
| **Default** | `""` / empty byte array             |

```solidity
bytes public data;             // default: ""

data.push(0xFF);
uint256 len = data.length;

// Conversion
string memory str = string(data);
bytes  memory b   = bytes("hello");
```

> ℹ️ Prefer `bytes` over `byte[]` — it is more gas-efficient because it avoids padding every element to 32 bytes.

---

## 3. Special Types

### 3.1 Function Types

| Property    | Detail                                               |
|-------------|------------------------------------------------------|
| **Syntax**  | `function (...) [visibility] [mutability] [returns]` |
| **Default** | Uninitialized function variable is `address(0)`-like |

```solidity
// Internal function type
function(uint256, uint256) internal pure returns (uint256) public operation;

// External function type
function(uint256) external returns (bool) public callback;
```

| Kind       | Callable from          |
|------------|------------------------|
| `internal` | Same contract + derived|
| `external` | Outside the contract   |

---

## 4. Type Defaults Quick Reference

| Type               | Default Value        | Size               |
|--------------------|----------------------|--------------------|
| `bool`             | `false`              | 1 byte             |
| `int8` … `int256`  | `0`                  | 1 – 32 bytes       |
| `uint8` … `uint256`| `0`                  | 1 – 32 bytes       |
| `address`          | `address(0)`         | 20 bytes           |
| `bytes1` … `bytes32`| `0x00…`             | 1 – 32 bytes       |
| `enum`             | First member (idx 0) | 1 byte             |
| `string`           | `""`                 | Dynamic            |
| `bytes`            | `""`                 | Dynamic            |
| `T[]` (array)      | Empty (`length == 0`)| Dynamic            |
| `T[N]` (array)     | All elements default | N × sizeof(T)      |
| `struct`           | All fields default   | Sum of field sizes |
| `mapping`          | All values default   | Dynamic            |

---

## 5. Data Locations

Reference types must specify where they are stored:

| Location    | Where              | Lifetime           | Cost      | Notes                                      |
|-------------|--------------------|--------------------|-----------|---------------------------------------------|
| `storage`   | Blockchain         | Persistent         | High      | State variables live here by default        |
| `memory`    | RAM (per call)     | During call only   | Low       | Must be declared for reference type params  |
| `calldata`  | Transaction input  | During call only   | Lowest    | Read-only; only for external function params|

```solidity
function example(
    uint256[] calldata input,   // cheapest — read-only from tx
    string memory label         // copied into memory — writable
) external {
    uint256[] storage stored = ids;  // reference to state array
}
```

> ✅ Use `calldata` for external function parameters whenever you don't need to modify them — it avoids a copy and saves gas.

---

*Last updated for Solidity ^0.8.x*