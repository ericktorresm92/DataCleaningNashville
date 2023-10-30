					/* Cleaning Data in SQL Queries */

SELECT 
	*
FROM
	[PortfolioProject].[dbo].Nashville_Housing AS Nashville_Housing

					/* Standarize Date Format */

SELECT 
	Sale_Date, CONVERT (Date,SaleDate)
FROM
	[PortfolioProject].[dbo].Nashville_Housing AS Nashville_Housing

Update [PortfolioProject].[dbo].Nashville_Housing
SET SaleDate = CONVERT(Date,SaleDate)

			/* If it doesn't Update Properly */

ALTER TABLE [PortfolioProject].[dbo].Nashville_Housing
Add Sale_Date Date; 

Update [PortfolioProject].[dbo].Nashville_Housing
SET Sale_Date = CONVERT(Date,SaleDate)

					/* Populate Property Address Data */

SELECT 
	*
FROM
	[PortfolioProject].[dbo].Nashville_Housing AS Nashville_Housing
--WHERE PropertyAddress IS NULL
ORDER BY
	ParcelID


SELECT 
	[Nashville_Housing_A].[ParcelID]
	, [Nashville_Housing_A].[PropertyAddress]
	, [Nashville_Housing_B].[ParcelID]
	, [Nashville_Housing_B].[PropertyAddress]
	, ISNULL([Nashville_Housing_A].[PropertyAddress],[Nashville_Housing_B].[PropertyAddress])
FROM
	[PortfolioProject].[dbo].Nashville_Housing AS Nashville_Housing_A
JOIN [PortfolioProject].[dbo].Nashville_Housing AS Nashville_Housing_B
	ON [Nashville_Housing_A].[ParcelID] = [Nashville_Housing_B].[ParcelID]
	AND [Nashville_Housing_A].[UniqueID ] <> [Nashville_Housing_B].[UniqueID ]
WHERE
	[Nashville_Housing_A].[PropertyAddress] IS NULL

Update Nashville_Housing_A
SET PropertyAddress = ISNULL([Nashville_Housing_A].[PropertyAddress],[Nashville_Housing_B].[PropertyAddress])
FROM
	[PortfolioProject].[dbo].Nashville_Housing AS Nashville_Housing_A
JOIN [PortfolioProject].[dbo].Nashville_Housing AS Nashville_Housing_B
	ON [Nashville_Housing_A].[ParcelID] = [Nashville_Housing_B].[ParcelID]
	AND [Nashville_Housing_A].[UniqueID ] <> [Nashville_Housing_B].[UniqueID ]
WHERE
	[Nashville_Housing_A].[PropertyAddress] IS NULL

/* Breaking out Address into Individual Columns (Address, City, State) */

SELECT 
	PropertyAddress
FROM
	[PortfolioProject].[dbo].Nashville_Housing AS Nashville_Housing
--WHERE PropertyAddress IS NULL
--ORDER BY
--	ParcelID

SELECT
	SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
	, SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS City
FROM
	[PortfolioProject].[dbo].Nashville_Housing AS Nashville_Housing

ALTER TABLE [PortfolioProject].[dbo].Nashville_Housing
Add Property_Address NVARCHAR(255); 

Update [PortfolioProject].[dbo].Nashville_Housing
SET Property_Address = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE [PortfolioProject].[dbo].Nashville_Housing
Add City NVARCHAR(255); 

Update [PortfolioProject].[dbo].Nashville_Housing
SET City = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



/* Populate Property Owner Address Data */

SELECT
	OwnerAddress
FROM
	[PortfolioProject].[dbo].Nashville_Housing AS Nashville_Housing

SELECT
	PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 3) AS Owner_Address
	, PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 2) AS Owner_City
	, PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 1) AS Owner_State
FROM
	[PortfolioProject].[dbo].Nashville_Housing AS Nashville_Housing

ALTER TABLE [PortfolioProject].[dbo].Nashville_Housing
	ADD 
	Owner_Address NVARCHAR(255)
	, Owner_City NVARCHAR(255)
	, Owner_State NVARCHAR(255);

UPDATE [PortfolioProject].[dbo].Nashville_Housing
	SET 
		Owner_Address = PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 3)
		, Owner_City = PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 2)
		, Owner_State = PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 1);

SELECT
	*
FROM
	[PortfolioProject].[dbo].Nashville_Housing AS Nashville_Housing

/* Change Y and N to Yes and No in "Sold as Vacant" Field */

SELECT
	DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM
	[PortfolioProject].[dbo].Nashville_Housing AS Nashville_Housing
GROUP BY
	SoldAsVacant
Order BY 
	2

SELECT
	SoldAsVacant
	, CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	END AS Sold_As_Vacant
FROM
	[PortfolioProject].[dbo].Nashville_Housing AS Nashville_Housing

UPDATE 
	[PortfolioProject].[dbo].Nashville_Housing
SET
	SoldAsVacant = 
		CASE 
			WHEN SoldAsVacant = 'Y' THEN 'Yes'
			WHEN SoldAsVacant = 'N' THEN 'No'
			ELSE SoldAsVacant
		END 


/* Remove Duplicates */
WITH RowNumCTE AS(
SELECT 
	*
	, ROW_NUMBER() OVER (
	PARTITION BY 
		ParcelID
		, PropertyAddress
		, SalePrice
		, SaleDate
		, LegalReference
	ORDER BY
		UniqueID
		) Row_Numbers
FROM
	[PortfolioProject].[dbo].Nashville_Housing AS Nashville_Housing
)
SELECT *
FROM RowNumCTE
WHERE Row_Numbers > 1



/* Delete Unused Columns */
SELECT
	*
FROM
	[PortfolioProject].[dbo].Nashville_Housing AS Nashville_Housing


ALTER TABLE [PortfolioProject].[dbo].Nashville_Housing
	DROP COLUMN 
		OwnerAddress
		, TaxDistrict
		, PropertyAddress
		, SaleDate