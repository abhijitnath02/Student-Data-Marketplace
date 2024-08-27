// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract StudentDataMarketplace {
    
    struct DataItem {
        uint id;
        string title;
        string description;
        string dataHash;
        address payable owner;
        uint price;
        bool isPurchased;
    }

    uint public dataCount = 0;
    mapping(uint => DataItem) public dataItems;
    
    // Event to be emitted when a new data item is created
    event DataItemCreated(
        uint id,
        string title,
        string description,
        string dataHash,
        address owner,
        uint price,
        bool isPurchased
    );
    
    // Event to be emitted when a data item is purchased
    event DataItemPurchased(
        uint id,
        string title,
        string description,
        string dataHash,
        address owner,
        uint price,
        bool isPurchased
    );

    // Function to upload and list educational data
    function uploadData(string memory _title, string memory _description, string memory _dataHash, uint _price) public {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(bytes(_dataHash).length > 0, "Data hash cannot be empty");
        require(_price > 0, "Price must be greater than zero");
        
        dataCount++;
        
        dataItems[dataCount] = DataItem(
            dataCount,
            _title,
            _description,
            _dataHash,
            payable(msg.sender),
            _price,
            false
        );

        emit DataItemCreated(dataCount, _title, _description, _dataHash, msg.sender, _price, false);
    }

    // Function to purchase educational data
    function purchaseData(uint _id) public payable {
        DataItem memory _dataItem = dataItems[_id];
        require(_dataItem.id > 0 && _dataItem.id <= dataCount, "Data item not found");
        require(msg.value >= _dataItem.price, "Insufficient funds sent");
        require(!_dataItem.isPurchased, "Data item already purchased");

        // Transfer funds to the owner
        _dataItem.owner.transfer(msg.value);

        // Mark the item as purchased
        _dataItem.isPurchased = true;

        // Update the dataItems mapping
        dataItems[_id] = _dataItem;

        emit DataItemPurchased(_id, _dataItem.title, _dataItem.description, _dataItem.dataHash, _dataItem.owner, _dataItem.price, true);
    }

    // Function to get data item details
    function getDataItem(uint _id) public view returns (uint, string memory, string memory, string memory, address, uint, bool) {
        DataItem memory _dataItem = dataItems[_id];
        return (_dataItem.id, _dataItem.title, _dataItem.description, _dataItem.dataHash, _dataItem.owner, _dataItem.price, _dataItem.isPurchased);
    }
}
