# Solidity Basics

### Value Types

Solidity supports the following value types: `bool`, `int256`/`int`, `uint256`/`uint`, `address`, `bytes` to `bytes32`, and `enum`. They're called value types because their variables will always be passed by value, i.e. they are always copied when they are used as function arguments or in assignments.

**Negation of values** - When we write **`-x`** in Solidity, we're negating a number. It only works for **_signed_** types like int8,int32, int256 etc. To negate a number **x**, **Solidity actually computes 0 - x**.

> `int256` ranges from **`-2^255` to `2^255-1`** whereas `uint256` ranges from **`0` to `2^256-1`**.

### Global variables

- **`msg.sender`** - The address of the account that called the function. It can be a contract or an externally owned account (EOA). In the case of a contract, it is the address of the contract that called the function.

- **`msg.value`** - The amount of Ether (in wei) sent with the transaction. It is a `uint256` value that represents the amount of Ether sent with the transaction.

- **`block.timestamp`** - A `unit256` value that gives timestamp of the current block in seconds since the Unix epoch.

### Functions

**Declaration Syntax**:

```solidity
function (<parameter types>) {public|private|internal|external} [pure|view|payable] [returns (<return types>)]
```

**Visibility**:

- `public`: visible externally and internally (creates a getter function for storage/state variables).
- `private`: only visible in the current contract.
- `external`: only visible externally (only for functions) - i.e. can only be message-called (via this.func).
- `internal` : only visible internally. Internal variables and functions are accessible in the current and child classes

**Other Keywords**:

- **view**: A function marked as pure simply **_reads_** (or **_views_**) data from the blockchain, doesn't update the state on the blockchain. No gas is spent in calling such a function.
- **pure**: A function marked as pure **doesn't allow reading data from the blockchain** nor **modifying the state on the blockchain**. No gas is spent in calling such a function.

> **NOTE: `view` and `pure` functions incur gas costs only when they are called by a state-modifying function from another contract**.

### Struct

```solidity
struct Person {
    uint256 favoriteNumber;
    string name;
}
// Usage
Person public pat = Person({favoriteNumber: 7, name: "Pal" });
// Can also be initialised this way:
Person public pat = Person(7, "Pal");
```

### Data Locations => `calldata` vs `memory` vs `storage`

- `calldata` and `memory`are used define temporary variables in function params. While `memory` can be re-assigned or changed inside the function definition, `calldata` cannot be changed. While using solidity's primtive types (like `uint`) as function params they're automatically assigned as `memory` type, however for special types in solidity like Arrays, Structs and Mapping we need to explicitly mention the data location: `memory`. Since `string` is basically an array of `bytes`, that's why they need to be used with the `memory` keyword.

- `storage` is a keyword used to define permanent variables. Defined outside of the function, in the Contract's scope as a state variable.

### Inheritance

**Solidity Imports**: In order to import a particular contract from a file that has multiple contracts present in it, this is called **_named imports_**, we can simply pick and import a contract like this:

```solidity
progma solidity ^0.8.2
// named import
import { SimpleStorage } from './StorageCollection.sol'
```

**Inheriting a Contract**: When a contract inherits all the functionality of a parent contract, all the non-private functions of its parent can be accessed by the child contract.

> The **_virtual_** keyword is used in a parent contract to allow a function to be overridden, while **_override_** keyword is used in a child contract to provide a new implementation for that function.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract SimpleStorage {
    uint256 myFavNum;

    struct Person {
        uint favNum;
        string name;
    }

    Person[] public people;

    mapping(string => uint) public nameToFavNum;

    function store(uint _myFavNum) public virtual virtual {
        myFavNum = _myFavNum;
    }

    function addPerson(string memory _name, uint _favNum) public {
        people.push(Person({ favNum: _favNum, name: _name } ));
        nameToFavNum[_name] = _favNum;
    }

    function retrieve() public view returns (uint) {
        return myFavNum;
    }
}

