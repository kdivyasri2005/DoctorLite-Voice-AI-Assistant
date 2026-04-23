from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

import pandas as pd
import joblib

# ======================
# FASTAPI APP
# ======================

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ======================
# LOAD MODELS
# ======================

disease_model = joblib.load("disease_model.pkl")
severity_model = joblib.load("severity_model.pkl")

# symptom columns used during training
symptom_columns = joblib.load("symptom_columns.pkl")

# ======================
# REQUEST MODEL
# ======================

class SymptomRequest(BaseModel):
    text: str


# ======================
# SIMPLE NLP (from notebook)
# ======================

def extract_symptoms_from_text(text):

    text = text.lower()

    found = []

    for symptom in symptom_columns:

        if symptom.replace("_"," ") in text:
            found.append(symptom)

    return found


# ======================
# CONVERT SYMPTOMS → VECTOR
# ======================

def symptoms_to_vector(symptoms):

    vector = []

    for symptom in symptom_columns:

        if symptom in symptoms:
            vector.append(1)
        else:
            vector.append(0)

    return [vector]


# ======================
# ADVICE GENERATOR
# ======================

def generate_advice(severity):

    if severity == "High":
        return "Please consult a doctor immediately."

    elif severity == "Medium":
        return "Take rest, drink fluids and monitor symptoms."

    else:
        return "since it is amild condition. Stay hydrated and rest."


# ======================
# API ENDPOINT
# ======================

@app.post("/predict")

def predict(data: SymptomRequest):

    text = data.text

    symptoms = extract_symptoms_from_text(text)

    vector = symptoms_to_vector(symptoms)

    disease = disease_model.predict(vector)[0]

    severity = severity_model.predict(vector)[0]

    advice = generate_advice(severity)

    return {
        "predicted_disease": disease,
        "severity": severity,
        "advice": advice
    }