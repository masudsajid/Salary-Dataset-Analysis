
library(plyr)
install.packages("googlesheets4")
library(googlesheets4)
DataSet <- read_sheet("https://docs.google.com/spreadsheets/d/1IPS5dBSGtwYVbjsfbaMCYIWnOuRmJcbequohNxCyGVw/edit?resourcekey#gid=1625408792")
DataSetCopy <- DataSet
colnames(DataSetCopy)[2] <- "Age"
colnames(DataSetCopy)[3] <- "Industry"
colnames(DataSetCopy)[4] <- "Job Title"
colnames(DataSetCopy)[5] <- "Job Title Context"
colnames(DataSetCopy)[6] <- "Annual Income"
colnames(DataSetCopy)[7] <- "Bonus/ Benefits"
colnames(DataSetCopy)[8] <- "Currency"
colnames(DataSetCopy)[9] <- "Other Currency"
colnames(DataSetCopy)[10] <- "Inclome Context"
colnames(DataSetCopy)[11] <- "Country"
colnames(DataSetCopy)[12] <- "US State"
colnames(DataSetCopy)[13] <- "City"
colnames(DataSetCopy)[14] <- "Overall Experience"
colnames(DataSetCopy)[15] <- "Field Experience"
colnames(DataSetCopy)[16] <- "Education"
colnames(DataSetCopy)[17] <- "Gender"
colnames(DataSetCopy)[18] <- "Race"

DataSetCopy$Timestamp <- as.POSIXct(DataSetCopy$Timestamp, format="%Y-%m-%d %H:%M:%S")
#removes leading and trailing white spaces
DataSetCopy$Industry <- trimws(DataSetCopy$Industry)
#converts all the text in the Industry column to lowercase.
DataSetCopy$Industry <- tolower(DataSetCopy$Industry)
#replaces all non-alphabetic characters (including digits and punctuation marks) with a space.
DataSetCopy$Industry <- gsub("[^a-zA-Z\\s]", " ", DataSetCopy$Industry)
#replaces all consecutive white spaces with a single space.
DataSetCopy$Industry <- gsub("\\s+", " ", DataSetCopy$Industry)
#removes the words “and” and “or” from the Industry column, regardless of their case.
DataSetCopy$Industry <- gsub("\\band\\b|\\bor\\b", "", DataSetCopy$Industry, ignore.case = TRUE)
#replaces all consecutive white spaces with a single space.
DataSetCopy$Industry <- gsub("\\s+", " ", DataSetCopy$Industry)
#removes all rows from the "DataSetCopy" data frame where the Industry column contains more than three words.
DataSetCopy <- DataSetCopy[!grepl(".*\\s.*\\s.*\\s.*", DataSetCopy$Industry), ]
DFTemp <- DataSetCopy
DFTemp$word1 <- NA
DFTemp$word2 <- NA
DFTemp$word3 <- NA
DFTemp$word4 <- NA

DFTemp <- within(DFTemp, {
  temp <- strsplit(as.character(Industry), "\\s")
  temp <- lapply(temp, `length<-`, 4)
  temp <- do.call(rbind, temp)
  word1[is.na(word1)] <- temp[,1][is.na(word1)]
  word2[is.na(word2)] <- temp[,2][is.na(word2)]
  word3[is.na(word3)] <- temp[,3][is.na(word3)]
  word4[is.na(word4)] <- temp[,4][is.na(word4)]
  rm(temp)
})


DFTemp <- DFTemp[ order(DFTemp$word1, DFTemp$word2, DFTemp$word3, DFTemp$word4), ]  # Use built-in R functions
DFTemp$category <-""
DFTemp$subcategory <-""

DFTemp <- DFTemp[, c(1,2,3,19,20,21,22,23,24,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18)]

DFTemp <- DFTemp[!is.na(DFTemp$word1), ]
DFTemp$word2 <- replace(DFTemp$word2, is.na(DFTemp$word2), "a")
DFTemp$word3 <- replace(DFTemp$word3, is.na(DFTemp$word3), "a")
DFTemp$word4 <- replace(DFTemp$word4, is.na(DFTemp$word4), "a")
DFTemp <- DFTemp[ order(DFTemp$word1, DFTemp$word2, DFTemp$word3, DFTemp$word4), ]


