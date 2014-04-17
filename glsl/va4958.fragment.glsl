#ifdef GL_ES
precision highp float;
#endif
//3pxFun ;)
uniform float time;
uniform vec2 resolution;
uniform vec4 mouse;

void main(void)
{

vec2 pos = -0.5+( gl_FragCoord.xy / resolution.xy );


float a=-4.5*pos.x+sin(time);
a=sqrt(a); //to V. shake it
float b=-6.5*pos.y+cos(time);
b=sqrt(b);

    vec3 col = vec3(a,b*a,sin(time)*cos(cos(time)));

    gl_FragColor = vec4(col/0.6+sin(2.0*time),1.0);
}