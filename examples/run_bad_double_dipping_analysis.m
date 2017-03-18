%% Double dipping
% Load datasets using cosmo_fmri_dataset

nfeatures=10;
nsamples_per_class=20;
nclasses=2;
niter=1000;

% compute number of samples
nsamples=nclasses*nsamples_per_class;

% set targets
targets=repmat((1:nclasses)',nsamples_per_class,1);

% allocate space for output
accuracies=zeros(niter,2);

for iter=1:niter
    % generate random gaussian train data of size nsamples x nfeatures
    % assign the result to a variable 'train_data'
    % >@@>
    train_data=randn(nsamples,nfeatures);
    % <@@<

    % for the double dipping test data, assign 'double_dipping_test_data'
    % to be the same as the training data. (For real data analyses you
    % should never do this - its results are invalid)
    % >@@>
    double_dipping_test_data=train_data;
    % <@@<

    % for the independent data, generate test data and assign to a variable
    % 'independent_pred'
    % >@@>
    independent_pred=randn(nsamples,nfeatures);
    % <@@<

    % compute class labels predictions for both test sets using
    % cosmo_classify_lda. Store the predictions in
    % 'double_dipping_pred' and 'independent_pred', respectively
    % >@@>
    double_dipping_pred=cosmo_classify_lda(train_data,targets,...
                                                double_dipping_test_data);
    independent_pred=cosmo_classify_lda(train_data,targets,...
                                                independent_pred);
    % <@@<

    % compute classification accuracies
    double_dipping_acc=mean(double_dipping_pred==targets);
    independent_acc=mean(independent_pred==targets);

    % store accuracies in the iter-th row of the 'accuracies' matrix
    % >@@>
    accuracies(iter,:)=[double_dipping_acc, independent_acc];
    % <@@<
end

% show histogram
hist(accuracies,100)
legend({'double dipping','independent'})