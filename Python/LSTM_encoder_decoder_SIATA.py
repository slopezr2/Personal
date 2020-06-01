# univariate multi-step encoder-decoder lstm example
from numpy import array
import tensorflow as tf
from keras.models import Sequential
from keras.layers import LSTM
from keras.layers import Dense
from keras.layers import RepeatVector
from keras.layers import TimeDistributed

# reshape from [samples, timesteps] into [samples, timesteps, features]
n_features = 1

X=datax[0:n_train,:]
y=datay[0:n_train,:]
X = X.reshape((X.shape[0], X.shape[1], n_features))
y = y.reshape((y.shape[0], y.shape[1], n_features))
# define model
model = Sequential()
model.add(LSTM(2000, input_shape=(n_input_steps, n_features)))
model.add(RepeatVector(n_output_steps))
model.add(LSTM(2000,  return_sequences=True))
model.add(TimeDistributed(Dense(1000, activation='relu' )))
model.add(TimeDistributed(Dense(1)))
model.compile(optimizer='adam', loss='mse', metrics=['accuracy'])
# fit model
model.fit(X, y, epochs=20, verbose=1, batch_size=16)
# demonstrate prediction
x_input = datax[n_train+10,:]
x_input = x_input.reshape((1, n_input_steps, n_features))
yhat = model.predict(x_input, verbose=1)

model.save('Models_save/LSTM_encoder_station82') 
