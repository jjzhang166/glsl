#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

void main(void)
{
   float x = gl_FragCoord.x;
   float y = gl_FragCoord.y;
   float mov0 = x+y+cos(sin(time)*5.)*125.+sin(x/75.)*125.;
   float mov1 = y / resolution.y / 6.6 + time;
   float mov2 = x / resolution.x / 6.6;
   float c1 = abs(sin(mov1+time)/1000.+mov2/8.-mov1-mov2+time);
   float c2 = abs(sin(c1+sin(mov0/200.+time)+sin(y/40.+time)+sin((x+y)/600.)*9.));
   float c3 = abs(sin(c2+cos(mov1+mov2+c2)+cos(mov2)+sin(x/900.)));
   gl_FragColor = vec4( c1,c2,c3,2.5);
}