#ifdef GL_ES
precision highp float;
#endif
  uniform float scale;
void main(void) {
   float Cr = (gl_FragCoord.x - 300.) / scale + .407476;
   float Ci = (gl_FragCoord.y - 300.) / scale + .234204;
   float R = 0., I = 0.,  R2 = R*R, I2 = I*I;
   int mm;
   for(int m = 0; m < 255; m++){
     I=(R+R)*I+Ci;  R=R2-I2+Cr;  R2=R*R;  I2=I*I;    mm = m;
     if( R2 + I2 > 4. ) break;
   }
   if (mm == 254) gl_FragColor = vec4(0., 0., 0., 1.);
   else{
    float a = mod(float(mm), 60.) / 20.;
    gl_FragColor = vec4( max(0., abs(a - 1.5) - .5),
      max(0., 1. - abs(a - 1.)), max(0., 1. - abs(a - 2.)), 1.);
   }
}