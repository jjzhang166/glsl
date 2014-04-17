#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec2 lightPos = vec2(0.5, 0.8);
	float d = (1.0 / distance(lightPos, position))*0.1;
	d += (1.0 / distance(vec2(0.2,0.4), position))*0.6;
	d += (1.0 / distance(vec2(0.6,0.4), position))*0.1;
	d += (1.0 / distance(vec2(0.9,0.4), position))*0.1;
	gl_FragColor = vec4(d, d * 0.7, d*0.2, 1.0) * sin(d*time);
}