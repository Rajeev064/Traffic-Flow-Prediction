from flask import Flask, request, jsonify
import numpy as np
from keras.models import load_model

model = load_model("model.h5")

app = Flask(__name__)


# app-debug = True
@app.route("/")
def home():
    return "<h1>API For Traffic Prediction Project</h1>"


@app.route("/predict", methods=['GET'])
def prediction():
    parameters = request.args

    label = int(parameters.get('label'))
    hour = int(parameters.get('hour'))
    day = int(parameters.get('day'))

    # result = int(model.predict([[]]))
    result = int(np.argmax(model.predict([[label, hour, day]])))

    response = jsonify(
        {'result': result, 'speed': 35, 'time': 8}
    )

    return response

    # return "{} {} {} {}".format(result,label,hour,day)
    # output_list = [ {'result' : result,'speed' : 35, 'time' : 8} ]
    # return "{}".format(op)


if __name__ == "__main__":
    app.run()
