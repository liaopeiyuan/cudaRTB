h=1:5000:200001;
for i=1:5000:200001
    ct1=1;
    ct2=1;
    
    a=randn(i,3);
    b=gpuArray(a);
    tic
    z=eul2r(a);
    t(ct1)=toc;
    ct1=ct1+1;
    
    tic
    z=ceul2r(b);
    g(ct2)=toc;
    ct2=ct2+1;
    
end
plot(h,t)
hold on
plot(h,g)
set(gca, 'YScale', 'log')