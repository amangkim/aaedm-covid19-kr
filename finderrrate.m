function [ meanErrR, ErrRate ] = finderrrate( RealData,PredictData )
% finderrrate
%   Detailed explanation goes here


X0 = RealData;
Y0 = PredictData;

ER = [];

len = min(length(X0),length(Y0));

X1 = X0(1:len);
Y1 = Y0(1:len);

nonzero_idx = find(X1~=0);

X2 = X1(nonzero_idx);
Y2 = Y1(nonzero_idx);

%ER = abs(X2-Y2)./X2;
ER = abs(X2-Y2)./Y2;
valid_idx =find(ER<=1);


ErrRate = ER(valid_idx);
meanErrR = mean (ErrRate);



end