DFTemp$word2[DFTemp$word2 == "a"] <- NA
DFTemp$word3[DFTemp$word3 == "a"] <- NA
DFTemp$word4[DFTemp$word4 == "a"] <- NA

DFTemp1 <- DFTemp

#to make all NA into row numbers
DFTemp2 <- DFTemp1
na_rows <- which(is.na(DFTemp2$word2))
DFTemp2$word2[na_rows] <- as.character(na_rows)

na_rows <- which(is.na(DFTemp2$word3))
DFTemp2$word3[na_rows] <- as.character(na_rows)

na_rows <- which(is.na(DFTemp2$word4))
DFTemp2$word4[na_rows] <- as.character(na_rows)

#because word 4 was blank in all
DFTemp2 <- DFTemp2[,-7]
#checkpoint for loop
CHECKDF <- DFTemp2

CHECKDF$i <- ""
CHECKDF$j <- ""
CHECKDF$k <- ""
CHECKDF <- CHECKDF[, c(1,2,3,24,25,26,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23)]
CHECKDFSavePoint <- CHECKDF
#checkpoint for loop
CHECKDF <- CHECKDFSavePoint
i <- 1
j <- 1
k <- 4

while( i < nrow(CHECKDF)){
  while(CHECKDF[i,7] == CHECKDF[j,7]){
    while(CHECKDF[i,k] == CHECKDF[j,k] && k <= 9)
    {k <- k+1}
    #cat("word1: ", DFTemp1$word1, "\n")
    #cat("i: ", i, "\n")
    #cat("j: ", j, "\n")
    #cat("k: ", k, "\n")
    #7 is the starting point
    if((k-1) == 7){
      CHECKDF[j,10] <- CHECKDF[j,7]
    }
    else {
      CHECKDF[j,10] <- do.call(paste, c(CHECKDF[j,7:k-1], sep=" "))
    }
    
    #9 is the ending point
    if(k == 9){
      CHECKDF[j,11] <- CHECKDF[j,9]
    }
    else{
      #k moves to 10 at last point
      if(k<=9){
        CHECKDF[j,11] <- do.call(paste, c(CHECKDF[j,k:9], sep=" "))}
      
    }
    CHECKDF[j,4] <- as.character(i)
    CHECKDF[j,5] <- as.character(j)
    CHECKDF[j,6] <- as.character(k)
    j <- j+1
  
  }
  
  k <- 7
  i <- j
  j <- j+1
}

DFTemp <- CHECKDF
remove(DFTemp1)
remove(DFTemp2)
remove(CHECKDFSavePoint)
remove(CHECKDF)
save(DataSet, file = "DataSet.Rda")
save(DataSetCopy, file = "DataSetCopy.Rda")
save(DFTemp, file = "DFTemp.Rda")


#for i,j,k
DFTemp <- DFTemp[,-(4:6)]
#for w1,w2,w3
DFTemp <- DFTemp[,-(4:6)]
#to get rid of numbers
DFTemp$category <- gsub("[0-9]", "", DFTemp$category)
DFTemp$subcategory <- gsub("[0-9]", "", DFTemp$subcategory)

install.packages("stringr")
library(stringr)
DFTemp$category <- str_to_title(DFTemp$category)
DFTemp$Industry <- str_to_title(DFTemp$Industry)
DFTemp$subcategory <- str_to_title(DFTemp$subcategory)
DFTemp$`Job Title` <- str_to_title(DFTemp$`Job Title`)
DFTemp$`Annual Income` <- as.character(DFTemp$`Annual Income`)
#to check that income is all in numbers only
checkDF <- DFTemp[grep("[^0-9]", DFTemp$`Annual Income`), ]
checkDF$check <- ""
DFTemp$`Annual Income` <- as.double(DFTemp$`Annual Income`)
#make all country USA where state is not NA
DFTemp$Country[!is.na(DFTemp$`US State`)] <- "USA"
#check unique country names
country <- unique(DFTemp$Country)
countryDF <- data.frame(country, stringsAsFactors = FALSE)
#make lowercase
DFTemp$Country <- tolower(DFTemp$Country)
DFTemp <- subset(DFTemp, Country != "africa")
DFTemp <- subset(DFTemp, Country != "$2,175.84/year is deducted for benefits")

