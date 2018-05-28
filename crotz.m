function R = crotz(t, deg)
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