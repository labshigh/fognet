pragma solidity >=0.7.0 <0.9.0;

contract FOGNet is Context, AccessControlEnumerable, ERC20Pausable, ERC20Burnable, TokenLock {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    /**
     * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
	 * account that deploys the contract.
	 *
	 * See {ERC20-constructor}.
	 */
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());

        _setupRole(MINTER_ROLE, _msgSender());
        _setupRole(PAUSER_ROLE, _msgSender());
        _setupRole(ADMIN_ROLE, _msgSender());

        _mint(_msgSender(), initialSupply);
    }

    function burn(address account, uint256 amount) public virtual override (ERC20Burnable) {
        require(hasRole(ADMIN_ROLE, _msgSender()), "FOGToken: must have admin role to burn");
        super.burn(account, amount);
    }

    function grantAdminRole(address account) public virtual {
        require(hasRole(ADMIN_ROLE, _msgSender()), "FOGToken: must have admin role to grantAdminRole");
        _setupRole(ADMIN_ROLE, account);
    }

    /**
     * @dev Pauses all token transfers.
	 *
	 * See {ERC20Pausable} and {Pausable-_pause}.
	 *
	 * Requirements:
	 *
	 * - the caller must have the `PAUSER_ROLE`.
	 */
    function pause() public virtual {
        require(hasRole(PAUSER_ROLE, _msgSender()), "FOGToken: must have pauser role to pause");
        _pause();
    }

    /**
     * @dev Unpauses all token transfers.
	 *
	 * See {ERC20Pausable} and {Pausable-_unpause}.
	 *
	 * Requirements:
	 *
	 * - the caller must have the `PAUSER_ROLE`.
	 */
    function unpause() public virtual {
        require(hasRole(PAUSER_ROLE, _msgSender()), "FOGToken: must have pauser role to unpause");
        _unpause();
    }


    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override(ERC20, ERC20Pausable, TokenLock) {

        super._beforeTokenTransfer(from, to, amount);
    }

}