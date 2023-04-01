function Ref_image = generate_ref_im (I_lrms, I_pan, paras)
% Created by Zhong-Cheng Wu (wuzhch97@163.com)
% Oct. 31, 2021
% Updated by 
% Apr. 01, 2023
%
sz = paras.sz;
ratio = paras.ratio;
Nways = paras.Nways;
sensor = paras.sensor;
P_highdim = hist_mapping(I_lrms, I_pan, ratio, sz/ratio);
%
Phigh_de = zeros(size(I_lrms));
for band = 1:Nways(3)
    temp_band = MTF_pan(P_highdim(:,:,band), sensor, ratio);
    Phigh_de(:,:,band) = imresize(temp_band, 1/ratio, 'nearest');
end
%
Mat_lrms = Unfold(I_lrms, Nways, 3);
Mat_pan = Unfold(Phigh_de, Nways, 3);
%
%----------||alpha*P - M||_{F}^{2}------------
Coeffs = Mat_lrms*Mat_pan'*pinv(Mat_pan*Mat_pan'); 
%
P_ref = Coeffs*Unfold(P_highdim, Nways, 3);
%
Ref_image = Fold(P_ref, Nways, 3);
%
end