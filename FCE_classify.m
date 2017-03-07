% A demo of pattern classification with fMRI data. Reproduced from
% Poldrack's repository which is written in Python.
%     fMRI data, https://github.com/poldrack/fmri-classification-example
%     NIFTI, http://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image
%     Libsvm, http://www.csie.ntu.edu.tw/~cjlin/libsvm/ 
% 
% 2016-4-11 21:09:45

% clear,clc;

filename='fmri-classification-example-master/nback_zstats1-11-21_all.nii'; % fMRI data with 45 trials
maskname='fmri-classification-example-master/nback_mask.nii'; % mask
x=FCE_nii2x(filename,maskname); % data, 45*94487
label=kron([0:2],ones(1,15))'; % labels, 45*1

for shuffle=0:1 % shuffle the labels or not
    if shuffle==0
        fprintf('Classification... \n');
    elseif shuffle==1
        ix=randperm(45);
        label=label(ix);
        fprintf('\n');
        fprintf('Classification after shuffling the labels... \n');
    end
    
    sessions=kron(ones(1,3),[1:15])'; % for cross-validation
    tmp=zeros(size(label)); % save the predicted labels
    for i=1:15
        ix_train=find(sessions~=i); % index
        ix_test=find(sessions==i);
        
        x_train=x(ix_train,:); % data
        x_test=x(ix_test,:);
        
        label_train=label(ix_train); % label
        label_test=label(ix_test);
        
        % classify by linear SVM using Libsvm
        try
            options='-t 0 -q';
            model=svmtrain(label_train, x_train, options);
            label_predict=svmpredict(label_test, x_test, model);
        catch
            error(sprintf('Please check if LIBSVM is appropriately installed. \nSee libsvm-master/matlab/README for help.'));
        end
        
        tmp(ix_test)=label_predict;
    end
    label_predict=tmp;
    
    fprintf('Mean accuracy: %0.4f.\n', mean(label==label_predict));
    fprintf('Faces: %0.4f.\n', mean(label(label==0)==label_predict(label==0)));
    fprintf('Scenes: %0.4f.\n', mean(label(label==1)==label_predict(label==1)));
    fprintf('Characters: %0.4f.\n', mean(label(label==2)==label_predict(label==2)));
end

% % Output: 
% Classification... 
% Accuracy = 33.3333% (1/3) (classification)
% Accuracy = 100% (3/3) (classification)
% Accuracy = 66.6667% (2/3) (classification)
% Accuracy = 66.6667% (2/3) (classification)
% Accuracy = 100% (3/3) (classification)
% Accuracy = 33.3333% (1/3) (classification)
% Accuracy = 66.6667% (2/3) (classification)
% Accuracy = 66.6667% (2/3) (classification)
% Accuracy = 100% (3/3) (classification)
% Accuracy = 66.6667% (2/3) (classification)
% Accuracy = 66.6667% (2/3) (classification)
% Accuracy = 66.6667% (2/3) (classification)
% Accuracy = 66.6667% (2/3) (classification)
% Accuracy = 33.3333% (1/3) (classification)
% Accuracy = 66.6667% (2/3) (classification)
% Mean accuracy: 0.6667.
% Faces: 0.6667.
% Scenes: 0.7333.
% Characters: 0.6000.
% 
% Classification after shuffling the labels... 
% Accuracy = 0% (0/3) (classification)
% Accuracy = 0% (0/3) (classification)
% Accuracy = 33.3333% (1/3) (classification)
% Accuracy = 0% (0/3) (classification)
% Accuracy = 0% (0/3) (classification)
% Accuracy = 33.3333% (1/3) (classification)
% Accuracy = 0% (0/3) (classification)
% Accuracy = 0% (0/3) (classification)
% Accuracy = 33.3333% (1/3) (classification)
% Accuracy = 66.6667% (2/3) (classification)
% Accuracy = 0% (0/3) (classification)
% Accuracy = 33.3333% (1/3) (classification)
% Accuracy = 0% (0/3) (classification)
% Accuracy = 33.3333% (1/3) (classification)
% Accuracy = 0% (0/3) (classification)
% Mean accuracy: 0.1556.
% Faces: 0.1333.
% Scenes: 0.2000.
% Characters: 0.1333.
