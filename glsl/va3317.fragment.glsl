// @rotwang: @mod+ horizontal alternating gradient

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
//uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{
	vec2 pos=gl_FragCoord.xy/resolution;
	
	float sint = sin(time);
	float usint = sint*0.5+0.5;
	vec3 clr_a = vec3(usint);
	vec3 clr_b = vec3(1.0-usint);
	
	float d = pos.x;
	vec3 rgb = mix(clr_a, clr_b, d);
	gl_FragColor = vec4( rgb, 1.0 );

}