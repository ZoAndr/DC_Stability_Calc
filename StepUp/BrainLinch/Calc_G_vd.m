function [G, mode,  D1, D2, D3] = Calc_G_vd(D_DCM, D_disch, D_CCM,    s,   Vi, Vo,    fs,   M_DCM, M_CCM,   Z_ON, Z_OFF, Z_C, Z_L,    R_Load )

if D_DCM + D_disch > 1
   D = D_CCM;
   [G] = calc_G_vd_CCM(s,   Vi, Vo,   D,   fs,   M_DCM, M_CCM,   Z_ON, Z_OFF, Z_C, Z_L,    R_Load);
   mode = 'CCM';
   
   D1 = D_CCM;
   D2 = 1 - D_CCM;
   D3 = 0;
else
   D = D_DCM;
   [G] = calc_G_vd_DCM(s,   Vi, Vo,   D,   fs,   M_DCM, M_CCM,   Z_ON, Z_OFF, Z_C, Z_L,    R_Load);
   mode = 'DCM';
   
   D1 = D_DCM;
   D2 = D_disch;
   D3 = 1 - D_DCM - D_disch;
end

