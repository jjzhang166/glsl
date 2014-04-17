#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 rotate(vec2 pos, float angle, vec2 center) {	
  mat2 rot = mat2(cos(angle), -sin(angle),
		  sin(angle),  cos(angle));
  return rot*(pos-center) + center;
}
float sq(float v) { return v*v; }

float inCircles(vec2 position, float gridCells, float radius,
	      float rotationSpeed, vec2 center) {
  position = rotate(position, time*rotationSpeed, center);
  float px = mod(position.x*gridCells, 1.);
  float py = mod(position.y*gridCells, 1.);
  vec2 diff = vec2(px,py) - vec2(0.5,0.5);
  float boundary = sq(radius);
  float eps = 0.005;
  return smoothstep(boundary-eps, boundary+eps, dot(diff,diff));
}

void main( void ) {
	vec2 position = gl_FragCoord.xy / min(resolution.x, resolution.y );
	vec4 color = vec4(0,0,max(.1,.3-mouse.y),1);

	color += vec4(.4, .5, .9, 0)*inCircles(position, 3., 0.57, .4, vec2(.3, .7));
	color += vec4(.5, .5, 1, 0)*inCircles(position, 7., 0.53, .3, vec2(.7,.3));
	color += vec4(.5, .7, 1, 0)*inCircles(position, 5., 0.55, -.2, vec2(0.2,0.3));
	
  	gl_FragColor = color;
}

