#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi = atan(1.)*4.;

void main( void ) {
	
	vec2 res = vec2(resolution.x/resolution.y,1.);
	vec2 p = ( gl_FragCoord.xy / resolution.y );

	float grad = 0.0;
	
	float t = time * 4.0;
	
	if(p.x > res.x/2.)
	{
		vec2 c = res*vec2(.75,0.5);
		
		float angle = atan( (c.y-p.y)/(c.x-p.x) + sin(t) ); //atan(y / x) only provides half of the unit circle (0 - Pi).
		
		grad = ((pi/2.)+angle)/(pi);
	}
	else
	{
		vec2 c = res*vec2(.25,0.5);
		
		float angle = atan( (c.x-p.x)  + cos(t),(c.y-p.y) + sin(t) ); //atan(x , y) provides the full unit circle (-Pi - Pi).
		
		grad = (pi+angle)/(pi*2.);
	}
	
	vec3 color = mix(vec3(1,1,.8),vec3(.2,0,0.1),grad);

	gl_FragColor = vec4( vec3( color ), 1.0 );

}