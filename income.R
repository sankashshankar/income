library(aod)
library(reshape2)

names<-c("age", "class", "fnlwgt",
  "education", "education_num", "marital_status",
  "occupation", "relationship","race", "sex","capital_gain",
  "capital_loss","hours_per_week", "native_country", "income")
 
 categorical_attributes <- c("class","education", "marital_status", "occupation", 
 	"relationship", "race", "sex")
 	
 trim <- function (x) gsub("^\\s+|\\s+$", "", x)
 remove_minuses <- function (x) gsub("-","_",x)
 binarize <- function(df, attr){
 	column <- df[,attr]
 	unique_vals <- levels(column)
 	for(i in 1:length(unique_vals)){
 		val <- unique_vals[i]
 		if(trim(val) != "?" ){
 			df[,paste("qwe",remove_minuses(trim(val)),sep="")] <- (column == val)*1
 		}
 	}
 	df[,attr]<-NULL
 	return(df)
 }


  
income_train <- read.csv("income.csv", col.names=names)
income_train$native_country<-NULL
income_test <- read.csv("income_test.csv", col.names=names)
income_test$native_country<-NULL

for(i in 1:length(categorical_attributes)){
	attr <- categorical_attributes[i]
	income_train <- binarize(income_train, attr)
	income_test <- binarize(income_test, attr)
}

income_train$income <- c(income_train$income)-1
income_test$income <- c(income_test$income)-1

str <- ""
cols <- colnames(income_train)
for(i in 1:length(cols)-1){
	str <- paste(str, cols[i], sep=" + ")
}
str <- paste(str, "1", sep=" + ")
str <-  paste("income", str, sep=" ~ ")
str <- gsub("+  + ", "", str, fixed=TRUE)

  
model <- glm(eval(str),data=income_train, family="binomial")

test_predict <- predict(model, newdata=income_test, type="response")


error_rate <- 1 - sum(income_test$income == (test_predict >= 0.500))/length(test_predict)

