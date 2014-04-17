// @rotwang, some clean color gradients

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{
	float aspect = resolution.x /resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
	vec2 pos = unipos*2.0-1.0;
	pos.x *=aspect;
	float len = length(pos);
	float invlen = 1.0-len;
	
	float sint = sin(time);
	float usint = sint*0.5+0.5;
	float cost = cos(time);
	float ucost = cost*0.5+0.5;

	float atant_len = atan( fract(time), len);

	
	vec3 clr_a = vec3(1.0,1.0,0.0);
	vec3 clr_b = vec3(1.0,0.0,0.0);
	vec3 clr_c = vec3(0.0,1.0,0.0);
	vec3 clr_d = vec3(0.0,0.0,1.0);
	
	vec3 clr_ab = mix(clr_a, clr_b, unipos.x);
	vec3 clr_cd = mix(clr_c, clr_d, unipos.y);
	
	vec3 clr_e = mix(clr_ab, clr_cd, invlen *  usint );
	vec3 clr_f = mix(clr_ab, clr_cd, len *  ucost );
	vec3 clr = mix(clr_e, clr_f,  fract(invlen) * sint+atant_len );
	
	gl_FragColor = vec4(clr, 1.0);

}