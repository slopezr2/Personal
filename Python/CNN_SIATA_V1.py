# univariate multi-step vector-output 1d cnn example
import os
from numpy import array
import tensorflow as tf
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import Flatten
from keras.layers import Conv1D
from keras.layers import MaxPooling1D

os.environ["CUDA_DEVICE_ORDER"] = "PCI_BUS_ID"
os.environ['CUDA_VISIBLE_DEVICES'] = '-1'
# reshape from [samples, timesteps] into [samples, timesteps, features]
n_features = 1
#n_train=5000
X=datax[0:n_train,:]
Y=datay[0:n_train,:]
X = X.reshape((X.shape[0], X.shape[1], n_features))
# define model
model = Sequential()
model.add(Conv1D(64, 2, activation='relu', input_shape=(n_input_steps, n_features)))
model.add(MaxPooling1D())
model.add(Flatten())
model.add(Dense(50, activation='relu'))
model.add(Dense(n_output_steps))
model.compile(optimizer='adam', loss='mse')
# fit model
model.fit(X, Y, epochs=2000, verbose=1)
# demonstrate prediction
x_input = datax[n_train,:]
x_input = x_input.reshape((1, n_input_steps, n_features))
yhat = model.predict(x_input, verbose=0)

plt.plot(np.arange(0,n_input_steps),datax[n_train,:])
plt.plot(np.arange(n_input_steps,n_input_steps+n_output_steps),yhat[0,:],'r')
plt.plot(np.arange(n_input_steps,n_input_steps+n_output_steps),datay[n_train,:],'g')
plt.show()