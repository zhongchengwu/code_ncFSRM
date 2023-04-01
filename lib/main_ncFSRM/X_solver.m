function X_out = X_solver(U, V, Xlast, Theta, par, paras)
%
eta = paras.eta;
rho = paras.rho;
Nways = paras.Nways;
Theta_1 = Theta{1};
Theta_2 = Theta{2};
X_out = zeros(Nways);
for band = 1:Nways(3)
FFT_molecular = (eta{1}*fft2(U(:,:,band))-fft2(Theta_1(:,:,band))).*par.fft_BT(:,:,band) +...
                            eta{2}*fft2(V(:,:,band)) - fft2(Theta_2(:,:,band)) + rho*fft2(Xlast(:,:,band));
FFT_denominator = eta{1}*par.fft_B(:,:,band).*par.fft_BT(:,:,band) + (eta{2}+rho);
X_out(:,:,band) = real(ifft2(FFT_molecular ./ FFT_denominator));
end
%
% Control the image domain
X_out(X_out>1)=1;
X_out(X_out<0)=0;
%
end 