function [trainedClassifier, validationAccuracy] = trainClassifier_fineGaussSVM(trainingData)
% [trainedClassifier, validationAccuracy] = trainClassifier(trainingData)

%  [trainedClassifier, validationAccuracy] = trainClassifier_fineGaussSVM(IM_trainingDataset)


% Returns a trained classifier and its accuracy. This code recreates the
% classification model trained in Classification Learner app. Use the
% generated code to automate training the same model with new data, or to
% learn how to programmatically train models.
%
%  Input:
%      trainingData: A table containing the same predictor and response
%       columns as those imported into the app.
%
%
%  Output:
%      trainedClassifier: A struct containing the trained classifier. The
%       struct contains various fields with information about the trained
%       classifier.
%
%      trainedClassifier.predictFcn: A function to make predictions on new
%       data.
%
%      validationAccuracy: A double representing the validation accuracy as
%       a percentage. In the app, the Models pane displays the validation
%       accuracy for each model.
%
% Use the code to train the model with new data. To retrain your
% classifier, call the function from the command line with your original
% data or new data as the input argument trainingData.
%
% For example, to retrain a classifier trained with the original data set
% T, enter:
%   [trainedClassifier, validationAccuracy] = trainClassifier(T)
%
% To make predictions with the returned 'trainedClassifier' on new data T2,
% use
%   [yfit,scores] = trainedClassifier.predictFcn(T2)
%
% T2 must be a table containing at least the same predictor columns as used
% during training. For details, enter:
%   trainedClassifier.HowToPredict

% Auto-generated by MATLAB on 27-Sep-2023 10:08:40


% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
inputTable = trainingData;
% Split matrices in the input table into vectors
inputTable = [inputTable(:,setdiff(inputTable.Properties.VariableNames, {'CutX_Cut', 'CutX_CutExt', 'CutX_CutTight', 'CutX_CutTightExt', 'CutY_Cut', 'CutY_CutExt', 'CutY_CutTight', 'CutY_CutTightExt', 'CutZ_Cut', 'CutZ_CutExt'})), array2table(table2array(inputTable(:,{'CutX_Cut', 'CutX_CutExt', 'CutX_CutTight', 'CutX_CutTightExt', 'CutY_Cut', 'CutY_CutExt', 'CutY_CutTight', 'CutY_CutTightExt', 'CutZ_Cut', 'CutZ_CutExt'})), 'VariableNames', {'CutX_Cut_1', 'CutX_Cut_2', 'CutX_Cut_3', 'CutX_Cut_4', 'CutX_Cut_5', 'CutX_Cut_6', 'CutX_Cut_7', 'CutX_CutExt_1', 'CutX_CutExt_2', 'CutX_CutExt_3', 'CutX_CutExt_4', 'CutX_CutExt_5', 'CutX_CutExt_6', 'CutX_CutExt_7', 'CutX_CutTight_1', 'CutX_CutTight_2', 'CutX_CutTight_3', 'CutX_CutTight_4', 'CutX_CutTight_5', 'CutX_CutTight_6', 'CutX_CutTight_7', 'CutX_CutTightExt_1', 'CutX_CutTightExt_2', 'CutX_CutTightExt_3', 'CutX_CutTightExt_4', 'CutX_CutTightExt_5', 'CutX_CutTightExt_6', 'CutX_CutTightExt_7', 'CutY_Cut_1', 'CutY_Cut_2', 'CutY_Cut_3', 'CutY_Cut_4', 'CutY_Cut_5', 'CutY_Cut_6', 'CutY_Cut_7', 'CutY_CutExt_1', 'CutY_CutExt_2', 'CutY_CutExt_3', 'CutY_CutExt_4', 'CutY_CutExt_5', 'CutY_CutExt_6', 'CutY_CutExt_7', 'CutY_CutTight_1', 'CutY_CutTight_2', 'CutY_CutTight_3', 'CutY_CutTight_4', 'CutY_CutTight_5', 'CutY_CutTight_6', 'CutY_CutTight_7', 'CutY_CutTightExt_1', 'CutY_CutTightExt_2', 'CutY_CutTightExt_3', 'CutY_CutTightExt_4', 'CutY_CutTightExt_5', 'CutY_CutTightExt_6', 'CutY_CutTightExt_7', 'CutZ_Cut_1', 'CutZ_Cut_2', 'CutZ_Cut_3', 'CutZ_Cut_4', 'CutZ_Cut_5', 'CutZ_Cut_6', 'CutZ_Cut_7', 'CutZ_CutExt_1', 'CutZ_CutExt_2', 'CutZ_CutExt_3', 'CutZ_CutExt_4', 'CutZ_CutExt_5', 'CutZ_CutExt_6', 'CutZ_CutExt_7'})];

