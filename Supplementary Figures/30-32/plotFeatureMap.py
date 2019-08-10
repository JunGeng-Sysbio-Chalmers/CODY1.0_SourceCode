print('''
The script is for the visualization of feature matrix.

Usage: python plotFeatureMap -infile infile  -outfile outfile

infile:  a csv file in which each row represents a sample and each column
         represents a feature.
outfile: the name of the figure. outfile could be .png, -pdf ...

Gang Li, 2018-01-08

''')

import sys
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

args = dict()
inputs = sys.argv
for i in range(len(inputs) - 1):
    item = inputs[i+1]
    if item.startswith('-'):args[item[1:]] = inputs[i+2]

def readData(infile):
    print('Loading dataset...\n')
    df = pd.read_csv(infile,index_col=0)
    keywords = [item.split('_')[0] for item in df.index]
    
    return df.values, np.array(keywords)

def remove_features_with_nan(data):
    print('Remove features with nan...')
    new_data = None
    for i in range(data.shape[1]):
        column = data[:,i].reshape([data.shape[0], 1])
        if len(column[np.isnan(column)]) == 0:
            if new_data is None: new_data = column
            else: new_data = np.hstack([new_data, column])
    print('   {} features were removed.\n'.format(data.shape[1] - new_data.shape[1]))
    return new_data

def normalize(data):
    print('Normalizing...\n')
    for i in range(data.shape[1]):
        data[:,i] = (data[:,i] - np.min(data[:,i])) / (np.max(data[:,i]) - np.min(data[:,i]))
    return data

def plot_heatmap(data, cmp, xlabel, ylabel):
    font = {'fontname':'Arial', 'size':12}
    x = range(data.shape[1])
    y = range(data.shape[0])
    plt.pcolormesh(x, y, data, cmap = cmp ) #Paired 'GnBu'
    zbar = plt.colorbar()
    zbar.set_label('Normalized Feature Values', **font)

    plt.xlabel(xlabel, **font)
    plt.ylabel(ylabel, **font)
    plt.xlim([0,len(x) - 1])
    plt.ylim([0,len(y) - 1])
    plt.xticks([])
    plt.yticks([])
    zbar.set_ticks([])

def plotHeatmap(data, outfile, keywords):

    x = range(data.shape[1])
    y = range(int(data.shape[0]/2))

    print('Producing figure...\n')
    font = {'fontname':'Arial', 'size':14}
    fig = plt.figure(figsize = (10,9))
    plt.subplot(3,1,1)
    plot_heatmap(data[keywords=='Lumen'], 'Blues', '', 'Lumen') #GnBu

    plt.subplot(3,1,2)
    plot_heatmap(data[keywords=='Mucosa'], 'Reds', str(data.shape[1])+' '+'Features', 'Mucosa') #Reds
    plt.subplots_adjust(left=None, bottom=None, right=None, top=None,
                wspace=None, hspace=0.033)
    
    plt.subplot(3,1,3)
    plot_heatmap(data[keywords=='Rectum'], 'Greys', str(data.shape[1])+' '+'Features', 'Rectum') #Reds
    plt.subplots_adjust(left=None, bottom=None, right=None, top=None,
                wspace=None, hspace=0.033)

    plt.savefig(outfile,dpi=500)


data,keywords = readData(args['infile'])
# data = normalize(data)
# data = remove_features_with_nan(data)

plotHeatmap(data, args['outfile'], keywords)

print('Done!')
