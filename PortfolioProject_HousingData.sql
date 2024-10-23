-- Standardize the Date Format

--Select SaleDate
--from PortfolioProject..HousingData

--Select SaleDate, CONVERT(Date,SaleDate)
--From PortfolioProject..HousingData

--ALTER Table PortfolioProject..HousingData
--Add ConvertedDate Date;
--Update HousingData
--Set ConvertedDate = CONVERT(Date,SaleDate)

--Select ConvertedDate
--From PortfolioProject..HousingData
--order by ConvertedDate desc

--Select * 
--From PortfolioProject..HousingData
--where PropertyAddress is null

----Populating the PropertyAdress Column with addresses
--Select x.ParcelID, x.PropertyAddress, y.ParcelID, y.PropertyAddress, ISNULL(x.PropertyAddress, y.PropertyAddress)
--From PortfolioProject..HousingData x
--join PortfolioProject..HousingData y
--On x.ParcelID = y.ParcelID
--and x.[UniqueID ]<> y.UniqueID
--Where x.PropertyAddress is null

--Update x
--Set PropertyAddress = ISNULL(X.PropertyAddress, y.PropertyAddress)
--From PortfolioProject..HousingData x
--join PortfolioProject..HousingData y
--On x.ParcelID = y.ParcelID
--and x.[UniqueID ]<> y.UniqueID
--Where x.PropertyAddress is null

--Select *
--From PortfolioProject..HousingData

--SPLITTING THE ADDRESS FIELD 
--Select HousingData.PropertyAddress
--From PortfolioProject..HousingData
--Select PropertyAddress,
----PARSENAME(REPLACE(PropertyAddress,',','.'),3),
--PARSENAME(REPLACE(PropertyAddress,',','.'),2),
--PARSENAME(REPLACE(PropertyAddress,',','.'),1)
--From PortfolioProject..HousingData

----CREATE A VIEW BEFORE FURTHER ALTERATION
--CREATE VIEW MyHousingData as
--Select *
--From PortfolioProject..HousingData

--Select * 
--From MyHousingData
Select PropertyAddress, PropertySplitAddress, PropertySplitCity
From PortfolioProject..HousingData

ALTER TABLE PortfolioProject..HousingData
Add PropertySplitAddress nvarchar (255);
ALTER TABLE PortfolioProject..HousingData
Add PropertySplitCity nvarchar (255);

Update PortfolioProject..HousingData
Set PropertySplitAddress = PARSENAME(REPLACE(PropertyAddress,',','.'),2);
Update PortfolioProject..HousingData
Set PropertySplitCity = PARSENAME(REPLACE(PropertyAddress,',','.'),1);

Select *
From PortfolioProject..HousingData
ORDER BY ParcelID, PropertyAddress


 ----TO RENAME A COLUMN
 --EXEC sp_rename
 --'HousingData.PropertSplitAddress', 'PropertySplitAddress','COLUMN'

 --TO SPLIT OWNERADDRESS COLUMN
 ALTER TABLE PortfolioProject..HousingData
 Add OwnerSplitAddress nvarchar (255);
 ALTER TABLE PortfolioProject..HousingData
 Add OwnerSplitCity nvarchar (255);
 ALTER TABLE PortfolioProject..HousingData
 Add OwnerSplitState varchar(50)

 
 Update PortfolioProject..HousingData
 Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3);
 Update PortfolioProject..HousingData
 Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2);
 Update PortfolioProject..HousingData
 Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1);


 Select Distinct(SoldAsVacant), Count(SoldAsVacant) as CountYandN
 From  PortfolioProject..HousingData
 Group By SoldAsVacant

 --UPDATE THE SOLDASVACANT COLUMN TO HAVE UNIFORM VALUES
 Update PortfolioProject..HousingData
 Set SoldAsVacant = 
 CASE
	WHEN SoldAsVacant ='Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END

--TO REMOVE DUPLICATE VALUES
--USING CTE
WITH RownumCTE as (
Select *, 
ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	PropertyAddress, 
	SalePrice, 
	SaleDate, 
	LegalReference
	Order By UniqueID 
	) as row_num
	From PortfolioProject..HousingData
	)

Select * 
From RownumCTE
Where row_num > 1
order by PropertyAddress

--Delete 
--From ROWnumCTE
--Where row_num > 1

--Select *
--From PortfolioProject..HousingData
--Where ParcelID = '107 14 0 157.00'

--CREATE VIEW MyHousingData as
--Select *
--From PortfolioProject..HousingData

ALTER TABLE HousingData 
Drop Column PropertyAddress, OwnerAddress, TaxDistrict, SaleDate




