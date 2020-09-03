from sklearn.tree import DecisionTreeClassifier
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.ensemble import RandomForestClassifier
from matplotlib import pyplot
import numpy as np



def masklist(mylist,mymask):
    return [a for a,b in zip(mylist,mymask) if b]


class Machine_Learning:
    def __init__(self,X,y,features_labels=[],output_labels=[],handle_nan='Discard'):
        valid_handle=['Discard']
        if not(handle_nan in valid_handle ):
            print('Handle method for NaN is no valid. The valid handles are Discard')
            return
        if handle_nan in ['Discard']:
            mask=[]
            for i in range(len(X[0,0,:])):
                aux=np.sum(X[:,0,i])
                if np.isnan(aux):
                    mask.append(False)
                else:
                    mask.append(True)
        
        
        self.X=np.copy(X[:,:,mask])
        self.y=y
        self.features_labels=masklist(features_labels,mask)
        self.output_labels=output_labels
        removed_features=masklist(features_labels,[not x for x in mask])
        if len(removed_features)==0:
            print('No removed features')
        else:
            print('Removed features: ')
            for removed_feature in removed_features:
                print(removed_feature)
    def evaluate_importances(self,method='Decision_Tree',functionality='Classifier',plot=True,reduced=False,):
        valid_methods=['Decision_Tree','Decision Tree','Tree','Decision','DecisionTree','Random_Forest','Random Forest','RandomForest','Random','Forest']
        valid_functionalities=['Classifier','Classification','Forecast','Regression','Regressor']
        
        #Check Parameters
        if not(method in valid_methods):
            print('Method is no valid. The valid methods are Decision Tree and Random_Forest')
            return
        if not(functionality in valid_functionalities):
            print('Functionality is no valid. The valid functionalities are Classification and Regression')
            return
        
        if functionality in ['Classifier','Classification']:
            if method in ['Decision_Tree','Decision Tree','Tree','Decision','DecisionTree']:
                self.importances_model=DecisionTreeClassifier()
            else:
                self.importances_model=RandomForestClassifier()
        else:
             if method in ['Decision_Tree','Decision Tree','Tree','Decision','DecisionTree']:
                self.importances_model=DecisionTreeRegressor()
             else:
                self.importances_model=RandomForestRegressor()
        if reduced==False:     
            self.importances_model.fit(self.X[:,0,:],self.y[:,0])
            self.importance=self.importances_model.feature_importances_
            for i,v in enumerate(self.importance):
                if len(self.features_labels)>0:
                    print('Feature: '+self.features_labels[i] +', Score: %.5f' % (v))
                else:
                    print('Feature: %0d, Score: %.5f' % (i,v))
            
            if plot==True:
                if len(self.features_labels)>0:
                    pyplot.bar([x for x in range(len(self.importance))], self.importance)
                    pyplot.xticks(range(len(self.importance)),self.features_labels)
                    pyplot.show()
                else:
                    pyplot.bar([x for x in range(len(self.importance))], self.importance)
                    pyplot.show()
        else:
            self.importances_model.fit(self.reduced_X[:,0,:],self.y[:,0])
            self.reduced_importance=self.importances_model.feature_importances_
            for i,v in enumerate(self.reduced_importance):
                if len(self.reduced_features_labels)>0:
                    print('Feature: '+self.reduced_features_labels[i] +', Score: %.5f' % (v))
                else:
                    print('Feature: %0d, Score: %.5f' % (i,v))
            
            if plot==True:
                if len(self.reduced_features_labels)>0:
                    pyplot.bar([x for x in range(len(self.reduced_importance))], self.reduced_importance)
                    pyplot.xticks(range(len(self.reduced_importance)),self.reduced_features_labels)
                    pyplot.show()
                else:
                    pyplot.bar([x for x in range(len(self.reduced_importance))], self.reduced_importance)
                    pyplot.show()
    def reduce_features(self,reduce_to=-1):
        if reduce_to==-1:
            return
        if reduce_to > len(self.importance):
            print('New feature number is higher than current. Nothing to do.')
            return
        importance_sort=np.copy(self.importance)
        importance_sort=np.sort(importance_sort)[::-1]
        msk=[(el>importance_sort[reduce_to]) for el in self.importance]
        self.reduced_X = np.copy(self.X[:,:,msk])
        self.reduced_features_labels=masklist(self.features_labels,msk)