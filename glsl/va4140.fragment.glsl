

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.141592;

vec2 r2(vec2 p, float a) {
	mat2 m = mat2 ( cos(a),-sin(a), sin(a), cos(a) );
	return m*p;
}

vec2 x2(vec2 p, float a) {
	mat2 m = mat2 ( 
		cos(a*p.x),
		-sin(a), 
		sin(a), 
		cos(a) );
	return m*p;
}

void main( void ) {

	// coords
	vec2 p = -1.+2.*( gl_FragCoord.xy/resolution);
	p.x*=resolution.x/resolution.y;	
	p=p*1.2;

	// dd
	p=r2(p,time*0.5+PI/6.);
	
	// coords
	float r = length(p);	
	float a = atan(p.y,p.x);

		
	// base color	
	vec3 color =  vec3(0.2,0.3,0.4);
	
	//effect
	vec3 c = vec3(0.4,0.3,0.2);
	float ss = 0.5+0.5*sin(time);
	color = mix( color,c,pow(r,mix(5.,100.,ss+a)) );
	
	gl_FragColor = vec4( color , 1.0 );

}