// Child Contract
import { SimpleStorage } from "./SimpleStorage.sol";
contract AddFiveSimpleStorage is SimpleStorage {
    function store(uint256 _newNum) public override {
        favNumber = _newNum + 5;
    }
}
```

**Factory Contract**: A factory contract typically deploys other contracts and provides some additional functionality as well.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import { SimpleStorage } from "./SimpleStorage.sol";

contract StorageFactory {
    // If we had a list of contract addresses:
    // address[] public listOfSimpleContracts;
    // we could have accessed SimpleStrorage like this: SimpleStorage(address)
    SimpleStorage[] public listOfSimpleContracts;

    function createSimpleStorageContract() public {
        listOfSimpleContracts.push(new SimpleStorage());
    }

    function sfStore(
        uint256 _simpleStorageIndex,
        uint256 _newSimpleStorageNumber
    ) public {
        // This function interacts with the SimpleStorage Contract functions
        listOfSimpleContracts[_simpleStorageIndex].store(
            _newSimpleStorageNumber
        );
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        return listOfSimpleContracts[_simpleStorageIndex].retrieve();
    }
}
```

### Interface

In Solidity, interfaces define the function signatures that a contract must implement, serving as a blueprint for interaction. Interfaces do not contain any function implementations or state variables. They are primarily used to interact with already deployed contracts by specifying the structure of the contract’s callable external functions.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
  function fund() public payable {
      // To allow deposits only greater than 1 ETH
      require(getConversionRate(msg.value) > 5e18, "Minimum deposit amount is > 5 USD");
  }
  function getPrice() public view returns (uint256) {
      (
          ,
          int256 answer,
          ,
          ,
      ) = /*uint256 startedAt*/
          /*uint256 updatedAt*/
          /*uint80 answeredInRound*/
          AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
              .latestRoundData();
      return uint256(answer * 1e10);
  }
  function getConversionRate(uint256 ethAmount) public view returns (uint256) {
      uint256 ethPrice = getPrice();
      return (ethPrice * ethAmount) / 1e18;
  }
}
```

In the code snippet above, we're wrapping a Chainlink Price Data Feed Contract at `0x694AA1769357215DE4FAC081bf1f309aDC325306` on Ethereum Sepolia Testnet and accessing its function (`latestRoundData`) using the **`AggregatorV3Interface`** that the contract implements.

### Depositing ETH/Native currency to a Contract

In order to allow users to send money to the contract, we need to make a function **_payable_**, then ETH or the native currency of that chain can be sent while calling this function.

### Getting data from an Oracle

A reliable Oracle provider is **Chainlink**. We can use its [**Price Data Feed**](https://docs.chain.link/data-feeds/price-feeds) service to get real-time prices of various crypto pairs. A list of supported pair contracts on Ethereum Sepolia can be found [**here**](https://docs.chain.link/data-feeds/price-feeds/addresses?page=1&testnetPage=1&search=btc%2Fusd#sepolia-testnet).

In order to use a price data feed, we can simply deploy a [**Consumer Contract**](https://docs.chain.link/data-feeds/using-data-feeds#solidity) to read the price data of a pair.

### Creating a Library

We can create libraries to have re-usability in our code.
Here's how the contract code looks before creating a library:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        require(getConversionRate(msg.value) > 5e18, "Minimum deposit amount should be > 5 USD");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    function getPrice() public view returns (uint256) {
        (,int256 answer,,,) = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).latestRoundData();
        return uint256(answer * 1e10);
    }
    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        return (ethPrice * ethAmount) / 1e18;
    }
}
```

After creating the **`PriceConverter.sol`** library:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import { PriceConverter } from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        require(msg.value.getConversionRate() > 5e18, "Minimum deposit amount should be  > 5 USD");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }
}

// PriceConverter.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
  function getPrice() internal view returns (uint256) {
      (,int256 answer,,,) = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).latestRoundData();
      return uint256(answer * 1e10);
  }
  function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
      uint256 ethPrice = getPrice();
      return (ethPrice * ethAmount) / 1e18;
  }
}
```

In the above code, **`using PriceConverter for uint256;`** attaches the functions of the library to anything of the type **`uint256`**, hence it allows us to call **`msg.value.getConversionRate()`** directly.

> **Note:** While calling msg.value.getConversionRate() directly, **`msg.value` gets passed as an argument to the `getConversionRate` function automatically**, and if getConversionRate has a second parameter, then that will need to passed into the parentheses as the first argument.

### SafeMath after solidity v0.8.0

In versions earlier than 0.8.0, checks like the overflow check had to be implemented using the SafeMath library.

```solidity
contract SafeMathTest {

  uint8 public bigNum = 255; // Max uint8 can store is 255.
  function add() public {
    bigNum = bigNum + 1;
  }
}
```

On calling add function, bigNum would get reset to 0 and this behavior was kept in check by using SafeMath library. But on trying to do the same in solidity versions >= 0.8.0, the function call would return an error, hence we don't need to use SafeMath.

> **Note:** In order to execute the reset behavior in solidity versions >=0.8.0 we can wrap the statement in the **`unchecked`** keyword, **`unchecked { bigNum = bigNum + 1; }`**.

> The **_unchecked_** keyword allows developers to bypass built-in overflow checks, potentially improving gas efficiency but increasing the risk of errors.

> Another use of the **_new_** keyword: To reset an array: `funders = new address[](0);`

### Sending funds from Contract

There are 3 ways of sending native funds from a contract:

```solidity
// Transfer - (2300 gas limit) reverts if fails
// msg.sender is of type address
// payable(msg.sender) is of type payable address
// address(this) - refers to the current contract i.e. the source contract.
payable(msg.sender).transfer(address(this).balance)