predictorNames = {'CutX_Cut_1', 'CutX_Cut_2', 'CutX_Cut_3', 'CutX_Cut_4', 'CutX_Cut_5', 'CutX_Cut_6', 'CutX_Cut_7', ...
                'CutX_CutExt_1', 'CutX_CutExt_2', 'CutX_CutExt_3', 'CutX_CutExt_4', 'CutX_CutExt_5', 'CutX_CutExt_6', 'CutX_CutExt_7', ...
                'CutX_CutTight_1', 'CutX_CutTight_2', 'CutX_CutTight_3', 'CutX_CutTight_4', 'CutX_CutTight_5', 'CutX_CutTight_6', 'CutX_CutTight_7',...
                'CutX_CutTightExt_1', 'CutX_CutTightExt_2', 'CutX_CutTightExt_3', 'CutX_CutTightExt_4', 'CutX_CutTightExt_5', 'CutX_CutTightExt_6', 'CutX_CutTightExt_7',...
                'CutY_Cut_1', 'CutY_Cut_2', 'CutY_Cut_3', 'CutY_Cut_4', 'CutY_Cut_5', 'CutY_Cut_6', 'CutY_Cut_7',...
                'CutY_CutExt_1', 'CutY_CutExt_2', 'CutY_CutExt_3', 'CutY_CutExt_4', 'CutY_CutExt_5', 'CutY_CutExt_6', 'CutY_CutExt_7',...
                'CutY_CutTight_1', 'CutY_CutTight_2', 'CutY_CutTight_3', 'CutY_CutTight_4', 'CutY_CutTight_5', 'CutY_CutTight_6', 'CutY_CutTight_7',...
                'CutY_CutTightExt_1', 'CutY_CutTightExt_2', 'CutY_CutTightExt_3', 'CutY_CutTightExt_4', 'CutY_CutTightExt_5', 'CutY_CutTightExt_6', 'CutY_CutTightExt_7',...
                'CutZ_Cut_1', 'CutZ_Cut_2', 'CutZ_Cut_3', 'CutZ_Cut_4', 'CutZ_Cut_5', 'CutZ_Cut_6', 'CutZ_Cut_7',...
                'CutZ_CutExt_1', 'CutZ_CutExt_2', 'CutZ_CutExt_3', 'CutZ_CutExt_4', 'CutZ_CutExt_5', 'CutZ_CutExt_6', 'CutZ_CutExt_7'};



predictors = inputTable(:, predictorNames);
response = inputTable.bodyGroupCategory;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
classNames = {'01'; '02'; '03'; '04'; '05'; '06'; '07'; '08'; '09'; '10'; '11'; '12'; '13'; '14'; '15'};

choosenFeatures = [  false false false false false false false ...  % 'CutX_Cut' 
                    false false false false false false false ...   % 'CutX_CutExt'
                    false false false false false false false ...   % 'CutX_CutTight'
                    true true true true true true true ...          % 'CutX_CutTightExt'
                    false false false false false false false ...   % 'CutY_Cut'
                    false false false false false false false ...   % 'CutY_CutExt'
                    false false false false false false false ...   % 'CutY_CutTight'
                    true true true true true true true ...          % 'CutY_CutTightExt'
                    false false false false false false false ...   % 'CutZ_Cut'
                    false false false false false false false];            % 'CutZ_CutExt'


