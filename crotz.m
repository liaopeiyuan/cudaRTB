function R = crotz(t, deg)
    %{
    if nargin > 1 && strcmp(deg, 'deg')
        t = t *pi/180;
    end
    
    ct = cos(t);
    st = sin(t);
    R = gpuArray([
        ct  -st  0
        st   ct  0
        0    0   1
        ]);
    %}
    if nargin > 1 && strcmp(deg, 'deg')
        t = pagefun(@times,t,pi/180);
    end
    t=t';
    ct = pagefun(@cos,t);
    st = pagefun(@sin,t);
    a = ones(size(t),'gpuArray');
    b = zeros(size(t),'gpuArray');
    f = cat(1,ct,-st,b);
    s = cat(1,st,ct,b);
    th = cat(1,b,b,a);
    R = cat(3,f,s,th);
    R = permute(R,[3 1 2]);