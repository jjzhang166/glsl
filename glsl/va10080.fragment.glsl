#ifdef GL_ES
precision mediump float;
#endif
// incredible owl by Psychedelic Reseearch Corp.

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{vec2 i,p = abs(( gl_FragCoord.xy / resolution.xy  * 2.0) - 1.0);
float m;
i=-(vec2(tan(time*0.2),cos(time*0.4))*0.4+0.4);
	    for(int l = 0; l < 2; l++)
{
m=atan(dot(tan(p*p)*p,vec2(2,1)));			
p=sqrt((p/m)*vec2(1.2+atan(p.y+time*0.1)*1.8,1.1+sqrt(p.x+time*0.2)*0.3)+i);
}
vec3 col=vec3(m*0.25*tan(time*0.6),m*0.75*sin(time*0.4), m*tan(p.x) );
gl_FragColor = vec4( (col-normalize(col)*1.95)*4.0, 2.0 );
}