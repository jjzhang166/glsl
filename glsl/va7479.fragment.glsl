#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
float Lmin = 0.0, Lmax = 49.3;
float gamma = 2.5;

vec3 lum2image(in float im, in float c) {
    vec3 vout;
    float BTRR = 63.2;
    float U = 255.0*pow((c*im-Lmin)/(Lmax-Lmin),1.0/gamma);
    float b1 = (BTRR+1.0)/BTRR;
    float b = min(floor(U*b1),255.0);
    float b2 = floor((U-b/b1)*(BTRR+1.0));
    vout = vec3(b2/255.0, 0 ,b/255.0);
    return (vout);
}

void main( void ) {    
    float x = gl_FragCoord.x/resolution.x - 0.5;
    float y = gl_FragCoord.y/resolution.y - 0.5;
    float m = exp(-0.5*(x*x + y*y)/pow(0.2,2.0));

    gl_FragColor.rgb = vec3( (1.0 + m*cos(100.0*x - 10.0*time))/2.0 );
}