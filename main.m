function [theta_hat] = main(  )
    %read the data
	[Ts, u1, u2, y1] = textread('pHdata.dat');
    data = iddata(y1,[ u1 u2],'ts',10); %10 seconds sampling time
    [dim1,dim2,dim3] = size(data);
    lastRow = int32(floor(0.4* dim1));
    training_data = iddata(y1(1:lastRow), [u1(1:lastRow) u2(1:lastRow)],'ts',10);
    test_data = iddata(y1(1+lastRow:end),[u1(1+lastRow:end) u2(1+lastRow:end)],'ts',10);
    y1 = training_data.y;
    na = 1; %for y1
    nb = [3 3]; %number of u1 and u2 used to predict y1
    nk = [1 1]; %time delay starting from 1
    orders = [na nb nk];
    %PEM
    %froe_pem_1_reg = froe(1,5e-08,'prediction');
    %froe_pem_3_reg = froe(3,5e-08,'prediction');
    %froe_pem_8_reg = froe(0,5e-98, 'simulation');

    %SEM
    %froe_sem_1_reg = froe(1,5e-08,'simulation');
    %froe_sem_3_reg = froe(3,5e-08,'simulation');
    %froe_sem_8_reg = froe(8,5e-08, 'simulation');



    %Linear Model
    %linear_model = froe(0);

    %Neural Networks
    %ff_2_lm = nlarx(training_data,orders,neuralnet(feedforwardnet(2,'trainlm')));
    %ff_17_lm = nlarx(training_data,orders,neuralnet(feedforwardnet(17,'trainlm')));
    %ff_18_lm = nlarx(training_data,orders,neuralnet(feedforwardnet(18,'trainlm')));
    %ff_19_lm = nlarx(training_data,orders,neuralnet(feedforwardnet(19,'trainlm')));
    %ff_2_br = nlarx(training_data,orders,neuralnet(feedforwardnet(2,'trainbr')));
    ff_2_rp = nlarx(training_data,orders,neuralnet(feedforwardnet(2,'trainrp')));
    %ff_2_scg = nlarx(training_data,orders,neuralnet(feedforwardnet(2,'trainscg')));
    %ff_2_cgb = nlarx(training_data,orders,neuralnet(feedforwardnet(2,'traincgb')));
    %ff_2_cgf = nlarx(training_data,orders,neuralnet(feedforwardnet(2,'traincgf')));
    %ff_2_cgp = nlarx(training_data,orders,neuralnet(feedforwardnet(2,'traincgp')));
    %ff_2_oss = nlarx(training_data,orders,neuralnet(feedforwardnet(2,'trainoss')));
    %ff_2_gdx = nlarx(training_data,orders,neuralnet(feedforwardnet(2,'traingdx')));
    %ff_2_gdm = nlarx(training_data,orders,neuralnet(feedforwardnet(2,'traingdm')));
    %ff_2_gd = nlarx(training_data,orders,neuralnet(feedforwardnet(2,'traingd')));
    
    %compare(test_data, ff_2_rp)
    %compare(test_data, ff_17_lm, froe_pem_8_reg, froe_sem_8_reg)

end