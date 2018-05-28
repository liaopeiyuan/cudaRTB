h=21;
for i=1:h
    a=randn(2^i,3);i
    b=gpuArray(a);
    tic
    z=eul2r(a);
    t(i)=toc;
    
    tic
    z=ceul2r(b);
    g(i)=toc;
end
plot(1:h,t)
hold on
plot(1:h,g)
set(gca, 'YScale', 'log')