precision mediump float;

varying vec2 surfacePosition;
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

float s;

void line ( vec2 a , vec2 b ) {
	vec2 p = gl_FragCoord.xy / resolution.xy;
	float q = resolution.x / resolution.y; a.x *= q ; b.x *= q ; p.x *= q;
	s += step ( distance ( a , p ) + distance ( b , p ) - distance ( a , b ) , 0.01 );
}

void main() {
  vec2 p = surfacePosition;
  line ( vec2 ( mouse ) , vec2 ( - p ) );
  gl_FragColor.rgb = vec3(s+p.x,s,s);
}