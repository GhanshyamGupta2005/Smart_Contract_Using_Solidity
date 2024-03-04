// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;




contract Lottery {

    // Address of the manager who deploys the contract
    address public manager;

    // Array to store participants' addresses
    address payable[] public participants;

    // Constructor: Initializes the manager when the contract is deployed
    constructor() {
        manager = msg.sender; // Global variable storing the manager's address
    }

    // Fallback function: Allows participants to send 1 ether to participate
    receive() external payable {
        require(msg.value == 1 ether, "You must send exactly 1 ether to participate.");
        participants.push(payable(msg.sender));
    }

    // Function to get the contract balance (only accessible by the manager)
    function getBalance() public view returns (uint) {
        require(msg.sender == manager, "Only the manager can check the balance.");
        return address(this).balance;
    }

    // Function to generate a random number (private)
    function random() private view returns (uint) {
        // Note: Using block.timestamp for randomness is not secure in production
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, participants.length)));
    }

    // Function to pick a winner among participants (only accessible by the manager)
    function pickWinner() public {
        require(msg.sender == manager, "Only the manager can pick a winner.");
        require(participants.length >= 3, "Not enough participants to pick a winner.");

        address payable winner;
        uint index = random() % participants.length; // Select a random index
        winner = participants[index]; // Select the winner

        winner.transfer(getBalance()); // Transfer the contract balance to the winner

        // Reset participants array to zero length
        participants = new address payable[](0);
    }
}
