function[Z_ON, Z_OFF, Z_L, Z_C, R_Load,   D_DCM_0, D_DCM, D_CCM_0, D_CCM, D_disch,   M_CCM, M_DCM,  m_i_ON, m_i_OFF, Ts] = ...
    Calc_Parameters(s, fs,    Vo, Vi,    C, L,    R_L, R_I_SEN, R_DS, R_ESR, Vd,   Io)

R_Load = Vo / Io;


Z_L = s * L;
Z_ON = Z_L + R_DS + R_I_SEN + R_L;
Z_C =  1 ./ (s * C) + R_ESR;
Z_OFF = (Z_C .* R_Load) ./ (Z_C + R_Load);



Ts = 1 / fs;
R_tot = R_L + R_I_SEN + R_DS;


D_CCM_0 = 1 - Vi / Vo;
D_CCM  = 1    -    (Vi + Io * ( R_DS + R_I_SEN) + ...
                             (  (Vi + Io * (R_DS + R_I_SEN))^2  -  4 * Io * (R_DS + R_I_SEN) * (Vo + Vd))^0.5 ) ...
                             /  (2 * (Vo + Vd));


D_DCM_0 = (1 /  Vi                               ) * (2 * L * (Vo - Vi     ) / Ts * Io)^0.5;
D_DCM   = (1 / (Vi - (Vo - Vi) * Io / Vi * R_tot)) * (2 * L * (Vo - Vi + Vd) / Ts * Io)^0.5;


M_CCM = 1 / (1 - D_CCM); %Vo / Vi;

D = D_DCM;
M_DCM =  (1    +    (1 + (2 * (Vo + Vd) * D^2 * Ts) / (Io * L)  )^0.5    )  / 2;


m_i_ON = Vi / L;
m_i_OFF = (Vi - Vo) / L;

t_fall = m_i_ON / (-m_i_OFF) * D * Ts;
D_disch = t_fall / Ts;




