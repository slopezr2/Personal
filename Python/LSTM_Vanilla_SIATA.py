# univariate multi-step encoder-decoder lstm example
from numpy import array
from tensorflow.compat.v1.keras.models import Sequential
from tensorflow.compat.v1.keras.layers import LSTM
from tensorflow.compat.v1.keras.layers import Dense
from tensorflow.compat.v1.keras.layers import RepeatVector
from tensorflow.compat.v1.keras.layers import TimeDistributed
from keras.metrics import RootMeanSquaredError
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import mean_squared_error

# reshape from [samples, timesteps] into [samples, timesteps, features]
n_features = 1
scalerx = MinMaxScaler(feature_range=(0, 1))
scalery = MinMaxScaler(feature_range=(0, 1))
X=datax[0:n_train,:]
y=datay[0:n_train,:]
scalerx=scalerx.fit(X)
scalery=scalery.fit(y)
X=scalerx.transform(X)
y=scalery.transform(y)

X = X.reshape((X.shape[0], X.shape[1], n_features))
y = y.reshape((y.shape[0], y.shape[1], n_features))
# define model
model = Sequential()
model.add(LSTM(100,return_sequences=True, input_shape=(n_input_steps, n_features)))
#model.add(LSTM(100,return_sequences=True))
model.add(LSTM(100))
model.add(Dense(500, activation='relu' ))
model.add(Dense(n_output_steps))
model.compile(optimizer='adam', loss='mse',metrics=[RootMeanSquaredError()])
# fit model
model.fit(X, y, epochs=300, verbose=1, batch_size=32)
# demonstrate prediction
x_input = datax[n_train+10,:]
x_input = x_input.reshape((1, n_input_steps))
x_input =scalerx.transform(x_input)
x_input = x_input.reshape((1, n_input_steps, n_features))
yhat = model.predict(x_input, verbose=1)

y_real=datay[n_train,:]
yhat =scalery.inverse_transform(yhat)


testScore = math.sqrt(mean_squared_error(y_real[:], yhat[0,:]))
print('Test Score: %.2f RMSE' % (testScore))