import numpy as np
import matplotlib. pyplot as plt

parameters=np.loadtxt("./Data/parameters_python.dat.out")
parameters=parameters.astype(int)
n=parameters[0]
m=parameters[1]
Nen=parameters[2]
tsim=parameters[3]


xamean=np.loadtxt("./Data/Xamean.dat")
xamean=np.reshape(xamean,(n,tsim),2)
xreal=np.loadtxt("./Data/Xreal.dat")
xreal=np.reshape(xreal,(n,tsim),2)
t=np.arange(tsim)


plt.subplot(141)
plt.plot(t,xreal[5,],'*')
plt.plot(t,xamean[5,],linewidth=2.5)
plt.title('State 5')
plt.legend(["X True", "Xa"], fontsize="small")
plt.xlabel("Time Steps")

plt.subplot(142)
plt.plot(t,xreal[10,],'*')
plt.plot( t,xamean[10,],linewidth=2.5)
plt.title('State 10')
plt.legend(["X True", "Xa"], fontsize="small")
plt.xlabel("Time Steps")

plt.subplot(143)
plt.plot(t,xreal[20,],'*')
plt.plot(t,xamean[20,],linewidth=2.5)
plt.title('State 20')
plt.legend(["X True", "Xa"], fontsize="small")
plt.xlabel("Time Steps")

plt.subplot(144)
plt.plot(t,xreal[30,],'*')
plt.plot(t,xamean[30,],linewidth=2.5)
plt.title('State 30')
plt.legend(["X True", "Xa"], fontsize="small")
plt.xlabel("Time Steps")

plt.show()

