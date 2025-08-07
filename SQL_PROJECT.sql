create database  Library_Management_System;

use  Library_Management_System;


describe authors;
describe `book copies`;
describe `book loans`;
describe `borrower`;
describe books;
describe `library branch`;
describe `publisher`;

# importing the tables and connecting the tables each other 
 
 
#  modifing primary keys and auto_increments. 
alter table `book loans` add column book_loans_LoansID int primary key auto_increment;
alter table books change column ï»¿book_BookID book_BookID  int primary key;
alter table publisher modify column publisher_PublisherName varchar(30) primary key;
alter table authors add column book_authors_AuthorID int primary key auto_increment;
alter table borrower modify column borrower_CardNo int primary key;
alter table `library branch` add column library_brance_BranchID int primary key auto_increment;
alter table `book copies` add column book_copies_CopiesID int primary key auto_increment;


# connecting with foreign keys.
alter table `book loans` add
foreign key (book_loans_CardNo) references borrower(borrower_CardNo) on update cascade on delete cascade;

alter table `book loans` change column ï»¿book_loans_BookID book_loans_BookID int ;

alter table `book loans` 
add 
foreign key (book_loans_BranchID) references `library branch`(library_brance_BranchID) on update cascade on delete cascade,
add 
foreign key (book_loans_BookID) references books(book_BookID) on  update cascade on  delete cascade;

alter table `book copies` change column ï»¿book_copies_BookID book_copies_BookID int;

alter table `book copies`
add foreign key (book_copies_BranchID) references `library branch`(library_brance_BranchID) on update cascade on delete cascade ,
add foreign key (book_copies_BookID) references  books (book_BookID) on update cascade on delete cascade;

alter table authors change column ï»¿book_authors_BookID book_authors_BookID int;

alter table authors 
add foreign key (book_authors_BookID) references  books (book_BookID) on update cascade on delete cascade;

alter table books modify column book_PublisherName varchar(30);

alter table books 
add foreign key (book_PublisherName) references  publisher (publisher_PublisherName) on update cascade on delete cascade;



select * from authors;
select * from `book copies`;
select * from `book loans`;
select * from books;
select * from borrower;
select * from `library branch`;
select * from publisher;



# 1. How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select book_copies_No_Of_Copies from `book copies`
where book_copies_BookID = (select book_BookID from books
where book_Title = 'The Lost Tribe') and book_copies_BranchID  = (select library_brance_BranchID from `library branch`
where  library_branch_BranchName= 'Sharpstown');



# 2. How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select library_branch_BranchName, book_copies_No_Of_Copies from `book copies`
join  books on book_BookID = book_copies_BookID
join `library branch` on library_brance_BranchID = book_copies_BranchID
where book_copies_BookID = (select book_BookID from books
where book_Title = 'The Lost Tribe');



# 3. Retrieve the names of all borrowers who do not have any books checked out.
select * from borrower
left join `book loans` on borrower_CardNo = book_loans_CardNo
where book_loans_BranchID is null;



# 4. For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address.
select book_Title,borrower_BorrowerName,borrower_BorrowerAddress from borrower
join `book loans` on book_loans_CardNo = borrower_CardNo
join books on book_BookID = book_loans_BookID
join `library branch` on library_brance_BranchID = book_loans_BranchID
where library_branch_BranchName = "Sharpstown" and book_loans_DueDate = '2/3/18';



# 5. For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
select library_branch_BranchName ,count(library_brance_BranchID) from `library branch`
join  `book loans` on library_brance_BranchID = book_loans_BranchID
group by library_branch_BranchName;



# 6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
select borrower_BorrowerName,borrower_BorrowerAddress, count(book_loans_CardNo)from borrower 
join `book loans` on borrower_CardNo = book_loans_CardNo
group by borrower_BorrowerName, borrower_BorrowerAddress
having count(book_loans_CardNo) > 5;



# 7. For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
select book_Title, book_copies_No_Of_Copies from books
join `book copies` on book_BookID = book_copies_BookID
join authors on book_authors_BookID = book_BookID
join `library branch` on library_brance_BranchID = book_copies_BranchID 
where book_authors_AuthorName = "Stephen King" and library_branch_BranchName = "Central";


