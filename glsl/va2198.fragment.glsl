#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//just testing and learning :)

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	float depth = gl_FragCoord.z;

	float color = 0.5;
	
	//color += mod(time, 0.1);
	//color += dot(position.x, position.y)*depth;
	
	color *= abs(mod(position.x*5.0*sin(position.x)*position.y+cos(time), position.x*5.0*cos(position.x)*position.x+sin(time)));
	color *= abs(mod(position.y*5.0*cos(position.y)*position.x+sin(time), position.y*5.0*sin(position.y)*position.y+cos(time)));
	
	gl_FragColor = vec4(color*0.2, color*0.1, color, 1.0 );
}