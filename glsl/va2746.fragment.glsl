#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//vec3 base = vec3(0.0, 0.5, 0.7);

float nsin(float n) { return (sin(n) + 1.0) / 2.0; }

void main( void ) {
        vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	float fudge = 5.5;
	
	vec3 base = vec3(nsin(fudge * 476463.0), nsin(fudge * 3232.0), nsin(fudge * 3827372.0));
	
	float y = position.y + sin(fudge * 11232.0 + position.x * 2.0 * 3.14) * 0.005 - cos(fudge * 27621.0 + position.y * 3.14 * 8.0) * 0.1;
	
	float stage = floor(y * 10.0);
	
	float color = nsin(fudge * 448733.0 + stage * 34.5);
	
	color = 0.4 + color * 0.3;
	
	gl_FragColor = vec4(color * base, 1.0);
}