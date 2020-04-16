#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np
import pandas as pd
from datetime import datetime

#==Read csv file==
SIATA_pm25=pd.read_csv('/home/slopezr2/Documents/prueba_SIATA/Observaciones_SIATA_pm25_total_V2.csv',delimiter=';')
#==Drop not needed columns===
SIATA_pm25.drop(['ALT'],axis=1,inplace=True)
SIATA_pm25.drop(['AVERAGING_PERIOD'],axis=1,inplace=True)

#==Create column of date===
for i in range(0,len(SIATA_pm25)):
    SIATA_pm25.loc[i,'Date']=datetime(SIATA_pm25.loc[i,'YEAR'],SIATA_pm25.loc[i,'MONTH'],SIATA_pm25.loc[i,'DAY'],SIATA_pm25.loc[i,'HOUR'],0,0)

#==Drop other time columns==
SIATA_pm25.drop(['YEAR'],axis=1,inplace=True)
SIATA_pm25.drop(['MONTH'],axis=1,inplace=True)
SIATA_pm25.drop(['DAY'],axis=1,inplace=True)
SIATA_pm25.drop(['HOUR'],axis=1,inplace=True)

#==Change order columns==
cols=SIATA_pm25.columns.tolist()
cols = cols[-1:] + cols[:-1]
SIATA_pm25=SIATA_pm25[cols]

#== Clean Data==
SIATA_pm25['CONCENTRATION'].values[SIATA_pm25['CONCENTRATION']>120]=np.NaN

#==Export to csv==
SIATA_pm25.to_csv('SIATA_pm25.csv',index=None)

#==Read csv file==
SIATA_no2=pd.read_csv('/home/slopezr2/Documents/prueba_SIATA/Observaciones_SIATA_no2_total_V2.csv',delimiter=';')
#==Drop not needed columns===
SIATA_no2.drop(['ALT'],axis=1,inplace=True)
SIATA_no2.drop(['AVERAGING_PERIOD'],axis=1,inplace=True)

#==Create column of date===
for i in range(0,len(SIATA_no2)):
    SIATA_no2.loc[i,'Date']=datetime(SIATA_no2.loc[i,'YEAR'],SIATA_no2.loc[i,'MONTH'],SIATA_no2.loc[i,'DAY'],SIATA_no2.loc[i,'HOUR'],0,0)

#==Drop other time columns==
SIATA_no2.drop(['YEAR'],axis=1,inplace=True)
SIATA_no2.drop(['MONTH'],axis=1,inplace=True)
SIATA_no2.drop(['DAY'],axis=1,inplace=True)
SIATA_no2.drop(['HOUR'],axis=1,inplace=True)

#==Change order columns==
cols=SIATA_no2.columns.tolist()
cols = cols[-1:] + cols[:-1]
SIATA_no2=SIATA_no2[cols]

#== Clean Data==
SIATA_no2['CONCENTRATION'].values[SIATA_no2['CONCENTRATION']>120]=np.NaN

#==Export to csv==
SIATA_no2.to_csv('SIATA_no2.csv',index=None)

#==Read csv file==
SIATA_o3=pd.read_csv('/home/slopezr2/Documents/prueba_SIATA/Observaciones_SIATA_o3_total_V2.csv',delimiter=';')
#==Drop not needed columns===
SIATA_o3.drop(['ALT'],axis=1,inplace=True)
SIATA_o3.drop(['AVERAGING_PERIOD'],axis=1,inplace=True)

#==Create column of date===
for i in range(0,len(SIATA_o3)):
    SIATA_o3.loc[i,'Date']=datetime(SIATA_o3.loc[i,'YEAR'],SIATA_o3.loc[i,'MONTH'],SIATA_o3.loc[i,'DAY'],SIATA_o3.loc[i,'HOUR'],0,0)

#==Drop other time columns==
SIATA_o3.drop(['YEAR'],axis=1,inplace=True)
SIATA_o3.drop(['MONTH'],axis=1,inplace=True)
SIATA_o3.drop(['DAY'],axis=1,inplace=True)
SIATA_o3.drop(['HOUR'],axis=1,inplace=True)

#==Change order columns==
cols=SIATA_o3.columns.tolist()
cols = cols[-1:] + cols[:-1]
SIATA_o3=SIATA_o3[cols]

#== Clean Data==
SIATA_o3['CONCENTRATION'].values[SIATA_o3['CONCENTRATION']>120]=np.NaN