#england is also turned into UK
subset_df <- DFTemp[grepl("uk | uk|uk, |,uk", DFTemp$Country), ]
DFTemp$Country[grepl("uk | uk|uk, |,uk", DFTemp$Country)] <- "united kingdom"
subset_df <- DFTemp[grepl("england", DFTemp$Country), ]
DFTemp$Country[grepl("england", DFTemp$Country)] <- "united kingdom"
subset_df <- DFTemp[grepl("united kin", DFTemp$Country), ]
DFTemp$Country[grepl("united kin", DFTemp$Country)] <- "united kingdom"
DFTemp$Country[DFTemp$Country == "uk"] <- "united kingdom"
#checked all can is canada by currency
subset_df <- DFTemp[grepl("can", DFTemp$Country), ]
DFTemp$Country[grepl("can", DFTemp$Country)] <- "canada"

subset_df <- DFTemp[grepl("austra", DFTemp$Country), ]
DFTemp$Country[grepl("austra", DFTemp$Country)] <- "australia"

subset_df <- DFTemp[grepl("united st", DFTemp$Country), ]
DFTemp$Country[grepl("united st", DFTemp$Country)] <- "usa"

DFTemp$Country[DFTemp$Country == "us"] <- "usa"

subset_df <- DFTemp[grepl("brasil", DFTemp$Country), ]
DFTemp$Country[grepl("brasil", DFTemp$Country)] <- "brazil"

subset_df <- DFTemp[grepl("netherlands", DFTemp$Country), ]
DFTemp$Country[grepl("netherlands", DFTemp$Country)] <- "netherlands"


remove(countryDF)
remove(DFTempcountries)
remove(subset_df)
save(DFTemp, file = "DFTemp.Rda")
install.packages("dplyr")
DFTemp$City <- tolower(DFTemp$City)
DataSetCopy <- DFTemp
remove(DFTemp)
install.packages("writexl")
library(writexl)
write_xlsx(DataSetCopy, "C:\\Users\\GNG\\Desktop\\Salary_dataset_analysis\\Salary_dataset_analysis\\SalaryDatasetAnalysis\\salaryDataset.xlsx")



DataSetCopy <- checkDF
write_xlsx(DataSetCopy, "C:\\Users\\GNG\\Desktop\\Salary_dataset_analysis\\Salary_dataset_analysis\\SalaryDatasetAnalysis\\salaryDataset.xlsx")

remove(checkDF)
remove(checkdf1)
#############################################
install.packages("readxl")
library(readxl)
#because last dataframes were not saved
dataFrame <- read_excel("C:\\Users\\GNG\\Desktop\\Salary_dataset_analysis\\Salary_dataset_analysis\\SalaryDatasetAnalysis\\salaryDataset.xlsx")
checkDF <- dataFrame
install.packages("stringr")
library(stringr)
#to get the subcategory of first new category
checkDF$subcategory <- str_replace_all(checkDF$Industry, checkDF$category, "")
checkDF$subcategory <- str_trim(checkDF$subcategory)
#manually changing the last row values
checkDF[24449,4] <- "Zoo"
checkDF[24449,5] <- "Aquariums"
#removing rows where currency is "other"
currencyList <- subset(dataFrame, Currency != "Other")
checkDF <- currencyList
remove(currencyList)
currencylist <- unique(checkDF$Currency)
print(currencylist)
checkDF <- checkDF[,-11]
checkDF$IncomeUSD <- 0.0
checkDF <- checkDF[, c(1,2,3,4,5,6,7,8,20,9,10,11,12,13,14,15,16,17,18,19)]
# manual changing of currency values
i <- 1
checkDFcheckpoint <- checkDF
checkDF <- checkDFcheckpoint
while(i <= nrow(checkDF)){
  if(checkDF[i,11] == "EUR"){
    checkDF[i,9] <- as.double(checkDF[i,8])*1.09
  }
  else if(checkDF[i,11] == "JPY"){
    checkDF[i,9] <- as.double(checkDF[i,8])*0.0067
  }
  else if(checkDF[i,11] == "GBP"){
    checkDF[i,9] <- as.double(checkDF[i,8])*1.27
  }
  else if(checkDF[i,11] == "CHF"){
    checkDF[i,9] <- as.double(checkDF[i,8])*1.16
  }
  else if(checkDF[i,11] == "CAD"){
    checkDF[i,9] <- as.double(checkDF[i,8])*0.74
  }
  else if(checkDF[i,11] == "AUD/NZD"){
    checkDF[i,9] <- as.double(checkDF[i,8])*0.635
  }
  else if(checkDF[i,11] == "ZAR"){
    checkDF[i,9] <- as.double(checkDF[i,8])*0.053
  }
  else if(checkDF[i,11] == "HKD"){
    checkDF[i,9] <- as.double(checkDF[i,8])*0.13
  }
  else if(checkDF[i,11] == "SEK"){
    checkDF[i,9] <- as.double(checkDF[i,8])*0.096
  }
  else if(checkDF[i,11] == "USD"){
    checkDF[i,9] <- as.double(checkDF[i,8])
  }
  i <- i+1
}
remove(checkDFcheckpoint)
#check standard deviation
result <- aggregate(checkDF$IncomeUSD, by=list(Category=checkDF$category), FUN=sd)

