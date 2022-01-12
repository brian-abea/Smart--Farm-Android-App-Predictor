import numpy as np
from flask import Flask, request, jsonify
import pickle
import pandas as pd
app = Flask(__name__)
model = pickle.load(open('knn_new.pkl', 'rb'))


@app.route('/predict', methods=['POST'])
def predict():
    balance_data = pd.read_csv("final-crop.csv")
    df = balance_data[['Crop', 'Region', 'Sowing Time', 'Soil Type']].copy()
    df.shape

    # CROP

    save_crop = df["Crop"].unique()
    crop_dict = {}
    count = 1
    for i in save_crop:
        crop_dict[i] = count
        count = count+1

    def get_key(val):
        for key, value in crop_dict.items():
            if val == value:
                return key
        return "key doesn't exist"

    # SOWING TIME

    save_sowing = {"Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5,
                   "Jun": 6, "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12}

    # SOIL TYPE

    save_soil = df["Soil Type"].unique()
    soil_dict = {}
    count = 1
    for i in save_soil:
        soil_dict[i] = count
        count = count+1

    json_input = request.get_json()

    month = json_input["month"]
    temp = json_input["temp"]
    rain = json_input["rain"]
    soil = json_input["soil"]
    ph = json_input["ph"]

    val_temp = int(float(temp))
    val_rain = int(float(rain))
    month = int(save_sowing[month])
    soil = int(soil_dict[soil])
    prediction = model.predict(
        [[month, val_temp, val_temp, ph, soil, val_rain, val_rain]])
    output = get_key((prediction[0]))

    return jsonify({'prediction': output})


if __name__ == "__main__":
    app.run(debug=True)
