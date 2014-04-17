#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec3 color;
	color += mix(vec3(1.0, 0.0, 0.0), vec3(0.0, 0.0, 1.0), position.x)* clamp(sin(time),0.1,1.0);
	color += mix(vec3(1.0, 1.0, 0.0), vec3(0.0, 1.0, 0.0), position.y)* 0.0;
	
	for(int a = 0; a <4; a++)
	{
		float asFloat = float(a);
	color += (1.0 / distance(position, vec2(0.5+sin(time)*0.5*asFloat*0.2, sin(asFloat*3.0)*0.5)))*0.05;
	color += (1.0 / distance(position, vec2(0.5+sin(time)*asFloat*cos(time)*0.4999*sin(time), cos(asFloat))))*0.03;
		color*=0.9;
	}
		
	gl_FragColor = vec4(color,1.0);

}