#ifdef GL_ES
precision mediump float;
#endif

// Posted by Trisomie21

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

void main( void ) {

	float radius = resolution.y*.4;
	vec2 pos = (gl_FragCoord.xy - resolution.xy*.5);
	
	// Distance
	float d = length(pos);
	
	// Angle
	float angle = (atan(pos.y, pos.x) + time) / (3.141592*2.0);
	
	// Color
	vec3 c = vec3(angle);
	
	// Rotate GB
	c = fract(c + vec3(0.0, 1.0/3.0, 2.0/3.0));
	c = abs(c*2.0-1.0);
		
	// Scale RGB
	c = clamp(c*3.0-1.0, 0.0, 1.0);
	
	// Luma
	c = mix(vec3(1), c, d/radius);
	
	// Edge
	float x = d - (radius-1.0);
	c *= clamp(1.0-x, 0.0, 1.0);
	
	gl_FragColor = vec4(c,1.0);
}