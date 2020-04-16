#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr 15 19:59:59 2020

@author: slopezr2
"""




def create_dataset(dataset, look_back=1,step_forecast=1):
    dataX, dataY = [], []
    for i in range(len(dataset)-look_back-1):
        if (i + look_back+step_forecast) > len(dataset):
            break
        a = dataset[i:(i+look_back)]
        dataX.append(a)
        dataY.append(dataset[i + look_back:i + look_back+step_forecast])
    return np.array(dataX), np.array(dataY)


values=(station3_pm25.CONCENTRATION.values)
values=np.transpose(values)
datax,datay=create_dataset(values,look_back=24*7*2,step_forecast=24*3)

