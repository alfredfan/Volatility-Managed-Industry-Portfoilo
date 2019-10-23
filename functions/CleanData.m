function port = CleanData(port)
[T,N] = size(port);
index = find(port==-99.99);
port = reshape(port,T*N,1);
port(index) = nan;
port = reshape(port,T,N);
end