// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Library {
    address public owner;
    
    struct Book {
        uint256 id;
        string title;
        uint256 copies;
    }
    
    mapping(uint256 => Book) public books;
    mapping(address => mapping(uint256 => bool)) public borrowers;

    uint256 public bookIndex;
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can perform this action.");
        _;
    }
    
    modifier canBorrow {
        bool borrowed = false;
        for (uint256 i = 1; i <= bookIndex; i++) {
            if (borrowers[msg.sender][i]) {
                borrowed = true;
                break;
            }
        }
        require(!borrowed, "You can't borrow the same book more than once at a time.");
        _;
    }
    
    function addBook(string memory title, uint256 copies) public onlyOwner {
        bookIndex++;
        books[bookIndex] = Book(bookIndex, title, copies);
    }
    
    function borrowBook(uint256 id) public canBorrow {
        require(id <= bookIndex, "The book does not exist.");
        require(books[id].copies > 0, "There are no available copies of the book.");
        books[id].copies--;
        borrowers[msg.sender][id] = true;
    }
    
    function returnBook(uint256 id) public {
        require(borrowers[msg.sender][id], "You haven't borrowed this book.");
        books[id].copies++;
        borrowers[msg.sender][id] = false;
    }
    
    function viewBorrowers(uint256 id) public view returns (address[] memory) {
        address[] memory bookBorrowers = new address[](bookIndex);
        uint256 index = 0;
        for (uint256 i = 0; i < bookIndex; i++) {
            if (borrowers[msg.sender][id]) {
                bookBorrowers[index] = msg.sender;
                index++;
            }
        }
        return bookBorrowers;
    }
    
    function viewAvailableBooks() public view returns (uint256[] memory) {
        uint256[] memory availableBooks = new uint256[](bookIndex);
        uint256 index = 0;
        for (uint256 i = 1; i <= bookIndex; i++) {
            if (books[i].copies > 0) {
                availableBooks[index] = books[i].id;
                index++;
            }
        }
        return availableBooks;
    }
}


/*
pragma solidity ^0.8.0;

contract Library {
    address public owner;
    mapping(uint256 => uint256) public books;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public totalBorrowed;
    mapping(address => uint256[]) public borrowedBooks;
    mapping(address => bool) public isBorrower;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier canBorrow() {
        require(!isBorrower[msg.sender] || totalBorrowed[msg.sender] == 0, "You can only borrow one book at a time.");
        _;
    }

    function addBook(uint256 id, uint256 copies) public onlyOwner {
        books[id] += copies;
    }

    function borrowBook(uint256 id) public canBorrow {
        require(books[id] > 0, "This book is not available");
        require(balances[msg.sender] > 0, "You need to have a positive balance to borrow books");
        books[id]--;
        balances[msg.sender]--;
        borrowedBooks[msg.sender].push(id);
        isBorrower[msg.sender] = true;
        totalBorrowed[msg.sender]++;
    }

    function returnBook(uint256 id) public {
        require(isBorrower[msg.sender], "You have no borrowed books to return");
        require(borrowedBooks[msg.sender].length > 0, "You have no borrowed books to return");
        require(totalBorrowed[msg.sender] > 0, "You have no borrowed books to return");
        bool foundBook = false;
        for (uint256 i = 0; i < borrowedBooks[msg.sender].length; i++) {
            if (borrowedBooks[msg.sender][i] == id) {
                foundBook = true;
                totalBorrowed[msg.sender]--;
                books[id]++;
                borrowedBooks[msg.sender][i] = borrowedBooks[msg.sender][borrowedBooks[msg.sender].length - 1];
                borrowedBooks[msg.sender].pop();
                break;
            }
        }
        require(foundBook, "You have not borrowed this book");
    }

    function viewBorrowers(uint256 id) public view returns(address[] memory) {
        address[] memory result = new address[](totalBorrowed[msg.sender]);
        uint256 count = 0;
        for (uint256 i = 0; i < borrowedBooks[msg.sender].length; i++) {
            if (borrowedBooks[msg.sender][i] == id) {
                result[count] = msg.sender;
                count++;
            }
        }
        return result;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender], "You don't have enough balance to withdraw");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
}
*/

