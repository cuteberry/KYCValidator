// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//yarn add @chainlink/contracts
import "@chainlink/contracts/src/v0.8/dev/ChainlinkClient.sol";

/**
 * Request testnet LINK and ETH here: https://faucets.chain.link/
 * Find information on LINK Token Contracts and get the latest ETH and LINK faucets here: https://docs.chain.link/docs/link-token-contracts/
 */

/**
 * THIS IS AN EXAMPLE CONTRACT WHICH USES HARDCODED VALUES FOR CLARITY.
 * PLEASE DO NOT USE THIS CODE IN PRODUCTION.
 */
contract KYCValidatorChainlink is ChainlinkClient {
    using Chainlink for Chainlink.Request;
  
    bytes32 public result;
    string public resultStr;

    // This keeps the record on whether the address is KYCed by CB. 
    // It can be expanded to the latest date the user is verified. 
    mapping(address => string) public validatorMap;
    
    mapping(bytes32=>address) public validIds;

    address private owner;
    uint256 private fee;
    
    event logGetOwner(address owner);
    
    event logRequestId(bytes32 queryId);

    event logRetrieveKYCStart(address addr);

    event logAPIResult(string result);

    event logQuery(string query);


    /**
     * Network: Kovan
     * Oracle: 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8 (Chainlink Devrel   
     * Node)
     * Job ID: d5270d1c311941d0b08bead21fea7747
     * Fee: 0.1 LINK
     */
    constructor() payable{
        owner = msg.sender;
        setPublicChainlinkToken();
        fee = 10 ** 18; // (Varies by network and job)
    }
    
    //public function to get the address of the owner.
    function getOwner () public returns (address) {
        emit logGetOwner(owner);
        return owner;
    }

    //public function to update the KYC status of an addtress
    //Within the funciton, it will check whehter the request is coming from CB.
    function retrieveKYC (address oracle, string memory jobId, address targetAddr) public payable{
        //require(owner == msg.sender); 
        bytes32 requestId = retrieveKYCData( oracle, jobId, targetAddr);
        validIds[requestId] = targetAddr;
        emit logRetrieveKYCStart(targetAddr);
        emit logRequestId(requestId);
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

    /**
     * Create a Chainlink request to retrieve API response, find the target
     * data, then multiply by 1000000000000000000 (to remove decimal places from data).
     */
    function retrieveKYCData(address oracle, string memory jobId, address targetAddr) public returns (bytes32 requestId) 
    {
        result = 0;
        Chainlink.Request memory request = buildChainlinkRequest(stringToBytes32(jobId), address(this), this.fulfillBytes.selector);
        
        // Set the URL to perform the GET request on
        string memory urlStr = string(abi.encodePacked("https://my-json-server.typicode.com/cuteberry/demo/0x", _toChecksumString(targetAddr)));
        emit logQuery(urlStr);
        request.add("get", urlStr);
        
        // Set the path to find the desired data in the API response, where the response format is:
        // {"RAW":
        //   {"ETH":
        //    {"USD":
        //     {
        //      "VOLUME24HOUR": xxx.xxx,
        //     }
        //    }
        //   }
        //  }
        request.add("path", "hasKYC");
        
        // Multiply the result by 1000000000000000000 to remove decimals
        // int timesAmount = 10**18;
        // request.addInt("times", timesAmount);
        
        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }
    
    /**
     * Receive the response in the form of uint256
     */ 
    // function fulfill(bytes32 _requestId, uint256 _volume) public recordChainlinkFulfillment(_requestId)
    // {
    //     volume = _volume;
    //     emit logAPIResult(temp);
    //     validatorMap[validIds[_myid]] = _result;
    //     emit logRegisterAddressEnd(validIds[_myid], _result);
    // }
    function fulfillBytes(
        bytes32 requestId,
        bytes32 data
    )
        public
        recordChainlinkFulfillment(requestId)
    {
        result = data;
        resultStr = string(abi.encodePacked(data));
        validatorMap[validIds[requestId]] = resultStr;
    }
    function stringToBytes32(string memory source) public pure returns (bytes32 myResult) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            myResult := mload(add(source, 32))
        }
    }

    // function withdrawLink() external {} - Implement a withdraw function to avoid locking your LINK in the contract
    
    // This contract keeps all Ether sent to it with no way
    // to get it back.
    fallback() external payable {}

    receive() external payable {
        // custom function code
    }

    function withdrawLink() external {}

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
        asciiBytes[2 * i] = bytes1(leftNibble + asciiOffset);

        // get the offset from nibble value to ascii character for right nibble.
        asciiOffset = _getAsciiOffset(rightNibble, rightCaps);

        // add the converted character to the byte array.
        asciiBytes[2 * i + 1] = bytes1(rightNibble + asciiOffset);
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
            accountAddressBytes[(i - 1) / 2] = bytes1(
                16 * nibble + (b - asciiOffset));
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
        asciiBytes[2 * i] = bytes1(leftNibble + (leftNibble < 10 ? 48 : 87));
        asciiBytes[2 * i + 1] = bytes1(rightNibble + (rightNibble < 10 ? 48 : 87));
        }

        return string(asciiBytes);
    }
}