#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float trunc(float val, float steps) {
	return floor(val*steps)/steps;
}


float nrand( vec2 n ) {
  return fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453) - 0.5;
}


void main( void ) {

	float linewidth = 2.0 / resolution.x;
	vec2 position = gl_FragCoord.xy / resolution.yy;
	
	vec2 f1 = position.xx;
	float d1 = smoothstep(linewidth,0.0,length(position-f1));
	vec2 f2 = position.xx;
	float d2 = smoothstep(linewidth,0.0,length(position-f2));

	float d3 = 0.0;
	float d4 = 0.0;
	
	gl_FragColor = vec4(d1, d2, d3, 1.0 );

}