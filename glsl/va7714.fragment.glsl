#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = ( gl_FragCoord.xx / resolution.y );
	float color = 0.0;
	
	color += sin(time / 2. + position.x * cos(time / 4.) - sin(position.x * 5.));
	color += cos(time / 4. + position.x * sin(position.x / 6. + cos(time * 2.)) - cos(position.x / 2.));
	color += cos(position.y * sin(time / 3.) + cos(position.x * time / 8.) - cos(position.y / 2.));
	color -= cos(time / 2. * cos(position.y / 2.));
	color *= sin(time);
	color /= cos(position.x / time);
	
	gl_FragColor = vec4(0,1.2*sin(color),sin(color),1);
}