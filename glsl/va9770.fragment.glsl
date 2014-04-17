#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - mouse + 0.5;
	vec2 dd = position - vec2(0.5,0.5);
	//position += vec2(sqrt(dot(dd,dd)), sqrt(dot(dd,dd)));
	float ddist = sqrt(dot(dd,dd));
	//position *= ddist*10.;

	float r = 0.0;
	float g = 0.0;
	float b = 0.0;
	
	float dispx = position.x - 0.5;
	float dispy = position.y - 0.5;
	float ang = acos(dot(vec2(dispx,dispy), vec2(0.,-1.))/length(vec2(dispx,dispy)));
	
	r = sin(ang*15.);
	g = cos(ang*50. + time*5.);
	b = sin(50.*position.y * dot(vec2(dispx,dispy), vec2(dispx,dispy)) + time * -5.);
	
	float dist = dot(vec2(dispx,dispy), vec2(dispx,dispy));
	r *= sqrt(dist/2.);
	g *= sqrt(dist/2.);
	b *= sqrt(dist);
		
	gl_FragColor = vec4( vec3( r, g, b), 1.0 );

}