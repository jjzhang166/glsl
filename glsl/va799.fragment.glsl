#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 3.0;
  	color = sqrt((position.x - mouse.x) * (position.x - mouse.x) + (position.y - mouse.y) * (position.y - mouse.y))*67.0*sin(time/3.0)*cos(time / 5.0);
	color *= sin( time / 1.0 ) * 0.3;
  	color += sin(time);
  	color *= sin(cos(time + position.x + position.y));
  	color += tan(position.x * position.y);
  	color *= sin(sin(cos(sin(time))));

	gl_FragColor = vec4( vec3( sin(cos(color * color / 5.0 * time)), cos(sin(color * 1.7 * color * 125.0 + time)), (color/2.0*sin(time / 1.5)) * 0.75 ), 1.0 );

}