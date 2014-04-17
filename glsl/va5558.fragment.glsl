#ifdef GL_ES
precision mediump float;
#endif

//WHAT THE FUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const vec4 firstColor = vec4(0,0,1,1);
const vec4 secondColor = vec4(1,0,0,1);
const float r1 = 200.0;
const float r2 = 100.0;

void main( void ) {
	highp float x1 = 300.0;
	highp float y1 = 300.0;
	highp float x2 = 100.0;
	highp float y2 = 100.0;
	highp float xP = gl_FragCoord.x;
	highp float yP = gl_FragCoord.y;

	highp float theSqrt = sqrt(r2 * r2 * ((x1 - xP) * (x1 - xP) + (y1 - yP) * (y1 - yP)) - 2.0 * r1 * r2 * ((x1 - xP) * (x2 - xP) + (y1 - yP) * (y2 - yP)) + r1 * r1 * ((x2 - xP) * (x2 - xP) + (y2 - yP) * (y2 - yP))
               		-((x2 * y1 - xP * y1 - x1 * y2 + xP * y2 + x1 * yP - x2 * yP) * (x2 * y1 - xP * y1 - x1 * y2 + xP * y2 + x1 * yP - x2 * yP)));
	highp float t;
	if(distance(gl_FragCoord.xy, vec2(x2, y2)) > r2) {
		t = (-r2 * (r1 - r2) + (x1 - x2) * (x2 - xP) + (y1 - y2) * (y2 - yP) + theSqrt)
 			/ ((r1 - r2) * (r1 - r2) - (x1 - x2) * (x1 - x2) - (y1 - y2) * (y1 - y2));
	} else {
		t = (-r2 * (r1 - r2) + (x1 - x2) * (x2 - xP) + (y1 - y2) * (y2 - yP) - theSqrt)
 			/ ((r1 - r2) * (r1 - r2) - (x1 - x2) * (x1 - x2) - (y1 - y2) * (y1 - y2));
	}
	if (t >= 0.0 && t <= 1.0) {
		gl_FragColor = mix(firstColor, secondColor, t);
	}
}