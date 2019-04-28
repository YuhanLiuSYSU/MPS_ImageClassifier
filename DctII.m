function [f,COSx,COSy]=DctII(M)
[Nx,Ny]=size(M);

COSx=cos(((0:Nx-1).'+0.5)*pi/Nx*(0:Nx-1))*sqrt(2/Nx);
COSy=cos(((0:Ny-1).'+0.5)*pi/Ny*(0:Ny-1))*sqrt(2/Ny);

COSx(:,1)=COSx(:,1)/sqrt(2);
COSy(:,1)=COSy(:,1)/sqrt(2);

f=COSx.'*M*COSy;
end