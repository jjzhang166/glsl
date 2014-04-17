//If you confess with your mouth, "Jesus is Lord," and believe in your heart that God raised him from the dead, you will be saved. Romans 10:9

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float circle(in vec2 uv, in vec2 center, float radius) {
	float xs = (uv.x - center.x) * (uv.x - center.x);
	float ys = (uv.y - center.y) * (uv.y - center.y);
	
	return sqrt(xs + ys) / radius;
}

void main( void ) {
	vec2 uv = gl_FragCoord.xy / resolution.x;
	vec2 mouseuv = uv.xy / mouse.xy;
	
	float circle = circle(uv, mouseuv, 0.1);
	
	vec3 color = vec3(ceil(1.0 - circle));
	
	gl_FragColor = vec4(color, 1.0);

}