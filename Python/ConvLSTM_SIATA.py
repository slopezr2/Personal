# univariate multi-step encoder-decoder convlstm for the power usage dataset
from math import sqrt
from numpy import split
from numpy import array
from pandas import read_csv
from sklearn.metrics import mean_squared_error
from matplotlib import pyplot
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import Flatten
from keras.layers import LSTM
from keras.layers import RepeatVector
from keras.layers import TimeDistributed
from keras.layers import ConvLSTM2D

# reshape from [samples, timesteps] into [samples, timesteps, features]
n_features = 1
n_weeks=2
n_length=24*7
X=datax[0:n_train,:]
y=datay[0:n_train,:]
X = X.reshape((X.shape[0], X.shape[1], n_features))
y = y.reshape((y.shape[0], y.shape[1], n_features))

model = Sequential()
model.add(ConvLSTM2D(64, (1,3), activation='relu', input_shape=(n_weeks, 1, n_length, n_features)))
model.add(Flatten())
model.add(RepeatVector(n_output_steps))
model.add(LSTM(200, activation='relu', return_sequences=True))
model.add(TimeDistributed(Dense(100, activation='relu')))
model.add(TimeDistributed(Dense(1)))
model.compile(loss='mse', optimizer='adam')
# fit network
model.fit(X, y, epochs=20, verbose=1, batch_size=16)
# demonstrate prediction
x_input = datax[n_train+10,:]
x_input = x_input.reshape((1, n_input_steps, n_features))
yhat = model.predict(x_input, verbose=1)
