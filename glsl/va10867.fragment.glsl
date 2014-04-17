#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const highp float PI = 3.14159265358979323846264;
const highp float PI_x_2 = 2.0 * PI;
const highp float InnerCircle = 0.75;
const highp float OuterCircle = 1.00;
const highp float AntiAliasingEdge = 0.02;

void main( void ) {

	vec2 coord = ( gl_FragCoord.xy / min(resolution.x, resolution.y) - vec2(0.5)) * 3.0;
	highp vec4 color = vec4(0.196, 0.666, 0.929, 1.0);
	highp float r = distance(coord, vec2(0.0));
    	highp float t = atan(coord.y, coord.x) + PI_x_2 * fract(time * 0.3);
	bool hit = InnerCircle <= r && r <= OuterCircle;
    	highp float st = sin(t);
    	if (!hit || st <= 0.0) {
		discard;
    	}

	
	highp float blend = (cos(t) + 1.0) / 2.0;
	blend *= smoothstep(InnerCircle, InnerCircle+ AntiAliasingEdge, r);
   	blend *= (1.0 - smoothstep(OuterCircle - AntiAliasingEdge, OuterCircle, r));
	
	gl_FragColor = color * blend;
}