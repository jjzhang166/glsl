#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float addLight( vec2 _pos, vec2 light_pos, vec3 color)
{
	float tmp = 0.0;
	tmp = pow(length(distance(_pos,light_pos)), 0.5);
	return tmp;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;

	float rgb = 0.0;
	rgb += addLight( position, vec2(0.5,0.5), vec3(1.0, 0.0, 0.0));
	rgb += addLight (position,vec2(0.5,0.5)+vec2(0.1,cos(time*0.2)*0.2),vec3(0.0));
	rgb += addLight (position,vec2(0.5,0.5)+vec2(0.05,cos(time*0.2)*0.2),vec3(0.0));
	rgb += addLight (position,vec2(0.5,0.5)+vec2(-0.05,cos(time*0.2)*0.2),vec3(0.0));
	
	
	gl_FragColor = pow(rgb,20.0) * vec4(0.2,0.2,0.5,1.0);

}