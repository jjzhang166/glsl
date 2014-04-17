// @rotwang: @mod* color mixes, @mod- mouse 

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 c = vec2(0.5,0.5);

void main( void ) {

	
	vec2 p = ( gl_FragCoord.xy / resolution );
	
	float sint = sin(time*0.5);
	float cost = cos(time*0.5);
	
	vec3 rgb = vec3(sint);
	float d = sqrt((p.x-c.x)*(p.x-c.x)+(p.y-c.y)*(p.y-c.y));
	rgb = mix(rgb, vec3(abs(sin(d*sint*64.0))),0.5);
	rgb = mix(rgb,vec3(1.0,0.7,0.2),d*cost);
		
	rgb = mix( rgb, vec3( sin( d ) ), cost );
	gl_FragColor = vec4( rgb, 1.0 ); 

}