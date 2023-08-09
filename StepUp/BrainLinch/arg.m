function O = arg(I)

O = atan2(imag(I), real(I)) * 180 / pi;