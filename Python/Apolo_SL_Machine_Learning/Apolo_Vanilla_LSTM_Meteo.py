#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from tensorflow.compat.v1.keras.models import Sequential
from tensorflow.compat.v1.keras.layers import LSTM
from tensorflow.compat.v1.keras.layers import Dense
from tensorflow.compat.v1.keras.layers import RepeatVector
from tensorflow.compat.v1.keras.layers import TimeDistributed
from keras.metrics import RootMeanSquaredError
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import mean_squared_error
from datetime import datetime



def create_dataset(dataset, look_back=1,step_forecast=1):
    dataX, dataY = [], []
    for i in range(len(dataset)-look_back-1):
        if (i + look_back+step_forecast) > len(dataset):
            break
        a = dataset[i:(i+look_back)]
        dataX.append(a)
        dataY.append(dataset[i + look_back:i + look_back+step_forecast])
    return np.array(dataX), np.array(dataY)


# split a multivariate sequence into samples 
def split_sequences(sequences, n_steps_in, n_steps_out): 
    X, y = list(), list() 
    for i in range(len(sequences)): 
        # find the end of this pattern 
        end_ix = i + n_steps_in 
        out_end_ix = end_ix + n_steps_out 
        # check if we are beyond the dataset 
        if out_end_ix > len(sequences): 
            break
        # gather input and output parts of the pattern 
        seq_x, seq_y = sequences[i:end_ix, :-1], sequences[end_ix:out_end_ix, -1] 
        X.append(seq_x) 
        y.append(seq_y)
    return array(X), array(y)


# convert history into inputs and outputs
def to_supervised(train, n_input, n_out=24*3):
	# flatten data
	data = train.reshape((train.shape[0]*train.shape[1], train.shape[2]))
	X, y = list(), list()
	in_start = 0
	# step over the entire history one time step at a time
	for _ in range(len(data)):
		# define the end of the input sequence
		in_end = in_start + n_input
		out_end = in_end + n_out
		# ensure we have enough data for this instance
		if out_end <= len(data):
			X.append(data[in_start:in_end, :])
			y.append(data[in_end:out_end, 0])
		# move along one time step
		in_start += 1
	return array(X), array(y)







##===Load Data===
SIATA_pm25=pd.read_csv('SIATA_pm25.csv')
SIATA_Temperature=pd.read_csv('Meteo_SIATA_Temperature_total_V2.csv',delimiter=';')
SIATA_Wind=pd.read_csv('Meteo_SIATA_Wind_total_V2.csv',delimiter=';')
for i in range(0,len(SIATA_Temperature)):
    SIATA_Temperature.loc[i,'Date']=datetime(SIATA_Temperature.loc[i,'YEAR'],SIATA_Temperature.loc[i,'MONTH'],SIATA_Temperature.loc[i,'DAY'],SIATA_Temperature.loc[i,'HOUR'],0,0)

for i in range(0,len(SIATA_Wind)):
    SIATA_Wind.loc[i,'Date']=datetime(SIATA_Wind.loc[i,'YEAR'],SIATA_Wind.loc[i,'MONTH'],SIATA_Wind.loc[i,'DAY'],SIATA_Wind.loc[i,'HOUR'],0,0)

station_Temperature=SIATA_Temperature[SIATA_Temperature['station'].values=='station82']
station_Temperature['Value'].loc[station_Temperature['Value']<0]=np.NaN
station_Temperature.drop_duplicates(subset ='Date',keep = 'last', inplace = True)
station_Temperature.reset_index(inplace=True)
station_Wind=SIATA_Wind[SIATA_Wind['station'].values=='station82']
station_Wind['Value'].loc[station_Wind['Value']<0]=np.NaN
station_Wind.drop_duplicates(subset ='Date',keep = 'last', inplace = True)
station_Wind.reset_index(inplace=True)

station=SIATA_pm25[SIATA_pm25['STATION'].values=='Station84']
station['CONCENTRATION'].loc[station['CONCENTRATION']<0]=np.NaN
station.reset_index(inplace=True)
station['CONCENTRATION'].loc[np.isnan(station['CONCENTRATION'])]=np.nanmean(station['CONCENTRATION'])

# choose a number of time steps 
n_input_steps=7*2*24
n_output_steps=3*24


# define input sequence
in_seq1=station_Temperature.Value.values
in_seq2=station_Wind.Value.values
in_seq3=station.CONCENTRATION.values
out_seq=station.CONCENTRATION.values



# convert to [rows, columns] structure

in_seq1 = in_seq1.reshape((len(in_seq1), 1)) 
in_seq2 = in_seq2.reshape((len(in_seq2), 1)) 
in_seq3=in_seq3.reshape((len(in_seq3), 1))
out_seq = out_seq.reshape((len(out_seq), 1)) #

## Scalete data
scalerT = MinMaxScaler(feature_range=(0, 1))
scalerW = MinMaxScaler(feature_range=(0, 1))
scalerC = MinMaxScaler(feature_range=(0, 1))
scalerT=scalerT.fit(in_seq1)
scalerW=scalerW.fit(in_seq2)
scalerC=scalerC.fit(in_seq3)

in_seq1=scalerT.transform(in_seq1)
in_seq2=scalerW.transform(in_seq2)
in_seq3=scalerC.transform(in_seq3)
out_seq=scalerC.transform(out_seq)

# horizontally stack columns 
dataset = np.hstack((in_seq1, in_seq2,in_seq3, out_seq)) 

# covert into input/output 
X, y = split_sequences(dataset, n_input_steps, n_output_steps) 

#=======Available Stations=====
#       ['Station11', 'Station12', 'Station25', 'Station28', 'Station3',
#       'Station31', 'Station37', 'Station38', 'Station40', 'Station41',
#       'Station43', 'Station44', 'Station46', 'Station48', 'Station6',
#       'Station69', 'Station74', 'Station78', 'Station79', 'Station80',
#       'Station81', 'Station82', 'Station83', 'Station84', 'Station85',
#       'Station86', 'Station87', 'Station88']
n_features = X.shape[2]
n_train=9500


# define model
model = Sequential()
model.add(LSTM(100,return_sequences=True, input_shape=(n_input_steps, n_features)))
model.add(LSTM(100,return_sequences=True))
model.add(LSTM(100))
model.add(Dense(50, activation='relu' ))
model.add(Dense(n_output_steps))
model.compile(optimizer='adam', loss='mse',metrics=[RootMeanSquaredError()])
# fit model
model.fit(X, y, epochs=3, verbose=1, batch_size=32)
# demonstrate prediction
x_input = X[9500+1,:,:]
x_input=x_input.reshape((1,x_input.shape[0],x_input.shape[1]))
yhat = model.predict(x_input, verbose=1)

y_real=y[9500+1,:]
yhat =scalerC.inverse_transform(yhat)
yreal =scalerC.inverse_transform(yreal)
model.save('Models_save/LSTM_Vanilla_station82_Meteo')

testScore = math.sqrt(mean_squared_error(y_real[:], yhat[0,:]))
print('Test Score: %.2f RMSE' % (testScore))
