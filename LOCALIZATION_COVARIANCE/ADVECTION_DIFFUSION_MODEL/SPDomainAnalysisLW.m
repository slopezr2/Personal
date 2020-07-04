function XAnew = SPDomainAnalysisLW(xb,ys, h, domainIndxR, domainIndx ,N, i, XAold, gridsize, R, pfactor)
    XAnew = XAold;
    n = numel(domainIndxR{i});
    Htemp = zeros(gridsize,1);
    Htemp(h) = 1;
    Hs = Htemp(domainIndxR{i});
    H = find(Hs);
    m = numel(H); 
    if (m>0)
        XB = zeros(n,N);
        Ys = zeros( m,N);  
        for k = 1:N
           XB(:,k) = xb(domainIndxR{i},k); 
           temp = ys(domainIndxR{i},k); 
           Ys(:,k) = temp(H);
        end

      %%%%%%%%%%%%%%%%%%%%%%%%%%%
       %%%%%% SHRINKAGE EnKF %%%%%
       %%%%%%%%%%%%%%%%%%%%%%%%%%% 
       xmb = mean(XB,2);
       XBp=xmb*ones(1,N)+ pfactor*(XB-xmb*ones(1,N));
       xmbp = mean(XBp,2);
       sb =XBp-xmbp*ones(1,N);

       %%%%%%%%%%%%%%%%%%%%%%%%%%%
       %%% LW%%
       %%%%%%%%%%%%%%%%%%%%%%%%%%%       
        DX = (1/sqrt(N-1))*sb;
        Pb=DX*DX'; 
        [~,S,~] = svd(DX,0); 
        S=diag(S).^2;
        S2=sum(S.^2);
        S=sum(S);
        u = S/n; 
        suma=0;
        for k=1:N 
            suma=suma + norm(sb(:,k)).^4;
        end
        l = min((suma-(N-2)*S2)/((S2-(S^2)/n)*N^2),1);
        dl= 1-l;
        phi=l*u;


        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%% Analysis Step  %%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        B = phi*eye(n,n) +  dl*Pb; 
        D = Ys-XB(H,:);
        W = R.*eye(m,m) + B(H,H); 
        xa = XB + B(:,H)*(W\D); 

        %%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%% Real data %%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%
         for k = 1:N
           XAold(domainIndxR{i},k) = xa(:,k); 
           XAnew(domainIndx{i},k) = XAold(domainIndx{i},k); 
         end 
    end
end