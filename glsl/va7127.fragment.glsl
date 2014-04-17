#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	//aspect ratio
	float ar = resolution.x/resolution.y;
	
	//position coordinates
	vec2 uv = ( gl_FragCoord.xy / resolution.xy );

	//centre the origin on screen
	uv-=.5;
	
	//apply aspect ratio correction
	uv.x*=ar;

	//calculate frequently used values
	//radial displacement / distance from centre
	float r=sqrt(dot(uv,uv));
	//angular displacement
	float a=atan(uv.y,uv.x);

	a+=time/10.+1.*uv.x*uv.y;
	
	float col=1.0;
//	col*= smoothstep(0.,0.5,fract(10.*a));
	col*= 1.-smoothstep(0.95,1.0,fract(10.*a));

	gl_FragColor = vec4( vec3( col*fract(5.0*a), col*fract(5.*a+.5),col) *1., 1.0 );

}