% Data transformation: Select subset of the features
% This code selects the same subset of features as were used in the app.
% includedPredictorNames = predictors.Properties.VariableNames([  false false false false false false false ...   % 'CutX_Cut' 
%                                                                 false false false false false false false ...   % 'CutX_CutExt'
%                                                                 true true true true true true true ...          % 'CutX_CutTight'
%                                                                 false false false false false false false ...   % 'CutX_CutTightExt'
%                                                                 false false false false false false false ...   % 'CutY_Cut'
%                                                                 false false false false false false false ...   % 'CutY_CutExt'
%                                                                 true true true true true true true ...          % 'CutY_CutTight'
%                                                                 false false false false false false false ...   % 'CutY_CutTightExt'
%                                                                 false false false false false false false ...   % 'CutZ_Cut'
%                                                                 false false false false false false false]);    % 'CutZ_CutExt'


includedPredictorNames = predictors.Properties.VariableNames(choosenFeatures);   


predictors = predictors(:,includedPredictorNames);
% isCategoricalPredictor = isCategoricalPredictor([false false false false false false false false false false false false false false true true true true true true true false false false false false false false false false false false false false false false false false false false false false true true true true true true true false false false false false false false false false false false false false false false false false false false false false]);
isCategoricalPredictor = isCategoricalPredictor(choosenFeatures);


% Train a classifier
% This code specifies all the classifier options and trains the classifier.
template = templateSVM(...
    'KernelFunction', 'gaussian', ...
    'PolynomialOrder', [], ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true);
classificationSVM = fitcecoc(...
    predictors, ...
    response, ...
    'Learners', template, ...
    'Coding', 'onevsall', ...
    'ClassNames', classNames);

% Create the result struct with predict function
splitMatricesInTableFcn = @(t) [t(:,setdiff(t.Properties.VariableNames, {'CutX_Cut', 'CutX_CutExt', 'CutX_CutTight', 'CutX_CutTightExt', 'CutY_Cut', 'CutY_CutExt', 'CutY_CutTight', 'CutY_CutTightExt', 'CutZ_Cut', 'CutZ_CutExt'})), array2table(table2array(t(:,{'CutX_Cut', 'CutX_CutExt', 'CutX_CutTight', 'CutX_CutTightExt', 'CutY_Cut', 'CutY_CutExt', 'CutY_CutTight', 'CutY_CutTightExt', 'CutZ_Cut', 'CutZ_CutExt'})), 'VariableNames', {'CutX_Cut_1', 'CutX_Cut_2', 'CutX_Cut_3', 'CutX_Cut_4', 'CutX_Cut_5', 'CutX_Cut_6', 'CutX_Cut_7', 'CutX_CutExt_1', 'CutX_CutExt_2', 'CutX_CutExt_3', 'CutX_CutExt_4', 'CutX_CutExt_5', 'CutX_CutExt_6', 'CutX_CutExt_7', 'CutX_CutTight_1', 'CutX_CutTight_2', 'CutX_CutTight_3', 'CutX_CutTight_4', 'CutX_CutTight_5', 'CutX_CutTight_6', 'CutX_CutTight_7', 'CutX_CutTightExt_1', 'CutX_CutTightExt_2', 'CutX_CutTightExt_3', 'CutX_CutTightExt_4', 'CutX_CutTightExt_5', 'CutX_CutTightExt_6', 'CutX_CutTightExt_7', 'CutY_Cut_1', 'CutY_Cut_2', 'CutY_Cut_3', 'CutY_Cut_4', 'CutY_Cut_5', 'CutY_Cut_6', 'CutY_Cut_7', 'CutY_CutExt_1', 'CutY_CutExt_2', 'CutY_CutExt_3', 'CutY_CutExt_4', 'CutY_CutExt_5', 'CutY_CutExt_6', 'CutY_CutExt_7', 'CutY_CutTight_1', 'CutY_CutTight_2', 'CutY_CutTight_3', 'CutY_CutTight_4', 'CutY_CutTight_5', 'CutY_CutTight_6', 'CutY_CutTight_7', 'CutY_CutTightExt_1', 'CutY_CutTightExt_2', 'CutY_CutTightExt_3', 'CutY_CutTightExt_4', 'CutY_CutTightExt_5', 'CutY_CutTightExt_6', 'CutY_CutTightExt_7', 'CutZ_Cut_1', 'CutZ_Cut_2', 'CutZ_Cut_3', 'CutZ_Cut_4', 'CutZ_Cut_5', 'CutZ_Cut_6', 'CutZ_Cut_7', 'CutZ_CutExt_1', 'CutZ_CutExt_2', 'CutZ_CutExt_3', 'CutZ_CutExt_4', 'CutZ_CutExt_5', 'CutZ_CutExt_6', 'CutZ_CutExt_7'})];
extractPredictorsFromTableFcn = @(t) t(:, predictorNames);
predictorExtractionFcn = @(x) extractPredictorsFromTableFcn(splitMatricesInTableFcn(x));
featureSelectionFcn = @(x) x(:,includedPredictorNames);
svmPredictFcn = @(x) predict(classificationSVM, x);
trainedClassifier.predictFcn = @(x) svmPredictFcn(featureSelectionFcn(predictorExtractionFcn(x)));

