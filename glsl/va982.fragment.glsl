#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec2 R = resolution;
vec2 Offset;
vec2 Scale=vec2(0.005,0.001);
float Saturation = 10.8; // 0 - 1;


vec3 lungth(vec2 x,vec3 c){
       return vec3(length(x+c.r),length(x+c.g),length(x+c.b));
}

void main( void ) {
    Offset = mouse.xy;
    vec2 x = gl_FragCoord.xy;
    vec4 c=vec4(0,0,0,0);
    x=x*Scale*R/R.x+Offset;
    x+=cos(x.yx*sqrt(vec2(113,29)))/5.;
    x+=sin(x.yx*sqrt(vec2(173,523)))/5.;
    c.rgb=lungth(sin(time+x*sqrt(vec2(33.,23.))),c.rgb/2.);
    c=.5+.5*inversesqrt(c*8.);
    c.a=1.;
    gl_FragColor = 1./c;
}