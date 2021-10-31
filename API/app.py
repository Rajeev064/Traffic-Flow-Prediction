import calendar
import pickle
from typing import Any, Union

import pandas as pd
from flask import Flask, request, jsonify

# Dictionary to get data from street name
# street_data = {
#     road name : [ intersection, public places, ways, label]
# }
street_data: dict[Union[str, Any], Union[list[int], Any]] = {
    "Adenwala Rd": [16, 14, 2, 0],
    "Adenwala Rd and Nathalal Parekh Marg": [9, 13, 2, 1],
    "Antop Hill Rd and Shaikh Misree Marg": [4, 3, 7, 2],
    "Balaram Babu Khedekar Marg": [8, 5, 1, 3],
    "Bharni Naka Rd/Sir Pochkhan Wala Rd/Vidyalankar College Rd": [2, 12, 2, 4],
    "Comrade Harbanslal Marg/Flank Rd": [9, 19, 1, 5],
    "Comrade Harbanslal Marg/Flank Rd and Dr Baba Saheb Ambedkar Rd": [9, 19, 1, 6],
    "Dadar TT Flyover/Eastern Express Hwy": [5, 8, 2, 7],
    "David S Barretto Rd": [6, 4, 2, 8],
    "David S Barretto Rd and Barkat Ali Dargah Rd": [9, 12, 2, 9],
    "Dr Baba Saheb Ambedkar Rd": [15, 19, 1, 10],
    "Eastern Express Hwy and Dr Baba Saheb Ambedkar Rd": [4, 6, 2, 11],
    "GD Ambekar Marg/Katrak Rd": [2, 5, 2, 12],
    "GD Ambekar Marg/Katrak Rd and Firdausi Rd": [8, 8, 2, 13],
    "Govindji Keni Rd": [4, 13, 1, 14],
    "Govindji Keni Rd and GD Ambekar Marg/Katrak Rd": [11, 5, 1, 15],
    "Govindji Keni Rd, Mahatma Jyotiba Phule Rd/Naigaon Rd and BJ Deorukhkar Marg/BJ Devrukhkar Rd": [1, 6, 1, 16],
    "H R Mahajani Rd": [1, 1, 2, 17],
    "Jerbai Wadia Rd": [5, 11, 1, 18],
    "Kings Cir/Matunga Cir and Puranmal Singhani Rd": [7, 19, 1, 19],
    "Lady Jamshedji Rd/LJ Rd and N C. Kelkar Rd": [8, 9, 2, 20],
    "Lady Jehangir Rd": [5, 6, 1, 21],
    "Mahatma Jyotiba Phule Rd/Naigaon Rd and MMGS Marg/Naigaon Cross Rd": [3, 32, 2, 22],
    "Mancherji Joshi Rd": [3, 4, 2, 23],
    "N C. Kelkar Rd and Lady Jamshedji Rd": [13, 38, 2, 24],
    "Nathalal Parekh Marg and Rafi Ahmed Kidwai Rd": [11, 14, 2, 25],
    "Puranmal Singhani Rd and Nathalal Parekh Marg": [2, 6, 2, 26],
    "Rafi Ahmed Kidwai Rd": [10, 8, 2, 27],
    "Rd Number 16 and Barkat Ali Dargah Rd": [6, 7, 2, 28],
    "SM Uphill Rd": [2, 8, 2, 29],
    "Shaikh Misree Marg": [10, 30, 1, 30],
    "Shaikh Misree Marg and JK Bhasin Marg": [11, 35, 1, 31],
    "Shaikh Misree Marg and SM Uphill Rd": [6, 12, 1, 32],
    "Taikalwadi Marg and JK Sawant Marg": [8, 9, 2, 33],
    "Tilak Rd": [4, 16, 2, 34],
    "Tilak Rd and Firdausi Rd": [3, 4, 2, 35],
    "Tilak Rd/Tilak Bridge/Tilak Flyover": [1, 13, 2, 36],
}


# Time Conversion Function
def time_opt(input_time):
    result_string = ""
    for i in range(0, 2):
        result_string = result_string + input_time[i]
    return result_string


# Date Conversion Function
def date_to_day(date):
    day, month, year = (int(i) for i in date.split(' '))
    day_number = calendar.weekday(year, month, day)
    return day_number + 1


# Output Float time to Minutes and Seconds
def op_time(time):
    minutes = int(time)
    seconds = int(60 * (time - int(time)))
    if (minutes >= 1) & (seconds >= 1):
        if minutes == 1:
            return "{} minute and {} seconds".format(minutes, seconds)
        else:
            return "{} minutes and {} seconds".format(minutes, seconds)
    if (minutes >= 1) & (seconds == 0):
        if minutes == 1:
            return "{} minute".format(minutes)
        else:
            return "{} minutes".format(minutes)
    if (minutes == 0) & (seconds > 1):
        if seconds == 1:
            return "{} second".format(seconds)
        else:
            return "{} seconds".format(seconds)


data = pd.read_csv('calculationdata.csv')
data = data.astype(str)

model = pickle.load(open('catboost_version2.pkl', 'rb'))

app = Flask(__name__)


@app.route("/")
def home():
    return "API For Traffic Prediction Project"


@app.route("/predict", methods=['GET'])
def predict():
    parameters = request.args

    street = "{}".format(parameters.get('street'))
    time = "{}".format(parameters.get('time'))
    date = "{}".format(parameters.get('date'))

    data_dict = street_data[street]
    label_enc_road = "{}".format(data_dict[3])

    hour = int(time_opt(time))

    day = date_to_day(date)

    model_result = model.predict([data_dict[0], data_dict[1], data_dict[2], data_dict[3], hour, day])
    result = "{}".format(model_result[0])

    filtr = data[(data['label_enc_road'] == label_enc_road) & (data['Congestion'] == result)]
    finaldata = filtr.astype(float)
    summation_columns = finaldata.sum(axis=0, skipna=True)

    mean_distance = (summation_columns['distance(meters)'] / len(finaldata.axes[0]))
    mean_speed = (summation_columns['Speed(m/s)'] / len(finaldata.axes[0]))
    mean_time = (summation_columns['duration(minutes)'] / len(finaldata.axes[0]))

    output_distance = "{:.2f} km".format(0.001 * mean_distance)
    output_speed = "{:d} km/hr".format(int(3.6 * mean_speed))
    output_time = op_time(mean_time)

    response = jsonify(
        {'congestion': result,
         'mean_distance': output_distance,
         'mean_speed': output_speed,
         'mean_time': output_time
         }
    )

    return response


if __name__ == "__main__":
    app.run()
