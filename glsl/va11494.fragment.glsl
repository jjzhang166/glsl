#ifdef GL_ES
precision mediump float;
#endif

const highp float PI = 3.14159265358979323846264;
const highp float PI_x_2 = 2.0 * PI;

const highp float InnerCircle = 0.75;
const highp float OuterCircle = 1.0;
const highp float AntiAliasingEdge = 0.01;

uniform float time;
uniform vec2 resolution;

void main( void ) {

	vec2 coord = ( gl_FragCoord.xy / min(resolution.x, resolution.y) - vec2(0.5)) * 3.0;
	highp vec4 color = vec4(0.196, 0.666, 0.929, 1.0);
	highp float r = distance(coord, vec2(0.0));
    	highp float t = atan(coord.y, coord.x);
    	bool hit = InnerCircle <= r && r <= OuterCircle;
    	highp float clockAngle = PI / 2.0 - t;
	
    	if (clockAngle < 0.0) {
       		clockAngle = clockAngle + PI * 2.0;
    	}
    
	highp float phase = PI_x_2 * fract(time * -0.3);
    	if (!hit || clockAngle > phase) {
        	discard;
    	}
	
	highp float blend = smoothstep(InnerCircle, InnerCircle+ AntiAliasingEdge, r);
   	blend *= (1.0 - smoothstep(OuterCircle - AntiAliasingEdge, OuterCircle, r));
	
	gl_FragColor = color * blend;
}