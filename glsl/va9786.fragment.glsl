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

bool inCircles(vec2 position, float gridCells, float radius,
	      float rotationSpeed, vec2 center) {
  position = rotate(position, time*rotationSpeed, center);
  float px = mod(position.x*gridCells, 1.);
  float py = mod(position.y*gridCells, 1.);
  float d = distance(vec2(px,py), vec2(0.5,0.5));
  return d < radius;
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec4 color = vec4(0,0,0,1);
	if(inCircles(position, 5., 0.45, .2, vec2(0.2,0.3))) {
		float b = 0.4 + 0.3*abs(cos(time*0.9));
		color += vec4(0, 0, b, 0);
	}
	
	if(inCircles(position, 7., 0.4, .3, vec2(.7,.3))) {
		float r = 0.3 + 0.5*abs(cos(time*1.1));
		color += vec4(r, 0, 0, 0);
	}
	if(inCircles(position, 13., 0.3, .4, vec2(.3, .7))) {
		float g = 0.2 + 0.5*abs(cos(time*2.));
		color += vec4(0, g, 0, 0);
	}
  	gl_FragColor = color;
}

