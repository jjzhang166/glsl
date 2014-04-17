
precision mediump float;
uniform vec2 resolution; // window size.xy
uniform float time;

void main() {

	float a = time * 30.0;
	float b = a / 100.0;
	float x = gl_FragCoord.x;
	float y = gl_FragCoord.y;
	vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy; // x <-> y 0+/- 1
	
	float s = -1.0 + 2.0 * p.y / 30.0;
	
	float f = .5 * (p.y * 0.5 + 0.5 );
	float r = sin(b * p.x / f);
	float g = sin((f * r) / 0.8) / p.y;
	
	float d = sqrt(pow(r-g,2.0)+pow(g/f,2.0));
	gl_FragColor=vec4(r, d, 0.0, 1.0);
}