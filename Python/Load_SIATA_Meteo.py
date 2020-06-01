#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime
from statsmodels.graphics.tsaplots import plot_pacf
from statsmodels.graphics.tsaplots import plot_acf
SIATA_Temperature=pd.read_csv('Meteo_SIATA_Temperature_total_V2.csv',delimiter=';')
SIATA_Wind=pd.read_csv('Meteo_SIATA_Wind_total_V2.csv',delimiter=';')
for i in range(0,len(SIATA_Temperature)):
    SIATA_Temperature.loc[i,'Date']=datetime(SIATA_Temperature.loc[i,'YEAR'],SIATA_Temperature.loc[i,'MONTH'],SIATA_Temperature.loc[i,'DAY'],SIATA_Temperature.loc[i,'HOUR'],0,0)

for i in range(0,len(SIATA_Wind)):
    SIATA_Wind.loc[i,'Date']=datetime(SIATA_Wind.loc[i,'YEAR'],SIATA_Wind.loc[i,'MONTH'],SIATA_Wind.loc[i,'DAY'],SIATA_Wind.loc[i,'HOUR'],0,0)





station82_Temperature=SIATA_Temperature[SIATA_Temperature['station'].values=='station82']
station82_Temperature['Value'].loc[station82_Temperature['Value']<0]=np.NaN
station82_Temperature.drop_duplicates(subset ='Date',keep = 'last', inplace = True)
station82_Temperature.reset_index(inplace=True)
station82_Wind=SIATA_Wind[SIATA_Wind['station'].values=='station82']
station82_Wind['Value'].loc[station82_Wind['Value']<0]=np.NaN
station82_Wind.drop_duplicates(subset ='Date',keep = 'last', inplace = True)
station82_Wind.reset_index(inplace=True)

#==Calculate moving mean===
plt.plot(station82_Temperature['Date'],station82_Temperature['Value'],linewidth=0.5)
ax = plt.gca()
xmin, xmax = ax.get_xlim()
custom_ticks = np.linspace(xmin, xmax, 15, dtype=int)
ax.set_xticks(custom_ticks)
plt.xlim(['2019-01-01','2019-04-01'])
plt.show()
#== Autocorrelation==
plt.figure
plot_acf(station82_Temperature.Value,missing='drop')

plt.figure
plt.plot(station82_Wind['Date'],station82_Wind['Value'],linewidth=0.5)
ax = plt.gca()
xmin, xmax = ax.get_xlim()
custom_ticks = np.linspace(xmin, xmax, 15, dtype=int)
ax.set_xticks(custom_ticks)
plt.xlim(['2019-01-01','2019-04-01'])
plt.show()
plt.figure
plot_acf(station82_Wind.Value,missing='drop')