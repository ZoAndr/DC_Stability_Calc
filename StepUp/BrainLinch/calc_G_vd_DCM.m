function [G_vd_DCM] = calc_G_vd_DCM(s,   Vi, Vo,   D,   fs,   M_DCM, M_CCM,   Z_ON, Z_OFF, Z_C, Z_L,    R_Load)

G_vd_DCM = 2 * (Vo / D) * (M_DCM - 1) ./ (2 * M_DCM - 1) .* (1 - s * D ./ (2 * fs)) ./ (1 + (M_DCM - 1) * R_Load ./ ((2 * M_DCM - 1) .* Z_C));