#==Export to csv==
SIATA_o3.to_csv('SIATA_o3.csv',index=None)

#==Read csv file==
SIATA_pm10=pd.read_csv('/home/slopezr2/Documents/prueba_SIATA/Observaciones_SIATA_pm10_total_V2.csv',delimiter=';')
#==Drop not needed columns===
SIATA_pm10.drop(['ALT'],axis=1,inplace=True)
SIATA_pm10.drop(['AVERAGING_PERIOD'],axis=1,inplace=True)

#==Create column of date===
for i in range(0,len(SIATA_pm10)):
    SIATA_pm10.loc[i,'Date']=datetime(SIATA_pm10.loc[i,'YEAR'],SIATA_pm10.loc[i,'MONTH'],SIATA_pm10.loc[i,'DAY'],SIATA_pm10.loc[i,'HOUR'],0,0)

#==Drop other time columns==
SIATA_pm10.drop(['YEAR'],axis=1,inplace=True)
SIATA_pm10.drop(['MONTH'],axis=1,inplace=True)
SIATA_pm10.drop(['DAY'],axis=1,inplace=True)
SIATA_pm10.drop(['HOUR'],axis=1,inplace=True)

#==Change order columns==
cols=SIATA_pm10.columns.tolist()
cols = cols[-1:] + cols[:-1]
SIATA_pm10=SIATA_pm10[cols]

#== Clean Data==
SIATA_pm10['CONCENTRATION'].values[SIATA_pm10['CONCENTRATION']>120]=np.NaN

#==Export to csv==
SIATA_pm10.to_csv('SIATA_pm10.csv',index=None)

#==Read csv file==
SIATA_so2=pd.read_csv('/home/slopezr2/Documents/prueba_SIATA/Observaciones_SIATA_so2_total_V2.csv',delimiter=';')
#==Drop not needed columns===
SIATA_so2.drop(['ALT'],axis=1,inplace=True)
SIATA_so2.drop(['AVERAGING_PERIOD'],axis=1,inplace=True)

#==Create column of date===
for i in range(0,len(SIATA_so2)):
    SIATA_so2.loc[i,'Date']=datetime(SIATA_so2.loc[i,'YEAR'],SIATA_so2.loc[i,'MONTH'],SIATA_so2.loc[i,'DAY'],SIATA_so2.loc[i,'HOUR'],0,0)

#==Drop other time columns==
SIATA_so2.drop(['YEAR'],axis=1,inplace=True)
SIATA_so2.drop(['MONTH'],axis=1,inplace=True)
SIATA_so2.drop(['DAY'],axis=1,inplace=True)
SIATA_so2.drop(['HOUR'],axis=1,inplace=True)

#==Change order columns==
cols=SIATA_so2.columns.tolist()
cols = cols[-1:] + cols[:-1]
SIATA_so2=SIATA_so2[cols]

#== Clean Data==
SIATA_so2['CONCENTRATION'].values[SIATA_so2['CONCENTRATION']>120]=np.NaN

#==Export to csv==
SIATA_so2.to_csv('SIATA_so2.csv',index=None)

#==Read csv file==
SIATA_co=pd.read_csv('/home/slopezr2/Documents/prueba_SIATA/Observaciones_SIATA_co_total_V2.csv',delimiter=';')
#==Drop not needed columns===
SIATA_co.drop(['ALT'],axis=1,inplace=True)
SIATA_co.drop(['AVERAGING_PERIOD'],axis=1,inplace=True)

#==Create column of date===
for i in range(0,len(SIATA_co)):
    SIATA_co.loc[i,'Date']=datetime(SIATA_co.loc[i,'YEAR'],SIATA_co.loc[i,'MONTH'],SIATA_co.loc[i,'DAY'],SIATA_co.loc[i,'HOUR'],0,0)

#==Drop other time columns==
SIATA_co.drop(['YEAR'],axis=1,inplace=True)
SIATA_co.drop(['MONTH'],axis=1,inplace=True)
SIATA_co.drop(['DAY'],axis=1,inplace=True)
SIATA_co.drop(['HOUR'],axis=1,inplace=True)

#==Change order columns==
cols=SIATA_co.columns.tolist()
cols = cols[-1:] + cols[:-1]
SIATA_co=SIATA_co[cols]

#== Clean Data==
SIATA_co['CONCENTRATION'].values[SIATA_co['CONCENTRATION']>120]=np.NaN

#==Export to csv==
SIATA_co.to_csv('SIATA_co.csv',index=None)