// Send - (2300 gas limit) returns boolean value
bool sendSuccess = payable(msg.sender).send(address(this).balance);
require(sendSuccess, "Send failed"):

// **Recommended**
// `call` function allows us to call any function without even having its ABI.
// Sends all the gas.
// The empty quotes at the end hold the logic for calling a function, its left empty since we're only transfering ETH. It returns two values, boolean, which returns if the call succeeded and bytes which holds the return value from the function (if any).
(bool callSuccess, bytes memory dataReturned ) = payable(msg.sender).call{value: address(this).balance}("")
require(callSuccess, "call failed"):
```

### Modifiers

Modifiers are functions which can be configured to call before or after a function's execution to perform some action like checking a particular condition etc.

```solidity
function withdraw() public onlyOwner {
  for(uint i = 0; i < funders.length; i++) {
    addressToAmountFunded[funders[i]] = 0;
  }
  funders = new address[](0);

  (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
  require(callSuccess, "call failed");
}

modifier onlyOwner() {
  require(msg.sender == owner, "Sender is not owner!");
  _;
}
```

The order in which the `_;` is placed inside the modifier definition decides the order of execution of modifier and the function on which it is attached.

If the `_;` is above the require statement, the function will be executed first and then modifier wll be executed. If it's the other way round, the modifier will be executed first and then modifier wll be executed and then once the function finishes execution the modifier is checked for any remaining code.

```solidity
// Function executes first in this case, then modifier
modifier onlyOwner() {
  _;
  require(msg.sender == owner, "Sender is not owner!");
}

// Modifier executes first in this case, then function
modifier onlyOwner() {
  require(msg.sender == owner, "Sender is not owner!");
  _;
}
```

> **_Gas Optimisation notes_**:

1. Using the **_constant_** keyword: Variables that are given a fixed value at their definition itself should be defined as a constant for lower gas costs. They're written in uppercase.

2. Using the **_immutable_** keyword: Variables that are assigned a value only once inline or in the constructor, should be set as **_immutable_**. They're prefixed with **`i_`**.

The reason behind the gas savings in the above two cases is that such variables are stored directly in the bytecode of the contract instead of a storage slot.

```solidity
uint256 public constant MIN_USD = 50 * 1e18;
address public immutable i_owner;
```

3. **Using custom errors instead of strings in require statements**: These custom errors are defined outside the contract body.
   Custom errors can also hold arguments, for example: `error ExceedsMaxLimit(uint256 maxAllowed);`

```solidity
error NotOwner();

contract FundMe {
  modifier onlyOwner() {
    // require(msg.sender == i_owner, NotOwner() );   // can also be used inside require
    if (msg.sender != i_owner) { revert NotOwner(); }
    _;
  }
}
```

### receive() vs fallback()

When someone sends ETH to a contract without calling a particular function, the receive function is invoked, if it is defined. If ETH is sent to the contract along with some function data/call data, then the fallback function is invoked, if defined.

- **receive()** - invoked when someone sends ETH to the contract without a function call i.e. data = "".

- **fallback()** - invoked when someone send ETH along with some call data.

The final version of a sample contract which includes some key concepts learnt so far:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import { PriceConverter } from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    address[] public funders;
    using PriceConverter for uint256;
    address public immutable i_owner;
    uint256 public constant MIN_USD = 50 * 1e18;

    mapping(address => uint256) public addressToAmountFunded;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() > MIN_USD, "Minimum deposit amount should be > 5 USD");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    function withdraw() public onlyOwner {
       for(uint i = 0; i < funders.length; i++) {
            addressToAmountFunded[funders[i]] = 0;
        }
        funders = new address[](0);

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "call failed");
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, NotOwner() );
        if (msg.sender != i_owner) { revert NotOwner(); }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
```
