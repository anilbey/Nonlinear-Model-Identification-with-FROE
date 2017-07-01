function [narx_model] = froe(regressor_limit, threshold, focus)
 
    %default values for the parameters
    if nargin < 1
        regressor_limit = 8;
        threshold = 5e-08;
        focus = 'prediction';
    elseif nargin < 2
        threshold = 5e-08;
        focus = 'prediction';
    elseif nargin < 3
        focus = 'prediction;'
    end

    %reading the data
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
    maxPower = 3;
    allRegSys = idnlarx(orders, 'linear');
    allRegSys = addreg(allRegSys, polyreg(allRegSys, 'MaxPower', maxPower, 'CrossTerm', 'on')); 
    %getting the candidate regressors

    candidateRegs = getreg(allRegSys);
    number_rows = size(y1,1);

    %% Computation of the phi matrix
    num_candidates = size(candidateRegs, 1);
    phi = zeros(number_rows, num_candidates);
    for t = 1:number_rows 
        for i = 1:num_candidates
            try
                phi(t,i) = eval(strjoin(candidateRegs(i)));
            catch
                phi(t,i) = 0;
            end
        end
    end

    phi = phi(4:number_rows,:);
    y1 = y1(4:number_rows);
    number_rows = size(phi,1);
    %empty model
    w = [];
    a(1,1) = 1;
    %try all columns of phi 
    %calculate err for-each column in phi
    
    
    err_values = [];
    used_reg_ind = [];
    max_err_values = [];
    for c = 1:num_candidates % for all candidate regressors
        w_candidate = phi(:,c);
        nominator = 0;
        w_square = 0;
        y1_square = 0;
        for r = 1:number_rows
            nominator = nominator + w_candidate(r)*y1(r);
            w_square = w_square + w_candidate(r)*w_candidate(r);
            y1_square = y1_square + y1(r)*y1(r);
        end
        g = nominator / w_square;

        err_values(c) = g*g*w_square/y1_square; %select and fix the max then remove it from the regressors
    end

    [max_err, max_err_index] = max(err_values);
    w(:,1) = phi(:,max_err_index);
    used_reg_ind(end + 1) = max_err_index;
    max_err_values(end + 1) = max_err;

    %we've got the 1st regressor


    %err_values
    for w_index = 2:regressor_limit %for each new regressor
        g2 = 0;
        g2_err = 0;
        a(w_index,w_index) = 1;
        for k = 1:num_candidates %try all possible candidates

            if ismember(k,used_reg_ind)
                continue;
            else
                for i = 1:w_index-1   %computation of past a() values
                    nominator = 0;
                    denominator = 0;
                    for t = 1:number_rows 
                        nominator = nominator + w(t,i)*phi(t,k);
                        denominator = denominator + w(t,i)*w(t,i);
                    end
                    a(i,w_index) = nominator / denominator;
                end 
                subs_val = 0;
                for j = 1:w_index-1
                    subs_val = subs_val + a(j,w_index) * w(:,j);
                end
                w_2(:,k) = phi(:,k) - subs_val; 
                
                g2_nom = 0;
                g2_denom = 0;
                y1_square = 0;
                for t = 1:number_rows
                    g2_nom = g2_nom + w_2(t,k)*y1(t);
                    g2_denom = g2_denom + w_2(t,k)*w_2(t,k);
                    y1_square = y1_square + y1(t)*y1(t);
                end
                g2(k) = g2_nom / g2_denom;

                g2_err(k) = g2(k)*g2(k)*g2_denom/y1_square;

             
            end
        end
        
        [max_err, max_err_index] = max(g2_err);
        
        if max_err > threshold
            w(:,w_index) = w_2(:,max_err_index);
            used_reg_ind(end + 1) = max_err_index;
            max_err_values(end + 1) = max_err;
        else
            continue;
        end
    end

    na = 1;
    nb = [1 1];
    nk = [0 0];
    empty_orders = [na nb nk];
    system = idnlarx(empty_orders,[]); 
    

    for ind = used_reg_ind
       system = addreg(system,candidateRegs(ind));     
    end 

    system2 = idnlarx (empty_orders, 'linear');
    getreg(system)
    
    opt = nlarxOptions('Focus', focus, 'Display', 'on'); %either prediction or simulation
    %estimating the parameters
    narx_model = nlarx(training_data, system, opt)



end