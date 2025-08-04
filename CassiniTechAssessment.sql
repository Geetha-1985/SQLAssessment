Create database CassiniTechAssessmentDB;
use CassiniTechAssessmentDB;

--Table(tblFruit) creation
Create table tblFruit (
FruitID INT,
Name VARCHAR(50),
Price VARCHAR(50),
ColourID INT,
SizeID INT,
CountryID INT,
SupplierID INT
);

--Table(tblFruit) - Record Insertion

INSERT INTO tblFruit(FruitID,Name,Price,ColourID,SizeID,CountryID,SupplierID)
VALUES
(1, 'Lemon', '£1', 1,2,1,1),
(2, 'Apple', '£2', 2,2,2,2),
(3, 'Orange', '£3', 3,2,3,1),
(4, 'Pineapple', '£2', 1,3,4,3),
(5, 'Grape', '£1', 2,1,2,2),
(6, 'Banana', '£1', 1,2,1,1);


--Table(tblColours) creation
Create Table tblColours (
ColourID INT,
Colour VARCHAR(20)
);

--Table(tblColours) - Record Insertion
Insert Into tblColours(ColourID, Colour)
Values 
(1, 'Yellow'),
(2, 'Green'),
(3, 'Orange'),
(4, 'Red');

--Table(tblSizes) creation
Create Table tblSizes (
SizeID INT,
Size VARCHAR(20)
);

--Table(tblSizes) - Record Insertion
Insert Into tblSizes(SizeID, Size)
Values
(1, 'Small'),
(2, 'Medium'),
(3, 'Large');


--Table(tblCountries) creation
Create Table tblCountries (
CountryID INT,
Country VARCHAR(30)
);

--Table(tblCountries) - Record Insertion
Insert Into tblCountries(CountryID, Country)
Values
(1, 'Spain'),
(2, 'France'),
(3, 'Morocco'),
(4, 'Brazil'),
(5, 'Italy');


--Table(tblSuppliers) creation
Create Table tblSuppliers (
SupplierID INT,
SupplierName VARCHAR(50),
Contact BIGINT 
);


--Table(tblSuppliers) - Record Insertion
Insert Into tblSuppliers(SupplierID, SupplierName, Contact)
Values
(1, 'FreshFruits Ltd',  01234567890),
(2, 'GreenHarvest',   09876543210),
(3, 'TropicWorld', 01111222333);

--Table(tblSales) creation
Create Table tblSales (
SaleID INT,
FruitID INT,
Quantity INT, 
SaleDate Date
);

--Table(tblSales) - Record Insertion
Insert Into tblSales(SaleID, FruitID, Quantity, SaleDate)
Values
(1,1,10,'01/05/2025'),
(2,2,5,'02/06/2025'),
(3,3,8,'01/07/2025'),
(4,4,2,' 03/07/2025'),
(5,5,15,'03/07/2025'),
(6,6,7,'02/07/2025');





-------------------  QUESTIONS --------------------------------------------------

 -- 1. List all fruits with their colours and sizes.
 Select Name, Colour, Size from 
 tblFruit F join tblColours C on F.ColourID = C.ColourID
 join tblSizes S on F.SizeID = S.SizeID

-- 2. Find all fruits supplied by "GreenHarvest" that are medium size.

Select Name from 
tblFruit F join tblSuppliers S on F.SupplierID = S.SupplierID 
join tblSizes Si on F.SizeID = Si.SizeID
where S.SupplierName = 'GreenHarvest' and Si.Size = 'Medium'

-- 3. List all countries and any fruits grown there (include countries with no fruits).
Select Country, STRING_AGG(Name,', ') as Fruits from 
tblCountries C Left join tblFruit F on C.CountryID = F.CountryID
GROUP BY C.Country

-- 4. Show all suppliers and the fruits they supply, including suppliers who currently supply no fruits.

Select SupplierName, STRING_AGG(Name, ', ') as Fruits from
tblSuppliers S Left join tblFruit F on S.SupplierID = F.SupplierID
GROUP BY S.SupplierName

-- 5. List all fruits and all suppliers, matching where possible, but showing all even if there is no match.
Select Name, SupplierName from
tblFruit F Full outer join tblSuppliers S on F.SupplierID = S.SupplierID
Order By SupplierName

--  6. For each sale, display the fruit name, country of origin, supplier name, and sale quantity
Select SaleID, Name as FruitName, Country as Country_of_origin, SupplierName, Quantity as SaleQuantity from
tblSales S join tblFruit F on S.FruitID = F.FruitID
join tblCountries C on F.CountryID = C.CountryID
join tblSuppliers Su on F.SupplierID = Su.SupplierID

-- 7. Which country has sold the highest total quantity of fruits?
Select TOP 1 Country, SUM(Quantity) as QuantitySold from
tblSales S join tblFruit F on S.FruitID = F.FruitID
join tblCountries C on F.CountryID = C.CountryID
join tblSuppliers Su on F.SupplierID = Su.SupplierID
Group By Country Order By QuantitySold Desc

--  8. List the names of fruits that have never been sold.
Select Name as FruitsNotSold from 
tblFruit F join tblSales S on F.FruitID = S.FruitID
where S.SaleID is NULL
-- All the fruits are sold, so the result is empty

--  9. Are there any fruits with the same colour but different sizes? List their names
Select Colour, String_Agg(Name,', ') as FruitNames from
tblFruit F join tblColours C on F.ColourID = C.ColourID
where F.ColourID IN (Select ColourID from tblFruit 
GROUP BY ColourID 
HAVING COUNT(DISTINCT SizeID) > 1)
Group By Colour


-- 10. For each sale, display the sale date, fruit name, fruit colour, fruit size, country of origin, supplier name,
-- and quantity sold. Order the results by sale date and fruit name.

Select SaleID, SaleDate, Name as Fruit, Colour, Size, Country, SupplierName, Quantity as QuantitySold from 
tblSales S join tblFruit F on S.FruitID = F.FruitID
join tblColours C on F.ColourID = C.ColourID
join tblCountries Co on F.CountryID = Co.CountryID
join tblSuppliers Su on F.SupplierID = Su.SupplierID
join tblSizes Si on F.SizeID = Si.SizeID
Order By SaleDate Asc , Name Asc
