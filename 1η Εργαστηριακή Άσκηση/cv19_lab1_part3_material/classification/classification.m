function classification(features)
addpath(genpath('libsvm-3.17'));

%% Image Classification
parfor k=1:5
    %% Split train and test set
    [data_train,label_train,data_test,label_test]=createTrainTest(features,k);
    %% Bag of Words
    [BOF_tr,BOF_ts]=BagOfWords(data_train,data_test);
    %% SVM classification
    [percent(k),KMea] = svm(BOF_tr,label_train,BOF_ts,label_test);
    fprintf('Classification Accuracy: %f %%\n',percent(k)*100);
end
fprintf('Average Classification Accuracy: %f %%\n',mean(percent)*100);
end