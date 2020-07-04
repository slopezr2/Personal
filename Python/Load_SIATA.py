#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from statsmodels.graphics.tsaplots import plot_pacf
from statsmodels.graphics.tsaplots import plot_acf
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

#==Calculate moving mean===
mean_3=station3_pm25.CONCENTRATION.rolling(window=3,min_periods=1,center=True).mean()
#plt.plot(station3_pm25['Date'],station3_pm25['CONCENTRATION'],linewidth=0.5)
plt.plot(station3_pm25['Date'],mean_3,linewidth=3)
ax = plt.gca()
xmin, xmax = ax.get_xlim()
custom_ticks = np.linspace(xmin, xmax, 15, dtype=int)
ax.set_xticks(custom_ticks)
plt.xlim([0,10945])
plt.show()
#== Autocorrelation==
plt.figure
plot_acf(station3_pm25.CONCENTRATION,missing='drop')

plt.figure
plot_pacf(station3_pm25.CONCENTRATION)
