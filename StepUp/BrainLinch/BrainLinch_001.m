clear all; close all; clc;

Vi  = 12;
Vo = 24;
Io = 1;

L = 22e-6;
C = 10e-6;


fs = 1e6;


R_DS = 0.07;
R_I_SEN = 0.05;
Vd = 0.5;
R_L = 0.01;
R_ESR = 0.14;

s = 10: 10: 1e6;



A_CS = 6;



figure(1000)
subplot(211); semilogx(s, [s * inf]); hold on; grid on
subplot(212); semilogx(s, [s * inf]); hold on; grid on

Init_LOGs

for k = 1: 1% N
    
  %  Vi = 8 + k * 0.5;
    Vi_log(k) = Vi;
    
    [Z_ON, Z_OFF, Z_L, Z_C, R_Load,  D_DCM_0, D_DCM, D_CCM_0, D_CCM, D_disch,   M_CCM, M_DCM,   m_i_ON, m_i_OFF] = ...
    Calc_Parameters(s, fs,   Vo, Vi,    C, L,    R_L, R_I_SEN, R_DS, R_ESR, Vd,   Io);


    [G_vd, mode,  D1, D2, D3] = Calc_G_vd(D_DCM, D_disch, D_CCM,    s,   Vi, Vo,    fs,   M_DCM, M_CCM,   Z_ON, Z_OFF, Z_C, Z_L,    R_Load );

    [G_id_CCM, T_I, G_vc] = Peak_Current_Mode(s, fs, R_Load, Io,  Z_C, Z_ON, Z_OFF,  A_CS,  R_I_SEN,  m_i_ON, M_CCM,    G_vd);
    
    D_log(k, :) = [D1, D2, D3];
    
%     subplot(211); semilogx(s, 10 * log10(abs(G_vd))); 
%     subplot(212); semilogx(s, atan2(    imag(G_vd),   real(G_vd)) * 180 / pi   );
    
    subplot(211); semilogx(s, 10 * log10(abs(G_vc))); ylim([-30, 50]);
    subplot(212); semilogx(s, atan2(    imag(G_vc),   real(G_vc)) * 180 / pi   ); ylim([-180, 180]);

    disp(mode)
    
end
hold off
hold off
%grid on

return

figure; plot(Vi_log, D_log)