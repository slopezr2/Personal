#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Apr 19 20:36:25 2020

@author: slopezr2
"""

plt.figure(figsize=(30,15))
plt.plot(datesx[n_train,:],datax[n_train,:],'b',linewidth=2,label='Input Data')
plt.plot(datesy[n_train],yhat[0,:],'g',linewidth=2,label='Prediction')
plt.plot(datesy[n_train],datay[n_train,:],'r*-',linewidth=1,markersize=5,label='Real Data')
plt.xticks(fontsize=14)
plt.yticks(fontsize=16)
plt.grid(axis='x')
plt.legend(fontsize=20)
ax = plt.gca()
xmin, xmax = ax.get_xlim()
custom_ticks = np.linspace(xmin, xmax, 10, dtype=int)
ax.set_xticks(custom_ticks)
plt.tight_layout()
plt.show()