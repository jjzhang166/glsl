#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 n) {
  return 0.5 + 0.5 * fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
}

float circle(vec2 position, vec2 place, float radius) {
	position += place;
	return smoothstep(radius+0.001, radius, length(position));
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	float aspect = (resolution.x/resolution.y);
	position.x = -position.x * aspect;
	position -= vec2(0, 1);	
	float radius = 0.2;
	float color = 0.3;
	for(float y=0.0;y<=1.;y+=0.1) {
		for(float x=0.;x<=1.;x+=0.1) {
		  color += circle(position, vec2(x*aspect,y)+.05, .03);
		}
	}

	
	gl_FragColor = vec4( vec3( color*0.4, color*0.4, color*0.4 ), 1.0 );

}