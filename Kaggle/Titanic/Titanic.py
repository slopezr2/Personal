from datamanager import Data_file
from machine_learning import Machine_Learning
import numpy as np
import matplotlib.pyplot as plt
train_file='./data/train.csv'
train_data=Data_file(train_file)
train_data.string_to_categorical('Sex')
train_data.string_to_categorical('Embarked')
train_data.combine(n_input_steps=1, n_output_steps=1, features=['Pclass','Age','SibSp','Parch','Fare','female','male','C','Q','S'],output='Survived')

Titanic=Machine_Learning(train_data.X,train_data.y,handle_nan='Discard',features_labels=['Pclass','Age','SibSp','Parch','Fare','female','male','C','Q','S'],output_labels='Survived')
Titanic.evaluate_importances(plot=True,method='Random')
Titanic.reduce_features(reduce_to=4)
Titanic.evaluate_importances(plot=True,method='Random',reduced=True)