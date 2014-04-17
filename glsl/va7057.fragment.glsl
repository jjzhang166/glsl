#ifdef GL_ES
precision mediump float;
#endif

// dashxdr was here 20120228

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( 2.0*gl_FragCoord.xy - resolution) / resolution.xx;

	vec3 color = vec3(0.0);

	float time2 = .2*time;
	float time3 = .1*time;
	float time4 = .15*time;
	float time5 = .2*time;
	float speed1 = .2 * time2;
	float range1 = .3;
	float ripple1 = 10.0 + 5.0 * sin(time2);
	float speed2 = -.3 * time2;
	float range2 = .5;
	float ripple2 = 15.0 + 10.0 * sin(time2+3.0);
	float speed3 = -.3 * time2;
	float ripple3 = 5.0 + 4.0 * sin(time2*2.0+2.0);
	float range3 = .3 + .0*ripple3;
	vec2 p1 = vec2(0.0, 0.0) + vec2(range1*cos(speed1), range1*sin(speed1));
	vec2 p2 = vec2(0.2, 0.0) + vec2(range2*cos(speed2), range2*sin(speed2));
	vec2 p3 = vec2(0.0, 0.3) + vec2(range3*cos(speed3), range3*sin(speed3));
	float r1 = length(position-p1);
	float r2 = length(position-p2);
	float r3 = length(position-p3);
	float t1 = fract(r1*ripple1);
	float t2 = fract(r2*ripple2);
	float t3 = fract(r3*ripple3);
	t1 *= 4.0 * (1.0 - t1);
	t2 *= 4.0 * (1.0 - t2);
	t3 *= 4.0 * (1.0 - t3);
	color.r = color.g = color.b = pow(t1 * t2 * t3, 1.0);
	color = color * vec3(.5 + cos(time3)*.5, .5 + cos(time4)*.5, .5 + cos(time5)*.5);
	gl_FragColor.rgba = vec4(color, 1.0);
}