% Add additional fields to the result struct5
trainedClassifier.RequiredVariables = {'CutX_Cut', 'CutX_CutExt', 'CutX_CutTight', 'CutX_CutTightExt', 'CutY_Cut', 'CutY_CutExt', 'CutY_CutTight', 'CutY_CutTightExt', 'CutZ_Cut', 'CutZ_CutExt'};
trainedClassifier.ClassificationSVM = classificationSVM;
trainedClassifier.About = 'This struct is a trained model exported from Classification Learner R2023a.';
trainedClassifier.HowToPredict = sprintf('To make predictions on a new table, T, use: \n  [yfit,scores] = c.predictFcn(T) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nThe table, T, must contain the variables returned by: \n  c.RequiredVariables \nVariable formats (e.g. matrix/vector, datatype) must match the original training data. \nAdditional variables are ignored. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');

% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
inputTable = trainingData;
% Split matrices in the input table into vectors
inputTable = [inputTable(:,setdiff(inputTable.Properties.VariableNames, {'CutX_Cut', 'CutX_CutExt', 'CutX_CutTight', 'CutX_CutTightExt', 'CutY_Cut', 'CutY_CutExt', 'CutY_CutTight', 'CutY_CutTightExt', 'CutZ_Cut', 'CutZ_CutExt'})), array2table(table2array(inputTable(:,{'CutX_Cut', 'CutX_CutExt', 'CutX_CutTight', 'CutX_CutTightExt', 'CutY_Cut', 'CutY_CutExt', 'CutY_CutTight', 'CutY_CutTightExt', 'CutZ_Cut', 'CutZ_CutExt'})), 'VariableNames', {'CutX_Cut_1', 'CutX_Cut_2', 'CutX_Cut_3', 'CutX_Cut_4', 'CutX_Cut_5', 'CutX_Cut_6', 'CutX_Cut_7', 'CutX_CutExt_1', 'CutX_CutExt_2', 'CutX_CutExt_3', 'CutX_CutExt_4', 'CutX_CutExt_5', 'CutX_CutExt_6', 'CutX_CutExt_7', 'CutX_CutTight_1', 'CutX_CutTight_2', 'CutX_CutTight_3', 'CutX_CutTight_4', 'CutX_CutTight_5', 'CutX_CutTight_6', 'CutX_CutTight_7', 'CutX_CutTightExt_1', 'CutX_CutTightExt_2', 'CutX_CutTightExt_3', 'CutX_CutTightExt_4', 'CutX_CutTightExt_5', 'CutX_CutTightExt_6', 'CutX_CutTightExt_7', 'CutY_Cut_1', 'CutY_Cut_2', 'CutY_Cut_3', 'CutY_Cut_4', 'CutY_Cut_5', 'CutY_Cut_6', 'CutY_Cut_7', 'CutY_CutExt_1', 'CutY_CutExt_2', 'CutY_CutExt_3', 'CutY_CutExt_4', 'CutY_CutExt_5', 'CutY_CutExt_6', 'CutY_CutExt_7', 'CutY_CutTight_1', 'CutY_CutTight_2', 'CutY_CutTight_3', 'CutY_CutTight_4', 'CutY_CutTight_5', 'CutY_CutTight_6', 'CutY_CutTight_7', 'CutY_CutTightExt_1', 'CutY_CutTightExt_2', 'CutY_CutTightExt_3', 'CutY_CutTightExt_4', 'CutY_CutTightExt_5', 'CutY_CutTightExt_6', 'CutY_CutTightExt_7', 'CutZ_Cut_1', 'CutZ_Cut_2', 'CutZ_Cut_3', 'CutZ_Cut_4', 'CutZ_Cut_5', 'CutZ_Cut_6', 'CutZ_Cut_7', 'CutZ_CutExt_1', 'CutZ_CutExt_2', 'CutZ_CutExt_3', 'CutZ_CutExt_4', 'CutZ_CutExt_5', 'CutZ_CutExt_6', 'CutZ_CutExt_7'})];

