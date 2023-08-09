function [G_id_CCM, T_I, G_vc] = Peak_Current_Mode(s, fs, R_Load, Io,   Z_C, Z_ON, Z_OFF,  A_CS,  R_I_SEN,  m_I_L_ON, M_CCM,    G_vd)


Ts = 1 / fs;

m_n = m_I_L_ON * R_I_SEN * A_CS;

F_m = 1 / (m_n * Ts);

G_id_CCM = 2 .* Io .* (M_CCM^2)   .*   ( 1 + R_Load ./ (2 .* Z_C) )   ./   (1 + (Z_ON .* (M_CCM^2)) ./ (Z_OFF));

% Sampling gain;
% ==============================================
% Calculated following 
% Research Article
% Control Design and Loop Gain Analysis of DC-to-DC Converters Intended for General Load Subsystems
% Syam Kumar Pidaparthy and Byungcho Choi
% http://smpc.knu.ac.kr/publications/2015_Control%20Design%20and%20Loop%20Gain%20Analysis%20of%20DC-to-DC%20Converters%20Intended%20for%20General%20Load%20Subsystems.pdf

Qz = -2/pi;
wn = pi*fs;
H_e = 1    +     s ./ (wn * Qz) + s.^2 / wn^2;
%figure(343); subplot(211); semilogx(Xlog10(H_e)); subplot(212); semilogx(ang(H_e));
% ==============================================

T_I = F_m .* A_CS .* R_I_SEN .* G_id_CCM .* H_e;

t_delay_CompInp_to_Switch  = 1;  % exp(-j * s * td)


% Influence of delay time from the
% PWM comparator input to the transition of
% the converter switch node [Bryan Linch]
td = 1e-8;
t_delay_CompInp_to_Switch  =  exp(-s/2/pi * td);

G_vc = F_m .* G_vd  ./ (1 + T_I) .* t_delay_CompInp_to_Switch;