# Install and load the dplyr package
install.packages("dplyr")
library(dplyr)
checkDF1 <- checkDF
# Assuming 'df' is your dataframe, 'value' is the numeric column, and 'category' is the category column
# Calculate standard deviation for each category
checkDF1 <- checkDF1 %>%
  group_by(category) %>%
  mutate(sd = sd(IncomeUSD, na.rm = TRUE))

# Filter out rows where value is more than 3 times the standard deviation
checkDF1 <- checkDF1 %>%
  filter(abs(IncomeUSD) <= 3 * sd)

checkDF <- checkDF1[,-21]
library(writexl)
write_xlsx(checkDF, "C:\\Users\\GNG\\Desktop\\Salary_dataset_analysis\\Salary_dataset_analysis\\SalaryDatasetAnalysis\\salaryDataset.xlsx")
############################################
library(readxl)
dataFrame <- read_excel("C:\\Users\\GNG\\Desktop\\Salary_dataset_analysis\\Salary_dataset_analysis\\SalaryDatasetAnalysis\\salaryDataset.xlsx")
checkDF <- dataFrame

checkDF$`Field Experience`[checkDF$`Field Experience` == "1 year or less"] <- 1
checkDF$`Field Experience`[checkDF$`Field Experience` == "2 - 4 years"] <- 4
checkDF$`Field Experience`[checkDF$`Field Experience` == "5-7 years"] <- 7
checkDF$`Field Experience`[checkDF$`Field Experience` == "8 - 10 years"] <- 10
checkDF$`Field Experience`[checkDF$`Field Experience` == "11 - 20 years"] <- 20
checkDF$`Field Experience`[checkDF$`Field Experience` == "21 - 30 years"] <- 30
checkDF$`Field Experience`[checkDF$`Field Experience` == "31 - 40 years"] <- 40
checkDF$`Field Experience`[checkDF$`Field Experience` == "41 years or more"] <- 41

checkDF$`Field Experience` <- as.double(checkDF$`Field Experience`)

checkDF$`Overall Experience`[checkDF$`Overall Experience` == "1 year or less"] <- 1
checkDF$`Overall Experience`[checkDF$`Overall Experience` == "2 - 4 years"] <- 4
checkDF$`Overall Experience`[checkDF$`Overall Experience` == "5-7 years"] <- 7
checkDF$`Overall Experience`[checkDF$`Overall Experience` == "8 - 10 years"] <- 10
checkDF$`Overall Experience`[checkDF$`Overall Experience` == "11 - 20 years"] <- 20
checkDF$`Overall Experience`[checkDF$`Overall Experience` == "21 - 30 years"] <- 30
checkDF$`Overall Experience`[checkDF$`Overall Experience` == "31 - 40 years"] <- 40
checkDF$`Overall Experience`[checkDF$`Overall Experience` == "41 years or more"] <- 41

checkDF$`Overall Experience` <- as.double(checkDF$`Overall Experience`)

library(writexl)
write_xlsx(checkDF, "C:\\Users\\GNG\\Desktop\\Salary_dataset_analysis\\Salary_dataset_analysis\\SalaryDatasetAnalysis\\salaryDataset.xlsx")
