#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Just me learning about matrices
// B

void main( void ) {

	vec2 pt = ( gl_FragCoord.xy / resolution.y );

	float color = 0.0;
	vec2 pts[32];
	for(int i = 0; i < 32; i++)
	{
		pts[i] = vec2(float(i) * .01, sin(float(i)/32.*3.14*2.+(i==0?0.:time*5.))/10.);
	}
	
	float r = time;
	mat2 m = mat2(cos(r), sin(r),
		      -sin(r), cos(r));
	
	for(int i = 0; i < 32; i++)
	{
		pts[i].xy *= m;
		pts[i] += vec2(1., .5);
		if(length(pt - pts[i]) < .005)
			color = 1.;
	}
	
	gl_FragColor = vec4( vec3( color ) , 1.0 );

}