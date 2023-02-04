// SPDX-License-Identifier: UNLICENSED

// DO NOT MODIFY BELOW THIS
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract Splitwise {
    // DO NOT MODIFY ABOVE THIS

    // ADD YOUR CONTRACT CODE BELOW
    mapping(address => mapping(address => uint32)) internal info;

    function lookup(address debtor, address creditor) public view returns (uint32 ret){
        ret = info[debtor][creditor];
    }

    function add_IOU(address creditor, uint32 amount, address[] calldata path, uint32 deductAmount) public {
        // can not credit on oneself
        require(msg.sender != creditor);

        // no path is formed
        if (deductAmount == 0 || path.length == 1) {
            info[msg.sender][creditor] += amount;
        } else {
            // deduct the amount from the current bills
            require(creditor == path[0]);
            require(msg.sender == path[path.length - 1]);
            require(info[msg.sender][creditor] + amount >= deductAmount);
            for (uint i = 0; i < path.length - 1; i++) {
                uint32 tmp = info[path[i]][path[i + 1]];
                require(tmp >= deductAmount);
                info[path[i]][path[i + 1]] -= deductAmount;
            }
            info[msg.sender][creditor] += amount - deductAmount;
        }
    }
}
