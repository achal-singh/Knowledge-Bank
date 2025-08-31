<p align="center">
  <a href="#"><img src="https://avatars.githubusercontent.com/u/99892494?s=100" alt="foundry" /></a>
</p><h1 align="center">Foundry</h1>

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust. Documentation can be found [here](https://book.getfoundry.sh/)**.

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Usage

### Build, Test, Format, Gas Snapshots & Deploy commands

```shell
$ forge build
$ forge test
$ forge fmt
$ forge snapshot
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

### `forge build`

- Compiles all the Solidity files in the src/ directory.
- Produces compiled artifacts (bytecode, ABI, metadata) into the **`out/`** directory.

## Setup & Contract Deployment

Install the latest version of Foundry from **[here](https://getfoundry.sh/)** and verufy the installation.

- Initialise a project using: **`forge init`**
- Start anvil in a separate terminal, by default it'll run on **`http://localhost:8545`**.
- To deploy a contract (present under **`src/`**):
  ```bash
  forge create SimpleStorage --interactive --broadcast
  ```
  **Note:**
  - Without **`--broadcast`**, the deployment transaction will dry run.
  - To send the transaction to a custom RPC, use the **`--rpc-url`** flag, the command above automatically sends it to **anvil** (`http://localhost:8545`).
  - **`--interactive**`\*\* flag opens an interactive CLI option to input the private key, when we deploy to a custom RPC.

## Writing Scripts using Solidity

Solidity can also be used to write scripts like a deploy script. We can create such files with a **`.s.sol`** extension (foundry's convention) under the **`scripts/`** folder.
Example: Script file named **`DeploySimpleStorage.s.sol`**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {Script} from "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
  function run() external returns (SimpleStorage) {
    vm.startBroadcast();
    SimpleStorage simpleStorage = new SimpleStorage();
    vm.stopBroadcast();
    return simpleStorage;
  }
}
```

In the script above, as per forge's convention we specify the code we wish to deploy on-chain inside the **`run`** function between **`vm.startBroadcast();`** and **`vm.stopBroadcast();`**. In this case, we're simply deploying the **`SimpleStorage.sol`** contract.
While deploying through the script, we don't need to keep the anvil daemon running, we can run the following command without anvil running in the background

```bash
forge script script/DeploySimpleStorage.s.sol
```

> **Note:** In Foundry, if we do not specify the **`--rpc-url`**, then it gets deployed to a temporary anvil chain, the transaction is executed and the response is returned and at the end the temporary chain is destroyed.
> To deploy to an RPC with a certain private key we can do:

```bash
forge script script/DeploySimpleStorage.s.sol --rpc-url http://localhost:8545 --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

# More Secure way to do this is by creating a keystore using cast (shown in the next section)
# Using the keystore in the deploy script
forge script script/DeploySimpleStorage.s.sol --rpc-url http://localhost:8545 --account firstKey --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --broadcast
```

> **TIP:** Store private keys and RPC URL in a .env file and run **`source .env`** in terminal to directly access them in the CLI commands using `$PRIVATE_KEY` and `$RPC_URL`.

## Cast Utility functions

- **Hex to Decimal**: **`cast --to-base <hex_value> dec`**. Example: `cast --to-base 0x111 dec` => **273**.

- **Keystore for Private Keys**: **`cast wallet import <key-name> --interactive`**. List all such wallets: **`cast wallet list`**. Wallets are stored at **`~/.foundry/keystores`**.
  Usage example:

  ```bash
  # Creating a keystore for private key
  cast wallet import firstKey --interactive
  # Output: `firstKey` keystore was saved successfully. Address: 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266

  # Using this keystore in the deploy script
  forge script script/DeploySimpleStorage.s.sol --rpc-url http://localhost:8545 --account firstKey --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --broadcast
  ```

- **Read Contract Data & Sign and Publish Transactions**: To do this cast has a function called **`send`**.

  ##### To Invoke a state-changing function of a Smart Contract: **`cast send <contract_address> <function-signature> <function-args> --rpc-url $RPC_URL --account <keystore-name>`**.

  ##### To read data: **`cast call <contract-address> <function-signature> <function-args>`**

  Usage example:

  ```bash
  # Sign & Publish
  cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "store(uint256)" 4476 --rpc-url $RPC_URL --account firstKey

  # Read
  cast call 0x5FbDB2315678afecb367f032d93F642f64180aa3 "retrieve()"
  ```

## Forge Install

The **`forge install`** command is used to install any smart contract related dependencies from github. For example, in the **PriceConverter.sol** contract, while remix is able to fetch from @chainlink contracts directly:

```solidity
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
```

In **foundry** these contracts need to be installed from **[Github](https://github.com/smartcontractkit/chainlink-brownie-contracts)** via:

```bash
 forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-git
```

These dependencies are stored under the `lib/` directory of the project.

## Writing tests for Smart Contracts

Test files have a **`.t.sol`** extension and are defined under the `test/` directory.
While writing a test file take care of the following:

1. **`setUp()`** function must be defined, foundry calls it before every test function. It can initialize contracts, deploy dependencies, or set starting balances.
2. Every test function should begin with the name **`"test"`** or else it won't be executed by Foundry.

Example:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";

contract FundMeTest is Test {
  uint256 number = 0;

  function setUp() external {
    number = 2;
  }

  function testDemo() public {
    console.log('Hey');
    console.log(number);
    assertEq(number, 2);
  }
}
```

In order to see console messages defined above, the test must be run like this: **`forge test -vv`**. **`-vv`** defines the log visibility, it goes from `-v` to `-vvvvv`.

- **Level 2 (-vv)**: Logs emitted during tests are also displayed.
- **Level 3 (-vvv)**: Stack traces for failing tests are also displayed.
- **Level 4 (-vvvv)**: Stack traces for all tests are displayed, and setup traces for failing tests are displayed.
- **Level 5 (-vvvvv)**: Stack traces and setup traces are always displayed.

> Note:
>
> 1. When we don't supply an RPC url with the test command, foundry defaults to creating a temporary anvil chain, executes the test, and then destroys the anvil chain.
> 2. On applying 4 v's (-vvvv) the command prints out the stack trace of the execution.

- **Run a specific test function (using `--match-test` or `--mt`):** In order to run a particular test function instead of the whole test file, we can run: **`forge test --mt <function-name>`**.

#### What can we do to work with addresses outside our system?

1. **Unit** - Testing a specific part of our code.
2. **Integration** - Testing how our code works with other parts of our code.
3. **Forked** - Testing our code on a simulated real environment.
4. **Staging** - Testing our code in a real environment that is not prod.
   To run a test, say on a test chain, we supply the `--fork-url` or `--rpc-url`, both do the same thing.

For example: In order to test the FundMe contract on Sepolia Testnet:

- We'll fork the Sepolia testnet's state locally via Anvil using this command:
  ```bash
  forge test --rpc-url $ALCHEMY_SEPOLIA_RPC_URL
  # OR
  forge test --fork-url $ALCHEMY_SEPOLIA_RPC_URL
  ```

#### Foundry Cheatcodes

- **vm.startBroadcast**: Marks the beginning from where code is executed on the network or on-chain.

- **vm.stopBroadcast**: Marks the end till which code is executed on the network or on-chain, after this no-code is executed on-chain.

- **vm.expectRevert**: Helps in asserting if a revert was thrown after it in a test function.

- **vm.prank(address)**: Sets a mock user/address which sends the transactions.
  Example:

  ```solidity
  // makeAddr is a function from forge-std/Test.sol
  // creates an address out of the given string
  address USER = makeAddr("user");
  vm.prank(USER);
  ```

- **vm.startPrank**: While `vm.prank` applies only to the next call, `vm.startPrank` applies to all subsequent calls until `vm.stopPrank` is invoked.

- **vm.deal(address, uint256)**: Funds (ETH) the given address with the given balance for testing purposes. Ex: **`vm.deal(USER, 1 ether);`**

- **hoax(address, uint256)**: This performs **prank** and **deal** at once.

#### Using modifiers in the test code:

Instead of writing the same set of code before running a test we can define a set of functions that we wish to execute as a pre-requisite before running a test in a **modifier** file in the test file and then use it in any test function.
Example:

```solidity
// Here if we wish set the USER and call the 'fund' function with some ETH
// we can simply define these 2 lines in a modifier and use them in test functions.
 function testAddsFunderToArrayOfFunders() public funded {
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

  modifier funded() {
      vm.prank(USER);
      fundMe.fund{value: SEND_VALUE}();
      _;
  }

  function testOnlyOwnerCanWithdraw() public funded {
      vm.expectRevert();
      vm.prank(USER);
      fundMe.withdraw();
  }
```

#### Gas optimisation in Foundry:

- Gas usage by a particular test function can be checked by running: **`forge snapshot -m testFunctionName`**. To fetch gas estimates for all the functions just run: `forge snapshot`. This outputs a `.gas-snapshot` file.

- **`vm.txGasPrice(GAS_PRICE)`** is a cheatcode that foundry offers to simulate gas costs in the test setup, as the gas cost defaults to 0 in Anvil. We can use solidity's built-in **`gasleft();`** function and **`tx.gasprice`** to check gas usage by an operation.

```solidity
// Act
uint256 gasStart = gasleft();
vm.txGasPrice(GAS_PRICE);

vm.prank(fundMe.i_owner());
fundMe.withdraw();

uint256 gasEnd = gasleft();
uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
console.log("Gas used: ", gasUsed);
```

- **Immutables** and **constants** are not stored in storage slots of the contract, they're part of the bytecode of the contract itself.

- While working with **strings**, **bytes**, **structs** and **arrays**, solidity needs to know where it needs to make storage provisions for it as they're dynamically sized, that's why when using these types inside a function we need to specify the **_memory_** keyword.

- The storage layout of a contract can be studied using the command: **`forge inspect <ContractName> storageLayout`**.

- To query the storage slot (a storage slot index) of a contract on mainnet: **`cast storage <contract_address> <storage_slot_index>`**. **Note:** If we're connected to Etherscan, we don't need to mention the storage slot index.

- Reference for gas costs associated to various OPCODES: **[evm.codes](https://www.evm.codes/)**.

- It's a good practice to limit/optimise the number of read operations from storage variables as each read operation incurs a 100 gas cost.

### Integration Tests

These tests can be accomodated in a separate folder named `integration` under the `test/` folder, not a convention though.

Create a script file under `src/`, say `Interactions.s.sol` with the following code.

```solidity
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
// The following helps with checking the latest contract deployments.
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract FundFundMe is Script {
  uint256 constant SEND_VALUE = 0.01 ether;

  function fundFundMe(address mostRecentlyDeployed) public {
    vm.startBroadcast();
    FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
    vm.stopBroadcast();
    console.log("Funded FundMe with %s", SEND_VALUE);
  }
  function run() external {
    address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
    fundFundMe(mostRecentlyDeployed);
  }
}
```

We can run the integration test for the funding operation using: `forge script script/Interactions.s.sol:FundFundMe`. Integration tests will also be executed in the **`forge test`** command along with unit tests.

### Makefile

A Makefile allows us to create shortcuts for commands we are going to commonly use.
A detailed Makefile is mentioned [here](https://github.com/Cyfrin/foundry-fund-me-cu/blob/main/Makefile).

> **Command:** `make [command-name]`. Example: `make test`.

**`.PHONY`** in the above mentioned Makefile tells make that all the names mentioned there are not folders.

Makefile directly accesses the .env, using the -include statement on top, making it easier to access env values.
A more detailed and comprehensive Makefile is given **[here](https://github.com/Cyfrin/foundry-fund-me-cu/blob/main/Makefile)**.

### Verifying a contract

We can deploy and **verify** a contract at the same time, using the following command, (command deploys the `FundMe` contract):

```bash
forge script script/DeployFundMe.s.sol --rpc-url ${SEPOLIA_RPC} --account firstKey --broadcast --verify --etherscan-api-key ${ETHERSCAN_API_KEY}
```

### Computing the function selector using `cast`

Returns the function signature for the function name. This is suitable for functions with no arguments.
`cast sig "<FUNCTION_NAME>"`

```bash
cast sig "fund()" # 0xb60d4288
```

## The CEI Pattern: Checks, Effects and Interactions

- **`Checks`**: Validate all preconditions first (e.g., require statements to ensure inputs are valid, caller has permissions, balances are sufficient).
- **`Effects`**: Update the contract’s internal state variables (like balances, mappings, counters) before making any external calls.
- **`Interactions`**: Finally, interact with external contracts or transfer ETH/tokens (since these are the riskiest operations and can open up reentrancy vulnerabilities).
