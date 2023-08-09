clear all; close all; clc;

Vi_  = [9, 12, 18];
Vo = 24;
Io = 1;

L = 1e-6;
C = 100e-6;


fs = .7e6;


R_DS = 0.07;
R_I_SEN = 0.017;
Vd = 0.75;
R_L = 0.008;
R_ESR = 0.14;

f = 10: 10: 1e7;

s = 2 * pi * 1i * f;

A_CS = 6;



figure(1000)
subplot(211); semilogx(f, [f * inf]); hold on; grid on
subplot(212); semilogx(f, [f * inf]); hold on; grid on

figure(1001)
subplot(211); semilogx(f, [f * inf]); hold on; grid on
subplot(212); semilogx(f, [f * inf]); hold on; grid on

Init_LOGs

for k = 1: 3% N
    
  %  Vi = 8 + k * 0.5;
    Vi = Vi_(k);
    Vi_log(k) = Vi_(k);
    
    [Z_ON, Z_OFF, Z_L, Z_C, R_Load,  D_DCM_0, D_DCM, D_CCM_0, D_CCM, D_disch,   M_CCM, M_DCM,   m_i_ON, m_i_OFF, Ts] = ...
    Calc_Parameters(s, fs,   Vo, Vi,    C, L,    R_L, R_I_SEN, R_DS, R_ESR, Vd,   Io);


    [G_vd, mode,  D1, D2, D3] = Calc_G_vd(D_DCM, D_disch, D_CCM,    s,   Vi, Vo,    fs,   M_DCM, M_CCM,   Z_ON, Z_OFF, Z_C, Z_L,    R_Load );

    [G_id_CCM, T_I, G_vc] = Peak_Current_Mode(s, fs, R_Load, Io,  Z_C, Z_ON, Z_OFF,  A_CS,  R_I_SEN,  m_i_ON, M_CCM,    G_vd);
    
    m_IL_ON = Vi / L;
    m_n = m_IL_ON * R_I_SEN * A_CS;
    V_ramp = 0.62;
    m_a = V_ramp / (Ts * D_CCM);
    Fm = 1 / (m_n * Ts);
    
    %V_DS = 0.001;
    %D_I = (Vi - (V_DS + R_I_SEN * I_L)) / L * D1;
    % https://www.ti.com.cn/cn/lit/an/slva061/slva061.pdf
    I_Peak = Vi / L * D1 * Ts
    
%    G_vc = Fm * G_vd;
    
    D_log(k, :) = [D1, D2, D3];
    
     figure(1000); subplot(211); semilogx(f, 20 * log10(abs(G_vd))); 
     figure(1000); subplot(212); semilogx(f, atan2(    imag(G_vd),   real(G_vd)) * 180 / pi   );
        
     figure(1001); subplot(211); semilogx(f, 20 * log10(abs(G_vc))); 
     figure(1001); subplot(212); semilogx(f, atan2(    imag(G_vc),   real(G_vc)) * 180 / pi   );
        
%    subplot(211); semilogx(s, 10 * log10(abs(G_vc))); ylim([-30, 50]);
%    subplot(212); semilogx(s, atan2(    imag(G_vc),   real(G_vc)) * 180 / pi   ); ylim([-180, 180]);

    disp(mode)
    
end
hold off
hold off
%grid on

return

figure; plot(Vi_log, D_log)