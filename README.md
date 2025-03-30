#Data Cleansing in SQL

### Dataset link: https://www.kaggle.com/datasets/tmthyjames/nashville-housing-data

## Purpose:

Broadly speaking, the purpose of this query is to clean, standardize, and improve the quality of the data in the Nashville_Housing table to make it more useful and consistent in subsequent analyses.
1. Standardize the date format
Convert the SaleDate column to a DATE format instead of a DATETIME with time.
2. Complete missing data in PropertyAddress
Fill null values ​​in PropertyAddress using records with the same ParcelID (property identifier).
3. Separate address into individual columns
Split PropertyAddress into Property_Address (street) and City (city) to facilitate analysis.
4. Separate owner address into individual columns
Split OwnerAddress into Owner_Address, Owner_City, and Owner_State to improve the data structure.
5. Convert "Sold as Vacant" values ​​to a clearer format
Change the Y and N values ​​in SoldAsVacant to Yes and No to improve readability.
6. Remove duplicates
Remove duplicate records based on ParcelID, PropertyAddress, SalePrice, SaleDate, and LegalReference.
7. Remove unnecessary columns
Delete columns that are no longer needed after cleaning.

## Methodology:

CONVERT(Date, SaleDate) was used to transform the column, keeping in mind that if the direct update doesn't work, add a new column, Sale_Date, and copy the converted values ​​there.
Then, a JOIN was used between the same table (Nashville_Housing_A and Nashville_Housing_B) to find properties with the same ParcelID but different UniqueIDs, using ISNULL() to fill in PropertyAddress when it is NULL.
Next, SUBSTRING() and CHARINDEX() were used to extract the part before the comma as the address and the part after the comma as the city. New columns, Property_Address and City, were created and populated with the extracted values.
Then, PARSENAME(REPLACE(OwnerAddress, ',' , '.') , n) was used to separate each part of the address. Three new columns were created and populated with the split data.
CASE was used to replace Y with Yes and N with No. CTEs (RowNumCTE) with ROW_NUMBER() were used to assign a number to each row within the same ParcelID and SalePrice, taking into account records where Row_Numbers > 1 to select them and find duplicates.
Finally, ALTER TABLE was used to delete OwnerAddress, TaxDistrict, PropertyAddress, and SaleDate, as they have been replaced and are no longer relevant.

## Summary
The main purpose of this query is to clean and structure the data in the Nashville_Housing table, ensuring that:
Date formats are consistent.
There are no null values ​​in property addresses.
Address information is well-organized.
The data is easier to read and analyze.
Duplicate records and unnecessary columns are removed.
