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


SIATA_pm25=pd.read_csv('SIATA_pm25.csv')
SIATA_no2=pd.read_csv('SIATA_no2.csv')
SIATA_pm10=pd.read_csv('SIATA_pm10.csv')
SIATA_o3=pd.read_csv('SIATA_o3.csv')
SIATA_so2=pd.read_csv('SIATA_so2.csv')
SIATA_co=pd.read_csv('SIATA_co.csv')




station3_pm25=SIATA_pm25[SIATA_pm25['STATION'].values=='Station3']
station3_pm25['CONCENTRATION'].loc[station3_pm25['CONCENTRATION']<0]=np.NaN
station3_pm25.reset_index(inplace=True)
station3_no2=SIATA_no2[SIATA_no2['STATION'].values=='Station3']
station3_no2['CONCENTRATION'].loc[station3_no2['CONCENTRATION']<0]=np.NaN
station3_no2.drop_duplicates(subset ='Date',keep = 'last', inplace = True)
station3_no2.reset_index(inplace=True)
station3_pm10=SIATA_pm10[SIATA_pm10['STATION'].values=='Station3']
station3_pm10['CONCENTRATION'].loc[station3_pm10['CONCENTRATION']<0]=np.NaN
station3_pm10.reset_index(inplace=True)
station3_o3=SIATA_o3[SIATA_o3['STATION'].values=='Station3']
station3_o3['CONCENTRATION'].loc[station3_o3['CONCENTRATION']<0]=np.NaN
station3_o3.drop_duplicates(subset ='Date',keep = 'last', inplace = True)
station3_o3.reset_index(inplace=True)
station3_so2=SIATA_so2[SIATA_so2['STATION'].values=='Station3']
station3_so2['CONCENTRATION'].loc[station3_so2['CONCENTRATION']<0]=np.NaN
station3_so2.drop_duplicates(subset ='Date',keep = 'last', inplace = True)
station3_so2.reset_index(inplace=True)
station3_co=SIATA_co[SIATA_co['STATION'].values=='Station3']
station3_co['CONCENTRATION'].loc[station3_co['CONCENTRATION']<0]=np.NaN
station3_co.drop_duplicates(subset ='Date',keep = 'last', inplace = True)
station3_co.reset_index(inplace=True)


def create_dataset(dataset, look_back=1,step_forecast=1):
    dataX, dataY = [], []
    for i in range(len(dataset)-look_back-1):
        if (i + look_back+step_forecast) > len(dataset):
            break
        a = dataset[i:(i+look_back)]
        dataX.append(a)
        dataY.append(dataset[i + look_back:i + look_back+step_forecast])
    return np.array(dataX), np.array(dataY)


#=======Available Stations=====
#       ['Station11', 'Station12', 'Station25', 'Station28', 'Station3',
#       'Station31', 'Station37', 'Station38', 'Station40', 'Station41',
#       'Station43', 'Station44', 'Station46', 'Station48', 'Station6',
#       'Station69', 'Station74', 'Station78', 'Station79', 'Station80',
#       'Station81', 'Station82', 'Station83', 'Station84', 'Station85',
#       'Station86', 'Station87', 'Station88']
n_train=9500
#n_train=2000
station=SIATA_pm25[SIATA_pm25['STATION'].values=='Station84']
station['CONCENTRATION'].loc[station['CONCENTRATION']<0]=np.NaN
station.reset_index(inplace=True)
station['CONCENTRATION'].loc[np.isnan(station['CONCENTRATION'])]=np.nanmean(station['CONCENTRATION'])



values=(station.CONCENTRATION.values)
values=np.transpose(values)
dates=(station.Date.values)
dates=np.transpose(dates)

n_input_steps=24*7*2
n_output_steps=24*3
datax,datay=create_dataset(values,look_back=n_input_steps,step_forecast=n_output_steps)
datax[np.isnan(datax)]=np.nanmean(datax)
datay[np.isnan(datay)]=np.nanmean(datay)

datesx,datesy=create_dataset(dates,look_back=n_input_steps,step_forecast=n_output_steps)

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
#model = Sequential()
#model.add(LSTM(100,return_sequences=True, input_shape=(n_input_steps, n_features)))
##model.add(LSTM(100,return_sequences=True))
#model.add(LSTM(100))
#model.add(Dense(500, activation='relu' ))
#model.add(Dense(n_output_steps))
#model.compile(optimizer='adam', loss='mse',metrics=[RootMeanSquaredError()])
## fit model
#model.fit(X, y, epochs=300, verbose=1, batch_size=32)
# demonstrate prediction
x_input = datax[n_train+10,:]
x_input = x_input.reshape((1, n_input_steps))
x_input =scalerx.transform(x_input)
x_input = x_input.reshape((1, n_input_steps, n_features))
#yhat = model.predict(x_input, verbose=1)
#
#y_real=datay[n_train,:]
#yhat =scalery.inverse_transform(yhat)
#model.save('Models_save/LSTM_Vanilla_station82')
#
#testScore = math.sqrt(mean_squared_error(y_real[:], yhat[0,:]))
#print('Test Score: %.2f RMSE' % (testScore))
