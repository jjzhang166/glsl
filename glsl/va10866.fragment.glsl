#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const highp float PI = 3.14159265358979323846264;
const highp float PI_x_2 = 2.0 * PI;
const highp float PI_2 = PI / 2.0;
const highp float PI_4 = PI / 4.0;
const highp float PI_8 = PI / 8.0;

const highp float r0 = 0.75;
const highp float r1 = 0.2;
const highp float offset = 0.0;

void main( void ) {
	vec2 c = ( gl_FragCoord.xy / min(resolution.x, resolution.y) - vec2(0.5)) * 3.0;
	highp vec4 color = vec4(0.196, 0.666, 0.929, 1.0);
	highp float r = distance(c, vec2(0.0));
    	highp float t = atan(c.y, c.x);

	highp vec2 p0 = vec2(cos(offset + 0.0),           sin(offset + 0.0))          * r0;
    	highp vec2 p1 = vec2(cos(offset + PI_4),          sin(offset + PI_4))         * r0;
    	highp vec2 p2 = vec2(cos(offset + PI_2),          sin(offset + PI_2))         * r0;
    	highp vec2 p3 = vec2(cos(offset + PI_4 + PI_2),   sin(offset + PI_4 + PI_2))  * r0;
	
	highp vec4 d1 = vec4(distance(p0, c), distance(p1, c), distance(p2, c), distance(p3, c));
    	highp vec4 d2 = vec4(distance(-p0, c), distance(-p1, c), distance(-p2, c), distance(-p3, c));
    	highp vec4 d = min(d1, d2);
    	highp float dist = min(min(d[0], d[1]), min(d[2], d[3]));
    	if (dist > r1) {
        	discard;
    	}
	
	highp float phase = PI_x_2 * fract(time * 0.8);
	highp float angle = atan(c.y, c.x);
    	angle = floor((PI_8 + PI_x_2 - angle) / PI_4) * PI_4;
    	highp float blend = fract((angle - phase) / PI_x_2);
	blend = blend * (1.0 - smoothstep(r1 - 0.01, r1, dist));
	
	gl_FragColor = color * blend;
}