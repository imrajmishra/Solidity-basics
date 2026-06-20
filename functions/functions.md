# Solidity Functions — Reference Guide

> Compiler version referenced: **^0.8.x**

---

## Table of Contents

1. [Function Syntax](#1-function-syntax)
2. [Visibility](#2-visibility)
3. [State Mutability](#3-state-mutability)
4. [Return Values](#4-return-values)
5. [Function Modifiers](#5-function-modifiers)
6. [Special Functions](#6-special-functions)
7. [Function Overloading](#7-function-overloading)
8. [Function Types](#8-function-types)
9. [Quick Reference Table](#9-quick-reference-table)

---

## 1. Function Syntax

```solidity
function <name>(<parameters>)
    <visibility>
    <state-mutability>
    [modifier(s)]
    [returns (<return-types>)]
{
    // body
}
```

**Example:**
```solidity
function add(uint256 _a, uint256 _b)
    public
    pure
    returns (uint256)
{
    return _a + _b;
}
```

> ℹ️ Parameter names prefixed with `_` (e.g. `_amount`) is a common convention to distinguish them from state variables.

---

## 2. Visibility

Controls **who can call** the function.

| Visibility   | Same Contract | Derived Contract | Other Contracts | Externally (EOA) |
|--------------|:---:|:---:|:---:|:---:|
| `public`     | ✅  | ✅  | ✅  | ✅  |
| `external`   | ❌  | ❌  | ✅  | ✅  |
| `internal`   | ✅  | ✅  | ❌  | ❌  |
| `private`    | ✅  | ❌  | ❌  | ❌  |

```solidity
function publicFn()   public   {}   // callable from anywhere
function externalFn() external {}   // only from outside the contract
function internalFn() internal {}   // only this + child contracts
function privateFn()  private  {}   // only this contract
```

> ✅ Prefer `external` over `public` for functions only called from outside — it's more gas-efficient since it reads params directly from `calldata`.

---

## 3. State Mutability

Controls **what the function can do** with the blockchain state.

| Keyword    | Reads State | Modifies State | Costs Gas (when called externally) |
|------------|:-----------:|:--------------:|:----------------------------------:|
| _(none)_   | ✅          | ✅             | ✅ Yes                             |
| `view`     | ✅          | ❌             | ❌ No (free if called externally)  |
| `pure`     | ❌          | ❌             | ❌ No (free if called externally)  |
| `payable`  | ✅          | ✅             | ✅ Yes (can receive ETH)           |

```solidity
uint256 public count = 0;

// No keyword — reads and writes state
function increment() public {
    count += 1;
}

// view — reads state, does not modify
function getCount() public view returns (uint256) {
    return count;
}

// pure — neither reads nor writes state
function multiply(uint256 _a, uint256 _b) public pure returns (uint256) {
    return _a * _b;
}

// payable — can receive ETH
function deposit() public payable {
    // msg.value holds the ETH sent
}
```

> ⚠️ Calling a `view` or `pure` function **from another contract or transaction** still costs gas. "Free" only applies to direct external read calls (no state change).

---

## 4. Return Values

### Single Return

```solidity
function getAge() public view returns (uint256) {
    return 22;
}
```

### Multiple Returns

```solidity
function getInfo() public view returns (string memory, uint256, bool) {
    return ("Raj", 22, true);
}

// Destructuring
(string memory name, uint256 age, bool active) = getInfo();
```

### Named Returns

```solidity
function getCoords() public pure returns (uint256 x, uint256 y) {
    x = 10;
    y = 20;
    // implicit return — no `return` statement needed
}
```

> ℹ️ Named returns improve readability and allow implicit returns, but explicit `return` still works with them.

---

## 5. Function Modifiers

Reusable logic that runs **before (and/or after)** a function body. The `_;` placeholder marks where the function body executes.

### Defining and Using

```solidity
address public owner;

modifier onlyOwner() {
    require(msg.sender == owner, "Not the owner");
    _;   // function body runs here
}

function withdraw() public onlyOwner {
    // only owner can reach this
}
```

### Modifier with Parameters

```solidity
modifier minAmount(uint256 _min) {
    require(msg.value >= _min, "Too little ETH");
    _;
}

function buy() public payable minAmount(0.01 ether) {
    // body
}
```

### Post-execution Logic

```solidity
modifier log() {
    _;               // function body runs first
    emit Called();   // then this runs after
}
```

### Chaining Modifiers

```solidity
function sensitiveAction()
    public
    onlyOwner
    minAmount(1 ether)
{
    // both modifiers applied left to right
}
```

---

## 6. Special Functions

### `constructor`

Runs **once** at deployment. Used to initialize state.

```solidity
address public owner;

constructor(address _owner) {
    owner = _owner;
}
```

> ℹ️ If no constructor is defined, Solidity generates a default one with no parameters.

---

### `receive`

Called when ETH is sent to the contract **with no calldata**.

```solidity
event Received(address sender, uint256 amount);

receive() external payable {
    emit Received(msg.sender, msg.value);
}
```

---

### `fallback`

Called when:
- No function signature matches the call, **or**
- ETH is sent with calldata but no `receive` exists

```solidity
fallback() external payable {
    // handle unknown calls
}
```

| Scenario                          | Function called  |
|-----------------------------------|------------------|
| ETH sent, no calldata             | `receive`        |
| ETH sent, with calldata           | `fallback`       |
| Unknown function called           | `fallback`       |
| No `receive`, ETH sent no data    | `fallback`       |

---

### `getter` (auto-generated)

`public` state variables automatically get a free getter function:

```solidity
uint256 public count = 5;
// Solidity auto-generates:
// function count() external view returns (uint256) { return count; }
```

---

## 7. Function Overloading

Same function name, different parameter types. Solidity resolves at compile time.

```solidity
function store(uint256 _val) public {
    // stores a number
}

function store(string memory _val) public {
    // stores a string
}
```

> ⚠️ Return type alone cannot distinguish overloaded functions — parameter types must differ.

---

## 8. Function Types

Functions can be stored in variables and passed around.

```solidity
// Internal function type
function(uint256, uint256) internal pure returns (uint256) public operation;

// Assigning
operation = add;

function add(uint256 a, uint256 b) internal pure returns (uint256) {
    return a + b;
}

// Calling
uint256 result = operation(3, 4);  // 7
```

---

## 9. Quick Reference Table

| Feature          | Keyword(s)                          | Key Point                                      |
|------------------|-------------------------------------|------------------------------------------------|
| Visibility       | `public` `external` `internal` `private` | Controls who can call the function        |
| Read-only        | `view`                              | Can read state, cannot modify                  |
| No state access  | `pure`                              | Cannot read or modify state                    |
| Receive ETH      | `payable`                           | Function can accept ETH via `msg.value`        |
| Reusable checks  | `modifier`                          | Wraps function with pre/post logic             |
| Deploy-time init | `constructor`                       | Runs once at contract creation                 |
| ETH receiver     | `receive`                           | Triggered on plain ETH transfers               |
| Catch-all        | `fallback`                          | Triggered on unknown calls or ETH with data    |
| Multiple returns | `returns (T1, T2, …)`               | Destructure with `(a, b) = fn()`               |
| Named returns    | `returns (uint256 x)`               | Allows implicit return without `return` stmt   |
| Overloading      | _(same name, diff params)_          | Resolved at compile time by parameter types    |

---

*Last updated for Solidity ^0.8.x*