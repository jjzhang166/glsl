#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	//float color = 0.0;
	//color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	//color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	//color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	//color *= sin( time / 10.0 ) * 0.5;

	//gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
	float PI = 3.1415926;
	float rfactor = 0.0, gfactor = 0.0, bfactor = 0.0;
	vec2 rcenter = vec2(0,0), gcenter = vec2(resolution.x,0), bcenter = vec2(resolution.x/2.0,resolution.y);
	float rr = 5.0/4.0 * PI, gr = 7.0/4.0 * PI, br = 0.5 * PI;
	float step = mod(time, 15.0) / 15.0 * 2.0 * PI;
	rcenter = vec2(cos(rr + step),sin(rr + step)) * resolution.y / 3.0 + resolution.xy / 2.0;
	gcenter = vec2(cos(gr + step),sin(gr + step)) * resolution.y / 3.0 + resolution.xy / 2.0;
	bcenter = vec2(cos(br + step),sin(br + step)) * resolution.y / 3.0 + resolution.xy / 2.0;
	rfactor = 1.0 - length(gl_FragCoord.xy - rcenter) / 200.0;//length(resolution);
	gfactor = 1.0 - length(gl_FragCoord.xy - gcenter) / 200.0;//length(resolution);
	bfactor = 1.0 - length(gl_FragCoord.xy - bcenter) / 200.0;//length(resolution);
	gl_FragColor = vec4(rfactor,gfactor,bfactor,1.0);
	
}