# univariate multi-step encoder-decoder lstm example
from numpy import array
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
model.add(LSTM(100, activation='relu', input_shape=(n_input_steps, n_features)))
model.add(RepeatVector(n_output_steps))
model.add(LSTM(100, activation='relu', return_sequences=True))
model.add(TimeDistributed(Dense(1)))
model.compile(optimizer='adam', loss='mse')
# fit model
model.fit(X, y, epochs=30, verbose=0, batch_size=200)
# demonstrate prediction
x_input = datax[n_train+10,:]
x_input = x_input.reshape((1, n_input_steps, n_features))
yhat = model.predict(x_input, verbose=0)