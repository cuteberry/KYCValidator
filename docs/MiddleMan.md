## `MiddleMan`


### `onlyOwner()`

### `getOwner() → address` (external)
Get the owner of the smart contract

address: The address of the owner for ContractRegister

### `enroll() → bool` (public)
Enroll a customer with the middleman when it's requested by owner

bool: The users enrolled status

### `withhold(address receiver)` (public)
Withhold the value for reciever from sender when the sender is enrolled

receiver: the address of the receiver

### `refundSender(address receiver) → bool` (public)
Refund the value to the sender for the reciever when the sender is enrolled

receiver: the address of the receiver

bool: the bool value whether the refund has been successful

### `distributeToReceiver(address payable receiver) → bool` (public)
Distribute the value to the reciever when the sender is enrolled

receiver: the address of the receiver

bool: The bool value whether the distribution has been successful

### `getContractBalance() → uint256` (external)
Get the balance of the MiddleMan contract

uint: The balance of the contract

### `getBalanceForReceiver(address receiver) → uint256` (public)
Get the balance for the receiver from sender 

receiver: the address of the reciever

uint: The balance for the receiver from sender

### `balanceOf(address addr) → uint256` (public)
Get the balance for an address

addr: the address of an account

uint: The balance for the address

### `fallback()` (external)

### `receive()` (external)


### `LogEnrolled(address accountAddress)`

Add an argument for this event, an accountAddress






