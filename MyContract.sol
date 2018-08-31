pragma solidity ^0.4.24;

/** This smart contract allows owner to sell asset stored in contract.
    * Asset is name and surname of specific sport player (football, basketball,...)
    * Owner can define price and clause of the asset, where clause is private so only he/she can see it.
    * Owner can sell contract to new owner based on price + clause transaction in Ether */

contract TransferOwnerWithPrice {
    address public owner;
    address public sellingTo;
    string public name;
    string public surname;
    uint public price;
    uint private clause;
    bool public selling;

    /** Constructor sets original owner to sender of contract with specified name and surname 
        * Set default price and clause to 1 ether (for easier conversion from Wei to Ether)
        * Selling is false by default (it allows to chenck if contract is set on sale)*/
    constructor() public {
        owner = msg.sender;
        name = "Pero";
        surname = "Peric";
        price = 1 ether;
        clause = 1 ether;
        selling = false;
    }

    //Throw if it is not called from owner account with message
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not an owner");
        _;
    }

    //Allow owner to prevent some functions when selling is initialized (to set new price and clause)
    modifier ifNotLocked() {
        require(!selling, "Cant do that right now! Selling initialized!");
        _;
    }

    /**Write to EVM log when transfer happens 
        *It is used for refreshing Front end web application in JS API
        *Web3 constanly listens to these event, when they activate, page refreshes*/
    event Transfer(uint saleDate, address from, address to, uint _salePrice);
    event PriceChanged(uint _newPrice);
    event ChangeSelling(bool _selling);

    //Owner can set his own price and clause for his asset in ether if selling is not initialized
    function setPrice(uint _price, uint _clause) public onlyOwner ifNotLocked {
        uint defaultPrice = 1 ether;
        price = _price * defaultPrice;
        clause = _clause * defaultPrice;
        emit PriceChanged(price);
    }

    //Print all public data visible to all users
    function getData() public view returns(string, string, uint, address){
        return (name, surname, price, owner);
    }

    //Print clause of contract which is allowed only to owner
    function getClause() public view onlyOwner returns(uint) {
        return clause;
    }

    /**Function can be called only by owner to initiate sale.
        *Variable _to is optional address of buyer, when set to 
        *0x0000000000000000000000000000000000000000 anyone can buy it */
    function initiateSale(address _to) public onlyOwner {
        require(_to != address(this) && _to != owner, "Address of buyer must be different from sellers");
        require(!selling, "This contract is already on sale!");

        selling = true;
        sellingTo = _to;
        price += clause;
        emit PriceChanged(price);
        emit ChangeSelling(selling);
    
    }

    //Allow owner to cancel sale
    function cancelSale() public onlyOwner {
        require(selling, "Can't cancel when it is not on sale!");
        resetSale();
    }

    /**It is called by specified buyer to make the purchase
        *This function transfers ownage and value between seller and buyer */
    function completeSale() public payable {
        require(selling, "This is not on sale!");
        require(msg.sender != owner, "You already own this");
        require(msg.sender == sellingTo || sellingTo == address(0), "You are not allowed to buy this");
        require(msg.value == price, "Send correct value to buy asset");

        address prevOwner = owner;
        address newOwner = msg.sender;
        uint salePrice = price;

        owner = newOwner;
        prevOwner.transfer(salePrice);
        emit Transfer(now, prevOwner, newOwner, salePrice);
        
        resetSale();
    }

    //Internal function for resetting the sale
    function resetSale() internal {
        selling = false;
        sellingTo = address(0);
        price -= clause;
        emit PriceChanged(price);
        emit ChangeSelling(selling);
    }
        
}