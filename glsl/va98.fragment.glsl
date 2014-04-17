#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * vec2(2) + vec2(-1);

	vec2 q = vec2(0.1 * sin(0.75*time), 0.4*cos(time*3.1));
	float i = 6.7 * sin( time * 0.61 + sin(time*0.21) );
	vec2 c = vec2( 0.1*sin( distance(position, vec2(0.1,0.3)) * i + time * 3.1), 0.1*sin( (position.x+position.y)*i ) );
	float h = mod( float(int(mod(distance(q,position+c)*20.0,2.0)) + 2 * int(mod(distance(-q,position+c)*20.0,2.0))),3.0) / 2.0; 
	gl_FragColor=vec4(h,h,h,1.0);

}