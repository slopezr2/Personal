from metar import Metar
import pandas as pd

<<<<<<< HEAD
a=['./CONSULTA METAR - IDEAM_SANTA_MARTA.csv','./CONSULTA METAR - IDEAM._Barranquilla.csv','./CONSULTA METAR - IDEAM_Barrancabermeja.csv','./CONSULTA METAR - IDEAM_BOGOTA.csv','./CONSULTA METAR - IDEAM_Cartagena.csv','./CONSULTA METAR - IDEAM_MEDELLIN.csv','./CONSULTA METAR - IDEAM_Monteria.csv','./CONSULTA METAR - IDEAM_Riohacha.csv','./CONSULTA METAR - IDEAM_Santiago_De_Cali.csv','./CONSULTA METAR - IDEAM_Valledupar.csv']

j=9

df=pd.read_csv(a[j], sep=',',header=0)
=======
df=pd.read_csv('./Metar_archivos/CONSULTA METAR - IDEAM_SANTA_MARTA.csv', sep=',',header=0)
>>>>>>> 69e7ac40330c16eb9d735a946f883e3b5dcb17f0

information = pd.DataFrame(columns=['D','T','P','DP'])
for row in df.iterrows():
    metar = row[1]['Informe']
    index=metar.find('/')
    if index==-1:
        T=None
        DP=None
        P=None
        print('Error al decodificar el METAR, "/" no encontrado')
        information = information.append({'D': row[1]['Fecha hora'], 'T': T,'P': P, 'DP': DP}, ignore_index=True)
        continue
    if metar[index+4]=='A':
        T=metar[index-2:index]
        T=int(T)
        DP=metar[index+1:index+3]
        DP=int(DP)
        P=metar[index+5:index+9]
        if P[0]=='/':
            P=None
            print('Error al decodificar el METAR, informacion de variable P faltante. Se encuentra "A////"')
            information = information.append({'D': row[1]['Fecha hora'], 'T': T,'P': P, 'DP': DP}, ignore_index=True)
            continue
        P=P[0:2]+'.'+P[2:]
        P=float(P)
    else:
        T=None
        DP=None
        P=None
        print('Error al decodificar el METAR, formato no coincide')
        information = information.append({'D': row[1]['Fecha hora'], 'T': T,'P': P, 'DP': DP}, ignore_index=True)
        continue

    print(row[1]['Fecha hora'],T, P, DP)
    information = information.append({'D': row[1]['Fecha hora'], 'T': T,'P': P, 'DP': DP}, ignore_index=True)
   
    
information.to_csv(r'./datos/datos.csv', index = True)
