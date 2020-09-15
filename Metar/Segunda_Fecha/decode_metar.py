from metar import Metar
import pandas as pd
import os

path = os.getcwd()

a=['./CONSULTA METAR - Santa_Marta.csv','./CONSULTA METAR - Barranquilla.csv','./CONSULTA METAR - Barrancabermeja.csv','./CONSULTA METAR - BOGOTA.csv','./CONSULTA METAR - Cartagena.csv','./CONSULTA METAR - MEDELLIN.csv','./CONSULTA METAR - Monteria.csv','./CONSULTA METAR - Riohacha.csv','./CONSULTA METAR - Santiago_De_Cali.csv','./CONSULTA METAR - Valledupar.csv']

for j in range(0, len(a), 1):
    print(j)
    os.chdir(path)
    df=pd.read_csv(a[j], sep=',',header=0)

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
   

    os.chdir("/run/media/dirac/Datos/Reciente_Dropbox/users/arjo/lotos-euros/Repositorio_Personal_Slopez/Personal/Metar/Segunda_Fecha/datos")
    information.to_csv(a[j], index = True)


