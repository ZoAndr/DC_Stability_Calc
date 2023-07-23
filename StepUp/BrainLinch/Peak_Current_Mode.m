function [G_id_CCM, T_I, G_vc] = Peak_Current_Mode(s, fs, R_Load, Io,   Z_C, Z_ON, Z_OFF,  A_CS,  R_I_SEN,  m_I_L_ON, M_CCM,    G_vd)


Ts = 1 / fs;

m_n = m_I_L_ON * R_I_SEN * A_CS;

F_m = 1 / (m_n * Ts);

G_id_CCM = 2 .* Io .* (M_CCM^2)   .*   ( 1 + R_Load ./ (2 .* Z_C) )   ./   (1 + (Z_ON .* (M_CCM^2)) ./ (Z_OFF));

H_e = 1; % Sampling gain;

T_I = F_m .* A_CS .* R_I_SEN .* G_id_CCM .* H_e;

t_delay_CompInp_to_Switch  = 1;  % exp(-j * s * td)

td = 1e-8;
t_delay_CompInp_to_Switch  =  exp(-j * s * td);

G_vc = F_m .* G_vd  ./ (1 + T_I) .* t_delay_CompInp_to_Switch;