
close all
clear all
clc

addpath(genpath('lib\')); % add whole library to searchpath
addpath(genpath('dataset\')); % add whole dataset to searchpath
addpath(genpath('testBodies')); 

%% 

load('datasetBasicShapes.mat')


load('Body_08_res_1.mat')


%%
G_size = size(bodyData.G);
CutX_all = squeeze(bodyData.G(round(G_size(1)/2),:,:));
CutY_all = squeeze(bodyData.G(:,round(G_size(2)/2),:));

%% 

bodyData.symetry.symX = immse( CutX_all, flip(CutX_all,1));
bodyData.symetry.symY = immse( CutY_all, flip(CutY_all,1));