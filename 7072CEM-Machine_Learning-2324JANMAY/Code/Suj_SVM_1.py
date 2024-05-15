# -*- coding: utf-8 -*-
"""
Created on Thu Mar 21 02:46:04 2024

@author: Sujan Tumbaraguddi
"""
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
import sklearn.svm as sv 

# Read the CSV file
KDD = pd.read_csv('C:/Users/Sujan Tumbaraguddi/Downloads/archive/train.csv')

# Encode categorical columns using LabelEncoder
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

# Split data into features (x) and target (y)
x = KDD.drop(columns=['attack_class'])
y = KDD['attack_class']

# Split the data into training and testing sets
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.2, random_state=42)

# Train SVM model
clsfi = sv.SVC(kernel='linear')
clsfi.fit(x_train, y_train)

# Calculate train accuracy
Acc_tr = clsfi.score(x_train, y_train)
print('SVM Train Accuracy=', Acc_tr)

# Make predictions on the test set
y_pred = clsfi.predict(x_test)

# Calculate test accuracy
Acc_test = clsfi.score(x_test, y_test)
print('SVM Test Accuracy=', Acc_test)

kernel_types = ['poly', 'linear', 'sigmoid', 'rbf']
degrees = range(1, 11)
Acc_tr = []

for kernel in kernel_types:
    acc_kernel = []
    for degree in degrees:
        # Train SVM model
        clsfi = sv.SVC(kernel=kernel, degree=degree)
        clsfi.fit(x_train, y_train)
        
        # Calculate train accuracy
        acc_kernel.append(clsfi.score(x_train, y_train))
    Acc_tr.append(acc_kernel)

# Plot results
plt.figure(figsize=(10, 6))
for i, kernel in enumerate(kernel_types):
    plt.plot(degrees, Acc_tr[i], marker='o', label=kernel)
plt.xlabel('Degree')
plt.ylabel('Accuracy')
plt.title('SVM Train Accuracy for Different Kernels and Degrees')
plt.legend()
plt.grid(True)
plt.show()