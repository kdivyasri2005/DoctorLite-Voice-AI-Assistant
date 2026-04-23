import pandas as pd
import pickle

from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score

# Load dataset
df = pd.read_csv("simple_disease_dataset_200_rows.csv")

# Features
X = df.drop(["Disease", "Severity"], axis=1)

# Targets
y_disease = df["Disease"]
y_severity = df["Severity"]

# Save symptom columns
symptom_columns = X.columns.tolist()

# Train-test split
X_train, X_test, y_d_train, y_d_test = train_test_split(
    X, y_disease, test_size=0.2, random_state=42
)

_, _, y_s_train, y_s_test = train_test_split(
    X, y_severity, test_size=0.2, random_state=42
)

# Train models
disease_model = RandomForestClassifier(n_estimators=100)
disease_model.fit(X_train, y_d_train)

severity_model = RandomForestClassifier(n_estimators=100)
severity_model.fit(X_train, y_s_train)

# Evaluate
disease_pred = disease_model.predict(X_test)
severity_pred = severity_model.predict(X_test)

print("Disease Model Accuracy:", accuracy_score(y_d_test, disease_pred))
print("Severity Model Accuracy:", accuracy_score(y_s_test, severity_pred))

# Save models
pickle.dump(disease_model, open("disease_model.pkl", "wb"))
pickle.dump(severity_model, open("severity_model.pkl", "wb"))
pickle.dump(symptom_columns, open("symptom_columns.pkl", "wb"))

print("Models saved successfully!")