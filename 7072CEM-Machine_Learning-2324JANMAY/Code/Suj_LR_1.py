import pandas as pd
import sklearn.linear_model as lm
import matplotlib.pyplot as plt
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, confusion_matrix
import seaborn as sns

# Read the CSV file
KDD = pd.read_csv('C:/Users/Sujan Tumbaraguddi/Downloads/archive/train.csv')

# Encode categorical columns using sparse encoding
Categorical_columns = ['protocol_type', 'service', 'flag', 'land', 'logged_in', 'root_shell', 
                       'num_shells', 'num_access_files', 'is_host_login', 'is_guest_login', 'attack_class']

# Initialize LabelEncoder for each categorical column
le_dict = {col: LabelEncoder() for col in Categorical_columns}

# Apply LabelEncoder to each categorical column
for col in Categorical_columns:
    KDD[col] = le_dict[col].fit_transform(KDD[col])

# Convert numerical columns to more memory-efficient data types
for col in KDD.select_dtypes(include=['int64']).columns:
    KDD[col] = pd.to_numeric(KDD[col], downcast='integer')

# Separate features (x) and target variable (y)
x = KDD.drop(columns=['attack_class']).values  # Convert to NumPy array
y = KDD['attack_class'].values  # Convert to NumPy array

# Split the data into training and testing sets
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.2, random_state=42)

# Train Logistic Regression model
Logistic_Reg = lm.LogisticRegression(max_iter=1000)  # Increase max_iter for convergence
Logistic_Reg.fit(x_train, y_train)

# Make predictions on the test set
predictions = Logistic_Reg.predict(x_test)

# Calculate accuracy based on predictions
accuracy = accuracy_score(y_test, predictions)
print("Accuracy:", accuracy)

# Calculate precision, recall, and F1-score
precision = precision_score(y_test, predictions, average='weighted')
recall = recall_score(y_test, predictions, average='weighted')
f1 = f1_score(y_test, predictions, average='weighted')
print("Precision:", precision)
print("Recall:", recall)
print("F1-score:", f1)

# Calculate confusion matrix
conf_matrix = confusion_matrix(y_test, predictions)
print("Confusion Matrix:\n", conf_matrix)

# Plot confusion matrix
plt.figure(figsize=(10, 8))
sns.heatmap(conf_matrix, annot=True, fmt='d', cmap='Blues', cbar=False)
plt.xlabel('Predicted labels')
plt.ylabel('True labels')
plt.title('Confusion Matrix')
plt.show()

# Evaluate accuracy for different regularization strengths (C values)
Acc1 = []
C_values = [0.001, 0.01, 0.1, 1, 10, 100]  # Regularization strengths
for C in C_values:
    Logistic_Reg = lm.LogisticRegression(C=C, max_iter=1000)
    Logistic_Reg.fit(x_train, y_train)
    predictions = Logistic_Reg.predict(x_test)
    accuracy = accuracy_score(y_test, predictions)
    Acc1.append(accuracy)
print(Acc1)

# Visualize accuracy
plt.figure()
plt.plot(C_values, Acc1, marker='o')
plt.xscale('log')  # Logarithmic scale for better visualization
plt.xlabel('Regularization Strength (C)')
plt.ylabel('Accuracy')
plt.title('Logistic Regression Accuracy vs Regularization Strength')
plt.show()