predictorNames = {'CutX_Cut_1', 'CutX_Cut_2', 'CutX_Cut_3', 'CutX_Cut_4', 'CutX_Cut_5', 'CutX_Cut_6', 'CutX_Cut_7', 'CutX_CutExt_1', 'CutX_CutExt_2', 'CutX_CutExt_3', 'CutX_CutExt_4', 'CutX_CutExt_5', 'CutX_CutExt_6', 'CutX_CutExt_7', 'CutX_CutTight_1', 'CutX_CutTight_2', 'CutX_CutTight_3', 'CutX_CutTight_4', 'CutX_CutTight_5', 'CutX_CutTight_6', 'CutX_CutTight_7', 'CutX_CutTightExt_1', 'CutX_CutTightExt_2', 'CutX_CutTightExt_3', 'CutX_CutTightExt_4', 'CutX_CutTightExt_5', 'CutX_CutTightExt_6', 'CutX_CutTightExt_7', 'CutY_Cut_1', 'CutY_Cut_2', 'CutY_Cut_3', 'CutY_Cut_4', 'CutY_Cut_5', 'CutY_Cut_6', 'CutY_Cut_7', 'CutY_CutExt_1', 'CutY_CutExt_2', 'CutY_CutExt_3', 'CutY_CutExt_4', 'CutY_CutExt_5', 'CutY_CutExt_6', 'CutY_CutExt_7', 'CutY_CutTight_1', 'CutY_CutTight_2', 'CutY_CutTight_3', 'CutY_CutTight_4', 'CutY_CutTight_5', 'CutY_CutTight_6', 'CutY_CutTight_7', 'CutY_CutTightExt_1', 'CutY_CutTightExt_2', 'CutY_CutTightExt_3', 'CutY_CutTightExt_4', 'CutY_CutTightExt_5', 'CutY_CutTightExt_6', 'CutY_CutTightExt_7', 'CutZ_Cut_1', 'CutZ_Cut_2', 'CutZ_Cut_3', 'CutZ_Cut_4', 'CutZ_Cut_5', 'CutZ_Cut_6', 'CutZ_Cut_7', 'CutZ_CutExt_1', 'CutZ_CutExt_2', 'CutZ_CutExt_3', 'CutZ_CutExt_4', 'CutZ_CutExt_5', 'CutZ_CutExt_6', 'CutZ_CutExt_7'};
predictors = inputTable(:, predictorNames);
response = inputTable.bodyGroupCategory;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
classNames = {'01'; '02'; '03'; '04'; '05'; '06'; '07'; '08'; '09'; '10'; '11'; '12'; '13'; '14'; '15'};


% Compute resubstitution predictions
[validationPredictions, validationScores] = predict(trainedClassifier.ClassificationSVM, predictors);

% Compute resubstitution accuracy
validationAccuracy = 1 - resubLoss(trainedClassifier.ClassificationSVM, 'LossFun', 'ClassifError');
