#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {
	vec3 point = vec3(0.5 + sin(time) * 0.3,
			  0.5 + cos(time) * 0.3,
			  .0);
	
	
	vec2 q = gl_FragCoord.xy / resolution.xy;
	vec2 m = mouse;
	
	float dist = distance( vec3(q.x,q.y,0), point);
	
	vec3 c = vec3(dist*dist*13370.0 * sin(time));
	
	c +=vec3(rand(q));
	c.r = 1.0 - abs(sin(time));
	
	gl_FragColor = vec4(c, 1.0);
}