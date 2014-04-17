#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
//uniform vec3 otherFlare;

//MrOMGWTF

vec3 flare(vec2 spos, vec2 fpos, vec3 clr)
{
	vec3 color;
	float d = distance(spos, fpos);
	vec2 dd;
	dd.x = spos.x - fpos.x;
	dd.y = spos.y - fpos.y;
	dd = abs(dd);
	
	color = clr * max(0.0, 0.9 / dd.y) * max(00.0, 0.0701 -  dd.x)*0.077;
	color += clr * max(0.0, 0.05 / d) * 0.2;
	color += clr * max(0.0, 0.1 / distance(spos, -fpos)) * 0.01610 ;
	color += clr * max(0.0, 0.13 - distance(spos, -fpos * 1.5)) * 0.3 ;
	color += clr * max(0.0, 0.07 - distance(spos, -fpos * 0.4)) * 0.4 ;
	
	
	return color;
}

float noise(vec2 pos)
{
	return fract(1111. * sin(111. * dot(pos, vec2(2222., 22.))));	
}

void main( void ) {

	vec3 fin;
	vec2 position = ( gl_FragCoord.xy / resolution.xy * 2.0 ) - 1.0;
	position.x *= resolution.x / resolution.y;
	float omega = time*2.;//-(sin(time)/1.5);
	float divisor = 1.-.5*cos(omega);
	//vec3 color = flare(position, vec2(sin(omega)/2./divisor, cos(omega)/2./divisor) * 0.5 , vec3(0.5, 0.8, 0.5));
	vec3 color = flare(position, vec2((mouse.x-0.50) *4.0, (mouse.y-0.50) *2.0 ) , vec3(0.5, 0.8, 0.5));
	

	gl_FragColor = vec4( color  * (0.95 + noise(position*0.001 + 0.00001) * 0.05), 1.0 );

}