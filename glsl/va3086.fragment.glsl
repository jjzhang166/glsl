#ifdef GL_ES
precision mediump float;
#endif

//#define MOUSE

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {
	vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	
	#ifdef MOUSE
	pos.x -= mouse.x;
	pos.y -= mouse.y;
	#else
	pos.x -= 0.5;
	pos.y -= 0.5;
	#endif
	
	float aspect = resolution.x / resolution.y;
	pos.x *= aspect;
	
	vec3 bg = vec3(0.0, 0.0, 0.0);
	vec3 color = bg;
	
	float radius = 0.2;
	float dist = sqrt(dot(pos, pos));
	float angle = atan(pos.y, pos.x);
	
	float f;
	if(dist < radius) {
		color = vec3(1.0, 0.0, 0.0);
		
		f = smoothstep(0.22, 0.10, dist );
		color *= f;
	}
	
	gl_FragColor = vec4( color + bg, 1.0);

}