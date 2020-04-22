# univariate multi-step vector-output mlp example
from keras import models
from keras import layers
import os  

# define model
model = models.Sequential()
model.add(layers.Dense(100, activation='relu', input_dim=n_input_steps))
model.add(layers.Dense(n_output_steps))
model.compile(optimizer='adam', loss='mse')
# fit model


model.fit(datax[0:n_train,:], datay[0:n_train,:], epochs=200, verbose=0)
# demonstrate prediction
x_input = datax[n_train+10,:]
x_input = x_input.reshape((1, n_input_steps))
yhat = model.predict(x_input, verbose=0)





