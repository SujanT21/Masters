import pandas as pd
import sklearn.neighbors as ne
import matplotlib.pyplot as plt
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.metrics import precision_score, recall_score, f1_score, roc_auc_score, confusion_matrix

# Read the CSV file
KDD = pd.read_csv('C:/Users/Sujan Tumbaraguddi/Downloads/archive/Train.csv')

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

# Train KNN model
KNN = ne.KNeighborsClassifier(n_neighbors=5)
KNN.fit(x_train, y_train)

# Make predictions on the test set
predictions = KNN.predict(x_test)

# Calculate accuracy based on predictions
accuracy = (predictions == y_test).mean()
print("Accuracy:", accuracy)

# Calculate precision, recall, F1-score, and AUC-ROC
precision = precision_score(y_test, predictions, average='weighted')
recall = recall_score(y_test, predictions, average='weighted')
f1 = f1_score(y_test, predictions, average='weighted')
auc_roc = roc_auc_score(y_test, predictions)
conf_matrix = confusion_matrix(y_test, predictions)

print("Precision:", precision)
print("Recall:", recall)
print("F1-score:", f1)
print("AUC-ROC:", auc_roc)
print("Confusion Matrix:\n", conf_matrix)

# Plot confusion matrix
plt.imshow(conf_matrix, cmap='Blues', interpolation='nearest')
plt.colorbar()
plt.title('Confusion Matrix')
plt.xlabel('Predicted labels')
plt.ylabel('True labels')
plt.show()

# Evaluate accuracy for different values of k
Acc1=[]
K_values=[]
for i in range(1,21):
    KNN1=ne.KNeighborsClassifier(n_neighbors=i)
    KNN1.fit(x_train, y_train)
    predictions = KNN1.predict(x_test)
    accuracy = (predictions == y_test).mean()
    Acc1.append(accuracy)
    K_values.append(i)
print(Acc1)
print(K_values)  

# Visualize accuracy
plt.figure()
plt.plot(K_values, Acc1, label='KNN', marker='o')
plt.xlabel('K_neighbors')
plt.ylabel('Accuracy')
plt.legend()
plt.show()
