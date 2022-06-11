#!/usr/bin/env python
# coding: utf-8

# In[1]:


# TensorFlow and tf.keras
import tensorflow as tf
# We import the PCA object from the sklearn package
from sklearn.decomposition import PCA

from mpl_toolkits.mplot3d import Axes3D
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt # plotting
import numpy as np # linear algebra
import os # accessing directory structure
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)

np.set_printoptions(precision=3, suppress=True) 

from tensorflow import keras
from tensorflow.keras import layers


# In[2]:


nRowsRead = None # specify 'None' if want to read whole file
# dataset_5secondWindow%5B1%5D.csv has 5893 rows in reality, but we are only loading/previewing the first 1000 rows
# Bouncing = pd.read_csv(r'C:\Users\mrahimid\Downloads\github_repo\dataset_5secondWindow.csv', delimiter=',', nrows = nRowsRead)
Bouncing  = pd.read_csv(r'C:\Users\mrahimid\Downloads\github_repo\Bouncing_dataset.csv', delimiter=',', nrows = nRowsRead)
validation = pd.read_csv(r'C:\Users\mrahimid\Downloads\github_repo\Bouncing_validation.csv', delimiter=',', nrows = nRowsRead)

Bouncing.head(7)

#validation.head(7)


# In[3]:


from sklearn import preprocessing
# label_encoder object knows how to understand word labels. 
label_encoder = preprocessing.LabelEncoder()
# Encode labels in column 'target'. 
Bouncing['Type']= label_encoder.fit_transform(Bouncing['Type']) 
Bouncing.head(5)


# In[4]:


pca = PCA(n_components=6) # we select all the features for now
pca.fit(Bouncing)
components  = 6

# To do: calculate the PC matrix A and the PC scores matrix Z. Then plot the first five PCs.
A = pca.components_.T
# hint: A is equal to the transpose of the attribute "components_" of the PCA object 
#       Z = X A
#Z = Bouncing[:,:5] @ A

# We use the attributes of PCA to find the explained variance in percentage
print("Variances (Percentage):")
print(pca.explained_variance_ratio_ * 100)

print("Cumulative Variances (Percentage):")
print(pca.explained_variance_ratio_.cumsum() * 100)

# plot a scree plot
components = len(pca.explained_variance_ratio_)     if components is None else components
plt.plot(range(1,components+1), 
         np.cumsum(pca.explained_variance_ratio_ * 100))
plt.xlabel("Number of components")
plt.ylabel("Explained variance (%)")

print(Bouncing)


# In[5]:


features = ['H1','H2','H3','H4','N','Time']
# Separating out the features
abalone_features = Bouncing.loc[:, features].values

# Separating out the target
abalone_labels = Bouncing.loc[:,['Type']].values

print(abalone_features)
print(abalone_labels)


# In[6]:


abalone_features = np.array(abalone_features)
#1350 rows
train_size = 1000
test_size = 1350

x_train= abalone_features[:train_size] #input of the model for training  1000
y_train= abalone_labels[:train_size] #output of the model for training  1000

x_val = abalone_features[train_size:test_size] # 1350-1000= 350 for the validation 
y_val = abalone_labels [train_size:test_size] # 1350-1000= 350 for the validation 


# In[7]:


Bouncing.loc[:,'Type'].value_counts() #the number of each type


# In[8]:


#Fully connected neural network model creation with 2 hidden layers
inputs = tf.keras.Input(shape=(6,)) #the imput is the number of features we have H1 H2 H3 H4 N Time

x = layers.Dense(64, activation="relu", name="dense_1")(inputs) #first hidden Layer
x = layers.Dense(64, activation="relu", name="dense_2")(x) #second hidden Layer

outputs = tf.keras.layers.Dense(6, activation=tf.nn.softmax)(x) #output 6 (the number of the t)
model = tf.keras.Model(inputs=inputs, outputs=outputs)


# In[9]:


# Overview of the model
model.summary()

# Documentation: https://www.tensorflow.org/guide/keras/train_and_evaluate/

model.compile(
  # optimizer = keras.optimizers.RMSprop(),
   tf.keras.optimizers.Adam(), 
   #optimizer=keras.optimizers.Adadelta(),
   # optimizer=keras.optimizers.RMSprop(),  # Optimizer
   # tf.keras.optimizers.SGD(),
    # Loss function to minimize
    loss=keras.losses.SparseCategoricalCrossentropy(),
    # List of metrics to monitor
    metrics=['accuracy'],
)


# In[10]:


history = model.fit(
    x_train,
    y_train,
    epochs=100,
    # We pass some validation for
    # monitoring validation loss and metrics
    # at the end of each epoch
    validation_data=(x_val, y_val),
)


# In[11]:


# Evaluate the model

plt.figure()
plt.plot(history.history['accuracy'], label='accuracy - RMSprop')
plt.plot(history.history['val_accuracy'], label = 'val_accuracy - RMSprop')

plt.xlabel('Epoch')
plt.ylabel('Accuracy')
plt.legend(loc='lower right')

test_loss, test_acc = model.evaluate(x_val, y_val, verbose=2)

print (test_loss)
print('test loss:', test_loss)
print('test accuracy:', test_acc)



# In[12]:


plt.figure()
plt.plot(history.history['val_loss'], label = 'val_loss - SGD')
plt.xlabel('Epoch')
plt.ylabel('value')
plt.legend(loc='upper right')

nmp = validation.to_numpy()
#print(nmp)


# In[13]:


# Prediction
probability_model = tf.keras.Sequential([model, tf.keras.layers.Softmax()])

predictions = probability_model.predict(nmp)
#predictions = probability_model.predict(x_val)

#print(y_val)

print(type(x_val))   
print(predictions)


# In[ ]:




