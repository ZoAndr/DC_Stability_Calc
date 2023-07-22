clear all; close all; clc;

Vi  = 12;
Vo = 34;
Io = 1;

L = 1e-6;
C = 220e-6;


fs = 1e6;


R_DS = 0.1;
R_I_SEN = 0.02;
Vd = 0.75;
R_L = 0.05;
R_ESR = 0.1;

s = 0: 100: 1e7;


figure(1000)
subplot(211); semilogx(s, [s * inf]); hold on; grid on
subplot(212); semilogx(s, [s * inf]); hold on; grid on

N = 50;

D_log = zeros(N, 3);
Vi_log = zeros(N, 1);

for k = 1: N
    
    Vi = 8 + k * 0.5;
    Vi_log(k) = Vi;
    
    [Z_ON, Z_OFF, Z_L, Z_C, R_Load,  D_DCM_0, D_DCM, D_CCM_0, D_CCM, D_disch,   M_CCM, M_DCM  ] = ...
    Calc_Parameters(s, fs,   Vo, Vi,    C, L,    R_L, R_I_SEN, R_DS, R_ESR, Vd,   Io);

%     Io = .00001 + .2 * k;
%    [G, mode] = Calc_G_vc(Vi, Vo, Io,   fs,  L, C,     R_L, R_DS, R_ESR,    R_I_SEN,    Vd,   s );
% 

    [G, mode,  D1, D2, D3] = Calc_G_vd(D_DCM, D_disch, D_CCM,    s,   Vi, Vo,    fs,   M_DCM, M_CCM,   Z_ON, Z_OFF, Z_C, Z_L,    R_Load );

    D_log(k, :) = [D1, D2, D3];
    subplot(211); semilogx(s, 10 * log10(abs(G)));
% 
    subplot(212); semilogx(s, atan2(    imag(G),   real(G) * 180 / pi   ));
% 
 %   disp(Io);

end
hold off
hold off
%grid on

figure; plot(Vi_log, D_log)