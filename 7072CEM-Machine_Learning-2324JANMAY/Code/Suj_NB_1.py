import pandas as pd
import matplotlib.pyplot as plt
import sklearn.naive_bayes as nb
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, confusion_matrix

# Read the CSV file
KDD = pd.read_csv('C:/Users/Sujan Tumbaraguddi/Downloads/archive/train.csv')

# Encode categorical columns
Categorical_columns = ['protocol_type', 'service', 'flag', 'land', 'logged_in', 'root_shell', 
                       'num_shells', 'num_access_files', 'is_host_login', 'is_guest_login', 'attack_class']

# Initialize LabelEncoder for each categorical column
le_dict = {col: LabelEncoder() for col in Categorical_columns}

# Apply LabelEncoder to each categorical column
for col in Categorical_columns:
    KDD[col] = le_dict[col].fit_transform(KDD[col])

# NB classifier
x = KDD.drop(columns=['attack_class'])
y = KDD['attack_class']

# Split the data into training and testing sets
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.2, random_state=42)

# Initialize the Naive Bayes classifier
NB = nb.GaussianNB()

# Fit the model
NB.fit(x_train, y_train)

# Make predictions on the test set
y_pred_test = NB.predict(x_test)

# Calculate test accuracy
test_accuracy = accuracy_score(y_test, y_pred_test)

# Calculate precision, recall, and F1-score
precision = precision_score(y_test, y_pred_test, average='weighted')
recall = recall_score(y_test, y_pred_test, average='weighted')
f1 = f1_score(y_test, y_pred_test, average='weighted')

print("Test Accuracy:", test_accuracy)
print("Precision:", precision)
print("Recall:", recall)
print("F1-score:", f1)

# Calculate and plot confusion matrix
conf_matrix = confusion_matrix(y_test, y_pred_test)
print("Confusion Matrix:\n", conf_matrix)

plt.imshow(conf_matrix, cmap='Blues', interpolation='nearest')
plt.colorbar()
plt.title('Confusion Matrix')
plt.xlabel('Predicted labels')
plt.ylabel('True labels')
plt.show()
