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
	f1.y = pow(f1.y, 1.0/2.2);
	f1.y = pow(f1.y, 2.2/1.0);
	float d1 = smoothstep(linewidth,0.0,length(position-f1));
	vec2 f2 = position.xx;
	float steps = 8.0;
	f2.y+= nrand(position) / steps;
	vec2 f2a = f2;
	f2.y = pow(f2.y, 1.0/2.2);
	f2.y = pow(f2.y, 2.2/1.0);
	float d2 = smoothstep(linewidth,0.0,length(position-f2));

	f2a.y = pow(f2a.y, 1.0/2.2);
	f2a.y = trunc(f2a.y, steps);
	f2a.y = pow(f2a.y, 2.2/1.0);
	float d2a = smoothstep(linewidth,0.0,length(position-f2a));

	
	vec2 f3 = position.xx;
	f3.y = pow(f3.y, 1.0/2.2);
	f3.y = trunc(f3.y, steps);
	f3.y = pow(f3.y, 2.2/1.0);
	float d3 = smoothstep(linewidth,0.0,length(position-f3));
	float d4 = 0.0;
	
	gl_FragColor = vec4(d1, d2 + d2a, d3, 1.0 );

}