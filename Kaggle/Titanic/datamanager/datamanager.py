import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from numpy import array
from sklearn.preprocessing import MinMaxScaler

class Data_file:
    #Class to manage Data, You can try self.data as a Pandas Data Frame
    def __init__(self,name_file):
        self.data=pd.read_csv(name_file)
        
    def variables(self):
        return list(self.data.columns) 
    
    
    def check_variable(self,variable):
        if variable in self.data.columns:
            check=True
        else:
            check=False
            
        return check
    
    def see_variable(self,variable,ini=0,end=10):
        if self.check_variable(variable):
            aux=self.get_values(variable)
            print(aux[ini:end])
            return aux[ini:end]
        else:
            print("Data Frame does not contain required variable")
    
    def get_values(self,variable):
        if self.check_variable(variable):
            return self.data[variable].values
        else:
            print("Data Frame does not contain required variable")     
            
    def plot_variable(self,variable):
        if self.check_variable(variable):
            plt.plot(self.data[variable].values)
        else:
            print("Data Frame does not contain required variable")
    
    def histogram(self,variable, by=None, grid=True, xlabelsize=None, xrot=None, ylabelsize=None, yrot=None, ax=None, figsize=None, bins=10 ):
        if self.check_variable(variable):
            self.data[variable].hist(by=None, grid=True, xlabelsize=None, xrot=None, ylabelsize=None, yrot=None, ax=None, figsize=None,  bins=10)
        else:
            print("Data Frame does not contain required variable")

    def string_to_categorical(self,variable):
        if self.check_variable(variable):
            dummies=pd.get_dummies(self.data[variable])
            self.data.drop(inplace=True,columns=variable)
            self.data=pd.concat([self.data,dummies],axis=1)
        else:
            print("Data Frame does not contain required variable")
    
    def crate_dataset(self,dataset,look_back=1, step_forecast=1):
        dataX, dataY = [], []
        for i in range(len(dataset) - look_back - 1):
            if (i + look_back + step_forecast) > len(dataset):
                break
            a = dataset[i:(i + look_back)]
            dataX.append(a)
            dataY.append(dataset[i + look_back:i + look_back + step_forecast])
        return np.array(dataX), np.array(dataY)

    def split_sequences(self, sequences, n_steps_in, n_steps_out):
        X, y = list(), list()
        for i in range(len(sequences)):
            # find the end of this pattern
            end_ix = i + n_steps_in
            out_end_ix = end_ix + n_steps_out
            # check if we are beyond the dataset
            if out_end_ix > len(sequences):
                break
            # gather input and output parts of the pattern
            seq_x, seq_y = sequences[i:end_ix, :-1], sequences[end_ix:out_end_ix, -1]
            X.append(seq_x)
            y.append(seq_y)
        return array(X), array(y)

    def scale(self, data):
        scalerT = MinMaxScaler(feature_range=(0, 1))
        scalerT = scalerT.fit(data)
        return scalerT.transform(data), scalerT

    def combine(self, n_input_steps, n_output_steps, features,output):
        self.scalers = []
        if len(features) > 1:
            all_data = []
            for feature in features:
                arg=self.get_values(feature)
                temp = arg.reshape((len(arg), 1))
                scaled, scaler = self.scale(temp)
                self.scalers.append(scaler)
                all_data.append(scaled)
            #Output
            arg=self.get_values(output)
            temp = arg.reshape((len(arg), 1))
            scaled, scaler = self.scale(temp)
            self.scalers.append(scaler)
            all_data.append(scaled)
            dataset = np.hstack(all_data)
            self.X,self.y=self.split_sequences(dataset, n_input_steps, n_output_steps)
            return self.split_sequences(dataset, n_input_steps, n_output_steps)
        else:
            return self.create_dataset(np.transpose( argv[0]), n_input_steps, n_output_steps)
   
    
    def __str__(self):
        return "El numero es "

