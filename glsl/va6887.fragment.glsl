#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec3 texture(vec2 p)
{
		vec3 col=vec3(0.);
	float nt=time*.1;
	
	for (int a=0;a<10;a++)
		{
		float ang=(float(a)+1.)+nt*float(a)*0.51;
		vec2 tp=vec2(p.x*cos(ang)+p.y*sin(ang),-p.y*cos(ang)+p.x*sin(ang));
		float oc=.015+tp.x*tp.y;
		col.x+=(10./(oc*oc*20.*oc))*(-0.01*length(tp));
		col.y+=(3.5/(oc*oc+oc))*(-0.01*length(tp));
		}
	col.z=0.-col.y;
return col;
}
void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy )-0.5;
	float l = length(p)  * mouse.x * 2.0;
	p *= 1.0 + sin(l*l * 40.0 - time * 8.0 * mouse.y) * 0.2 * (1.0 - l);
	vec3 col=texture(mod(p*7.+1.,2.)-1.);	
	gl_FragColor = vec4( col, 1.0 );
	
}