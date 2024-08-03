install.packages(c("caret", "e1071", "randomForest"))

# Load the libraries
library(caret)
library(e1071)
library(randomForest)

data <- read.delim("~/HLW/GT OMSA/ISYE 6501/Week1/2.2credit_card_data-headersSummer2018.txt")

matrixdata <- as.matrix(data)
X <- as.matrix(data[, 1:10])  # Assuming columns 1 to 10 are V1 to V10
y <- as.factor(data$R1)

# Rename the levels of y to valid R variable names
levels(y) <- c("Class0", "Class1")

# Combine X and y into a data frame for modeling
df <- data.frame(X, y)

# Split the data into training and testing sets
set.seed(1)
trainIndex <- createDataPartition(df$y, p = .7, list = FALSE, times = 1)
train <- df[trainIndex, ]
test <- df[-trainIndex, ]

# Set up training control parameters
control <- trainControl(
  method = "cv", 
  number = 10, 
  classProbs = TRUE, 
  summaryFunction = twoClassSummary
)

# Train models using caret's train function
set.seed(1)

# KNN model
knn_model <- train(
  y ~ ., data = train, 
  method = "knn", 
  trControl = control, 
  tuneLength = 10, 
  metric = "ROC"
)

# SVM model
svm_model <- train(
  y ~ ., data = train, 
  method = "svmRadial", 
  trControl = control, 
  tuneLength = 10, 
  metric = "ROC"
)

# Random Forest model
rf_model <- train(
  y ~ ., data = train, 
  method = "rf", 
  trControl = control, 
  tuneLength = 10, 
  metric = "ROC"
)

# Compare models
models_results <- resamples(list(KNN = knn_model, SVM = svm_model, RF = rf_model))

# Display summary of results
summary(models_results)

# Visualize the results
dotplot(models_results)

