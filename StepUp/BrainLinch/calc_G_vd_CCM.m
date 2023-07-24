function [G_vd_CCM] = calc_G_vd_CCM(s,   Vi, Vo,   D,   fs,   M_DCM, M_CCM,   Z_ON, Z_OFF, Z_C, Z_L,    R_Load)

G_vd_CCM = Vi / 0.7 * M_CCM^2 .* (1 - (Z_ON * M_CCM^2 / R_Load)) ./ (1 + (Z_ON .* M_CCM^2 ./ Z_OFF));
