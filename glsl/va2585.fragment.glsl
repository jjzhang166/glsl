#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec3 color;
	vec2 dist = position - vec2(0.5, 0.5);
	float ang = atan(dist.y, dist.x);
	float dd = sqrt(dist.x*dist.x+dist.y*dist.y);
	
	color.r = abs(cos(5.0+2.0*ang-dd*50.0+time*5.0));
	color.g = abs(cos(4.0+1.5*ang-dd*100.0+time*4.0));
	color.b = abs(cos(3.0+ang-dd*150.0+time*3.0));
	color /= dd/0.4;
	gl_FragColor = vec4( color, 1.0 );

}