// SPDX-License-Identifier: MIT
pragma solidity >0.6.1 <0.9.0;

//import "https://github.com/oraclize/ethereum-api/oraclizeAPI_0.5.sol";

import "./imported/provableAPI.sol"; 

contract KYCValidatorWithAPICall is usingProvable {
    uint constant public gasLimit = 187123;
    uint256 public priceOfUrl;
    string public temp;
    
    address private owner;

    // This keeps the record on whether the address is KYCed by CB. 
    // It can be expanded to the latest date the user is verified. 
    mapping(address => string) private validatorMap;
    
    mapping(bytes32=>address) validIds;

    event logResult(string result); 

    event logGetAddress(address addr);

    event logGetOwner(address owner);

    event logValidate(address addr, string validated);
    
    event logRegisterAddressStart(address target);
    
    event logRegisterAddressEnd(address target, string validated);
    
    event logNewProvableQuery(string result);

    event logAPIResult(string result);
    
    event logQueryId(bytes32 queryId);
    
    event logQuery(string query);

    event logPrice(uint256 price); 

    //public function to get the address of the owner.
    function getOwner () public returns (address) {
        emit logGetOwner(owner);
        return owner;
    }
    
    constructor() public payable{
        owner = msg.sender;

        // Ropsten test net 
        provable_setCustomGasPrice(2000001234);
        OAR = OracleAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
    }
    
    //public function to update the KYC status of an addtress
    //Within the funciton, it will check whehter the request is coming from CB.
    function retrieveKYC (address targetAddr) public payable{
        //require(owner == msg.sender); 
        retrieveKYCData(targetAddr);
        emit logRegisterAddressStart(targetAddr);
        //todo: charge gas from target
    }

    //public function to validate the target address 
    //Within the funciton, it will check whehter the request is coming from CB.
    function hasKYC (address targetAddr) public view returns (string memory) {
        //require(owner == msg.sender); 
        //todo: charge gas from target

        //emit logValidate(targetAddr, validatorMap[targetAddr]);
        return validatorMap[targetAddr];
    }
    function getTemp () public view returns (string memory) {
        //require(owner == msg.sender); 
        //todo: charge gas from target

        //emit logValidate(targetAddr, validatorMap[targetAddr]);
        return temp;
    }

    function retrieveKYCData (address targetAddr) public payable
    {
        // if (provable_getPrice("URL") > address(this).balance) {
        //     emit logNewProvableQuery("Provable query was NOT sent, please add some ETH to cover for the query fee");
        // } else {
        //     emit logNewProvableQuery("Provable query was sent, standing by for the answer..");
            //bytes32 queryId = provable_query("URL", "json(https://api.pro.coinbase.com/products/ETH-USD/ticker).price");
            //bytes32 queryId = provabçe_query("URL", "json(https://retoolapi.dev/3ZrGtV/data/1).passedIDV");
            
            //https://my-json-server.typicode.com/cuteberry/demo/address1

            priceOfUrl = provable_getPrice("URL");
            emit logPrice(priceOfUrl);
            string memory urlStr = string(abi.encodePacked("json(https://my-json-server.typicode.com/cuteberry/demo/0x", _toChecksumString(targetAddr), ").hasKYC"));
            emit logQuery(urlStr);
            bytes32 queryId = provable_query("URL", urlStr, 200000);
            emit logQueryId(queryId);
            validIds[queryId] = targetAddr;
        // }
    }
    function __callback (
        bytes32 _myid,
        string memory _result
    )
        public 
    {
        //require(msg.sender == provable_cbAddress());
        temp = _result;
        emit logAPIResult(temp);
        validatorMap[validIds[_myid]] = _result;
        emit logRegisterAddressEnd(validIds[_myid], _result);
        //delete validIds[_myid];
    }
    function toAsciiString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2*i] = char(hi);
            s[2*i+1] = char(lo);            
        }
        return string(s);
    }
    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }

    // This contract keeps all Ether sent to it with no way
    // to get it back.
    fallback() external payable {}

    receive() external payable {
        // custom function code
    }

    /**
   * @dev Get a checksummed string hex representation of an account address.
   * @param account address The account to get the checksum for.
   * @return accountChecksum The checksummed account string in ASCII format. Note that leading
   * "0x" is not included.
   */
  function getChecksum(
    address account
  ) public pure returns (string memory accountChecksum) {
    // call internal function for converting an account to a checksummed string.
    return _toChecksumString(account);
  }

  /**
   * @dev Get a fixed-size array of whether or not each character in an account
   * will be capitalized in the checksum.
   * @param account address The account to get the checksum capitalization
   * information for.
   * @return characterCapitalized A fixed-size array of booleans that signify if each character or
   * "nibble" of the hex encoding of the address will be capitalized by the
   * checksum.
   */
  function getChecksumCapitalizedCharacters(
    address account
  ) external pure returns (bool[40] memory characterCapitalized) {
    // call internal function for computing characters capitalized in checksum.
    return _toChecksumCapsFlags(account);
  }

  /**
   * @dev Determine whether a string hex representation of an account address
   * matches the ERC-55 checksum of that address.
   * @param accountChecksum string The checksummed account string in ASCII
   * format. Note that a leading "0x" MUST NOT be included.
   * @return ok A boolean signifying whether or not the checksum is valid.
   */
  function isChecksumValid(
    string calldata accountChecksum
  ) external pure returns (bool ok) {
    // call internal function for validating checksum strings.
    return _isChecksumValid(accountChecksum);
  }

  function _toChecksumString(
    address account
  ) internal pure returns (string memory asciiString) {
    // convert the account argument from address to bytes.
    bytes20 data = bytes20(account);

    // create an in-memory fixed-size bytes array.
    bytes memory asciiBytes = new bytes(40);

    // declare variable types.
    uint8 b;
    uint8 leftNibble;
    uint8 rightNibble;
    bool leftCaps;
    bool rightCaps;
    uint8 asciiOffset;

    // get the capitalized characters in the actual checksum.
    bool[40] memory caps = _toChecksumCapsFlags(account);

    // iterate over bytes, processing left and right nibble in each iteration.
    for (uint256 i = 0; i < data.length; i++) {
      // locate the byte and extract each nibble.
      b = uint8(uint160(data) / (2**(8*(19 - i))));
      leftNibble = b / 16;
      rightNibble = b - 16 * leftNibble;

      // locate and extract each capitalization status.
      leftCaps = caps[2*i];
      rightCaps = caps[2*i + 1];

      // get the offset from nibble value to ascii character for left nibble.
      asciiOffset = _getAsciiOffset(leftNibble, leftCaps);

      // add the converted character to the byte array.
      asciiBytes[2 * i] = byte(leftNibble + asciiOffset);

      // get the offset from nibble value to ascii character for right nibble.
      asciiOffset = _getAsciiOffset(rightNibble, rightCaps);

      // add the converted character to the byte array.
      asciiBytes[2 * i + 1] = byte(rightNibble + asciiOffset);
    }

    return string(asciiBytes);
  }

  function _toChecksumCapsFlags(address account) internal pure returns (
    bool[40] memory characterCapitalized
  ) {
    // convert the address to bytes.
    bytes20 a = bytes20(account);

    // hash the address (used to calculate checksum).
    bytes32 b = keccak256(abi.encodePacked(_toAsciiString(a)));

    // declare variable types.
    uint8 leftNibbleAddress;
    uint8 rightNibbleAddress;
    uint8 leftNibbleHash;
    uint8 rightNibbleHash;

    // iterate over bytes, processing left and right nibble in each iteration.
    for (uint256 i; i < a.length; i++) {
      // locate the byte and extract each nibble for the address and the hash.
      rightNibbleAddress = uint8(a[i]) % 16;
      leftNibbleAddress = (uint8(a[i]) - rightNibbleAddress) / 16;
      rightNibbleHash = uint8(b[i]) % 16;
      leftNibbleHash = (uint8(b[i]) - rightNibbleHash) / 16;

      characterCapitalized[2 * i] = (
        leftNibbleAddress > 9 &&
        leftNibbleHash > 7
      );
      characterCapitalized[2 * i + 1] = (
        rightNibbleAddress > 9 &&
        rightNibbleHash > 7
      );
    }
  }

  function _isChecksumValid(
    string memory provided
  ) internal pure returns (bool ok) {
    // convert the provided string into account type.
    address account = _toAddress(provided);

    // return false in the event the account conversion returned null address.
    if (
      account == address(0)
    ) {
      // ensure that provided address is not also the null address first.
      bytes memory b = bytes(provided);
      for (uint256 i; i < b.length; i++) {
        if (b[i] != hex"30") {
          return false;
        }
      }
    }

    // get the capitalized characters in the actual checksum.
    string memory actual = _toChecksumString(account);

    // compare provided string to actual checksum string to test for validity.
    return (
      keccak256(
        abi.encodePacked(
          actual
        )
      ) == keccak256(
        abi.encodePacked(
          provided
        )
      )
    );
  }

  function _getAsciiOffset(
    uint8 nibble, bool caps
  ) internal pure returns (uint8 offset) {
    // to convert to ascii characters, add 48 to 0-9, 55 to A-F, & 87 to a-f.
    if (nibble < 10) {
      offset = 48;
    } else if (caps) {
      offset = 55;
    } else {
      offset = 87;
    }
  }

  function _toAddress(
    string memory account
  ) internal pure returns (address accountAddress) {
    // convert the account argument from address to bytes.
    bytes memory accountBytes = bytes(account);

    // create a new fixed-size byte array for the ascii bytes of the address.
    bytes memory accountAddressBytes = new bytes(20);

    // declare variable types.
    uint8 b;
    uint8 nibble;
    uint8 asciiOffset;

    // only proceed if the provided string has a length of 40.
    if (accountBytes.length == 40) {
      for (uint256 i; i < 40; i++) {
        // get the byte in question.
        b = uint8(accountBytes[i]);

        // ensure that the byte is a valid ascii character (0-9, A-F, a-f)
        if (b < 48) return address(0);
        if (57 < b && b < 65) return address(0);
        if (70 < b && b < 97) return address(0);
        if (102 < b) return address(0); //bytes(hex"");

        // find the offset from ascii encoding to the nibble representation.
        if (b < 65) { // 0-9
          asciiOffset = 48;
        } else if (70 < b) { // a-f
          asciiOffset = 87;
        } else { // A-F
          asciiOffset = 55;
        }

        // store left nibble on even iterations, then store byte on odd ones.
        if (i % 2 == 0) {
          nibble = b - asciiOffset;
        } else {
          accountAddressBytes[(i - 1) / 2] = (
            byte(16 * nibble + (b - asciiOffset)));
        }
      }

      // pack up the fixed-size byte array and cast it to accountAddress.
      bytes memory packed = abi.encodePacked(accountAddressBytes);
      assembly {
        accountAddress := mload(add(packed, 20))
      }
    }
  }

  // based on https://ethereum.stackexchange.com/a/56499/48410
  function _toAsciiString(
    bytes20 data
  ) internal pure returns (string memory asciiString) {
    // create an in-memory fixed-size bytes array.
    bytes memory asciiBytes = new bytes(40);

    // declare variable types.
    uint8 b;
    uint8 leftNibble;
    uint8 rightNibble;

    // iterate over bytes, processing left and right nibble in each iteration.
    for (uint256 i = 0; i < data.length; i++) {
      // locate the byte and extract each nibble.
      b = uint8(uint160(data) / (2 ** (8 * (19 - i))));
      leftNibble = b / 16;
      rightNibble = b - 16 * leftNibble;

      // to convert to ascii characters, add 48 to 0-9 and 87 to a-f.
      asciiBytes[2 * i] = byte(leftNibble + (leftNibble < 10 ? 48 : 87));
      asciiBytes[2 * i + 1] = byte(rightNibble + (rightNibble < 10 ? 48 : 87));
    }

    return string(asciiBytes);
  }
}

