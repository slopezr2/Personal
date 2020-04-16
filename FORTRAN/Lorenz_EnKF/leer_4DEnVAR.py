import numpy as np
import matplotlib. pyplot as plt

parameters=np.loadtxt("./DATA_4DEnVAR/parameters_python.out")
parameters=parameters.astype(int)
n=parameters[0]
m=parameters[1]
Nen=parameters[2]
tsim=parameters[3]
dawindows=parameters[4]
sta_ass=parameters[5]

xamean=np.loadtxt("./DATA_4DEnVAR/Xamean.dat")
xamean=np.reshape(xamean,(n,tsim),2)
xreal=np.loadtxt("./DATA_4DEnVAR/Xreal.dat")
xreal=np.reshape(xreal,(n,tsim),2)
t=np.arange(tsim)
tass=np.arange(sta_ass,tsim)

plt.subplot(131)
plt.plot(t,xreal[5,],'*')
plt.plot(tass,xamean[5,sta_ass:tsim],linewidth=2.5)
plt.axvline(x=sta_ass,color='k')
plt.axvline(x=sta_ass+dawindows,color='g')
plt.plot(sta_ass,xamean[5,sta_ass],"Xy")
plt.title('State 5')
plt.legend(["X True", "Xa","Start Assimilation","End Assimilation","Inital Condition"], fontsize="small")
plt.xlabel("Time Steps")


plt.subplot(132)
plt.plot(t,xreal[20,],'*')
plt.plot(tass,xamean[20,sta_ass:tsim],linewidth=2.5)
plt.axvline(x=sta_ass,color='k')
plt.axvline(x=sta_ass+dawindows,color='g')
plt.plot(sta_ass,xamean[20,sta_ass],"Xy")
plt.title('State 20')
plt.legend(["X True", "Xa","Start Assimilation","End Assimilation","Initial Condition"], fontsize="small")
plt.xlabel("Time Steps")

plt.subplot(133)
plt.plot(t,xreal[30,],'*')
plt.plot(tass,xamean[30,sta_ass:tsim],linewidth=2.5)
plt.axvline(x=sta_ass,color='k')
plt.axvline(x=sta_ass+dawindows,color='g')
plt.plot(sta_ass,xamean[30,sta_ass],"Xy")
plt.title('State 30')
plt.legend(["X True", "Xa","Start Assimilation","End Assimilation","Initial Condition"], fontsize="small")
plt.xlabel("Time Steps")

plt.show()

