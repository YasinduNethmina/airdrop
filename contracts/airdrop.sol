// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function decimals() external view returns (uint8);
}

contract Airdrop {
    address public owner;
    IERC20 public token;
    uint8 private tokenDecimals;

    event AirdropSuccess(address indexed recipient, uint256 amount);
    event AirdropFailure(address indexed recipient, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event TokenSet(address indexed tokenAddress, uint8 decimals);
    event Withdrawal(address indexed to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor(address _tokenAddress, uint8 _tokenDecimals) {
        owner = msg.sender;
        setToken(_tokenAddress, _tokenDecimals);
    }

    function setToken(address _tokenAddress, uint8 _tokenDecimals) public onlyOwner {
        require(_tokenAddress != address(0), "Invalid token address");
        token = IERC20(_tokenAddress);
        tokenDecimals = _tokenDecimals;
        emit TokenSet(_tokenAddress, _tokenDecimals);
    }

    function airdropBatch(address[] calldata recipients, uint256[] calldata amounts, uint256 batchStart, uint256 batchSize) external onlyOwner {
        require(recipients.length == amounts.length, "Recipients and amounts length mismatch");
        require(batchStart + batchSize <= recipients.length, "Batch size exceeds list length");

        for (uint256 i = batchStart; i < batchStart + batchSize; i++) {
            bool success = token.transfer(recipients[i], amounts[i]);
            if (success) {
                emit AirdropSuccess(recipients[i], amounts[i]);
            } else {
                emit AirdropFailure(recipients[i], amounts[i]);
            }
        }
    }

    function fundContract(uint256 amount) external onlyOwner {
        require(token.transferFrom(msg.sender, address(this), amount), "Token transfer to contract failed");
    }

    function checkContractBalance() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function withdrawRemainingTokens(address to, uint256 amount, address _tokenAddress) external onlyOwner {
        IERC20 _token = IERC20(_tokenAddress);
        require(_token.transfer(to, amount), "Withdrawal failed");
        emit Withdrawal(to, amount);
    }

    function changeOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid new owner address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}