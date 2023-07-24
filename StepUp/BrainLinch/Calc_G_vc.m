function [G, mode] = Calc_G_vc(Vi, Vo, Io,   fs,   L, C,   R_L, R_DS, R_ESR,    R_I_SEN,    Vd,    s )

Ts = 1 / fs;

R_tot = R_L + R_I_SEN + R_DS;

R_Load = Vo / Io;

D_CCM_0 = 1 - Vi / Vo;
D_CCM  = 1    -    (Vi + Io * ( R_tot) + ...
                             (  (Vi + Io * (R_tot))^2  -  4 * Io * (R_tot) * (Vo + Vd))^0.5 ) ...
                             /  (2 * (Vo + Vd));

D = D_CCM_0;

m_i_ON = Vi / L;
m_i_OFF = (Vo - Vi) / L;

t_fall = m_i_ON / (-m_i_OFF) * D * Ts;
D_disch = t_fall / Ts;

D_DCM_0 = (1 / Vi) * (2 * L * (Vo - Vi) / Ts * Io)^0.5;
D_DCM = (1 / (Vi - (Vo - Vi) * Io / Vi * R_tot)) * (2 * L * (Vo - Vi + Vd) / Ts * Io)^0.5;

L_th = Vi * Ts / (2 * Io) * D_CCM * (1 - D_CCM);


%


Z_L = i * 2 * pi * s * L;
Z_ON = Z_L * R_DS + R_I_SEN + R_L;
Z_C = - i * 1 ./ (2 * pi * s * C) + R_ESR;
Z_OFF = Z_C * R_Load ./ (Z_C + R_Load);

M_CCM = Vo / Vi;

G_vd_CCM = Vi * M_CCM^2 .* (1 - (Z_ON * M_CCM^2 / R_Load)) ./ (1 + (Z_ON .* M_CCM^2 ./ Z_OFF));

D = D_DCM_0;
M_DCM = (1 + (2 * (Vo + Vd) * D^2 * Ts) / (Io * L)  )  / 2;
G_vd_DCM = 2 * (Vo / D) * (M_DCM - 1) ./ (2 * M_DCM - 1) .* (1 - s * D ./ (2 * fs)) ./ (1 + (M_DCM - 1) * R_Load ./ ((2 * M_DCM - 1) .* Z_C));

if D_DCM < 1
   G = G_vd_CCM;
   mode = 'CCM'
else
   G = G_vd_DCM;
   mode = 'DCM'
end