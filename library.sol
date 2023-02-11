pragma solidity ^0.8.0;

contract BookLibrary {
    address payable owner;
    mapping(address => bool) isBorrower;
    struct Book {
        string name;
        uint copies;
        mapping(address => bool) borrowers;
    }
    mapping(string => Book) books;

    constructor() public {
        owner = msg.sender;
    }

    function addBook(string memory bookName, uint copies) public {
        require(msg.sender == owner, "Only the owner can add books.");
        books[bookName] = Book({
            name: bookName,
            copies: copies
        });
    }

    function viewBooks() public view returns (string[] memory) {
        string[] memory bookNames = new string[](address(this).balance);
        uint i = 0;
        for (string bookName in books) {
            bookNames[i] = bookName;
            i++;
        }
        return bookNames;
    }

    function borrowBook(string memory bookName) public {
        require(books[bookName].copies > 0, "There are no more copies of this book available.");
        require(!isBorrower[msg.sender], "You can only borrow one book at a time.");
        books[bookName].borrowers[msg.sender] = true;
        books[bookName].copies--;
        isBorrower[msg.sender] = true;
    }

    function returnBook(string memory bookName) public {
        require(books[bookName].borrowers[msg.sender], "You did not borrow this book.");
        delete books[bookName].borrowers[msg.sender];
        books[bookName].copies++;
        isBorrower[msg.sender] = false;
    }

    function viewBorrowers(string memory bookName) public view returns (address[] memory) {
        address[] memory borrowers = new address[](books[bookName].borrowers.length);
        uint i = 0;
        for (address borrower in books[bookName].borrowers) {
            borrowers[i] = borrower;
            i++;
        }
        return borrowers;
    }
}
