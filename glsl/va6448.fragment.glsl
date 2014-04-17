#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int MAXITER = 1400;
const float MAXDEPTH = 300.;

// dive into the ravine

void main( void ) {
	vec2 n = (gl_FragCoord.xy-resolution*.5)/resolution.x*3.-vec2(.5,0);
	
	float ft = fract(time*.2);
	ft = floor(ft*ft*MAXDEPTH);
	
	vec2 cn = vec2(0,ft*.31832*2.);
	
	n += cn;
	n /= dot(n,n);
	n += vec2(-.75,0);

	
	
	vec4 n4 = vec4(n,1,0);
	vec4 p = n4;
	
	float m = float(MAXITER)+1.;
	for(int i=0; i<MAXITER; i++) {
		// p = p²+n
		// p' = 2*p*p'+1
		p = p*p.x*vec4(1,1,2,2)+p.yxwz*p.y*vec4(-1,1,-2,2)+n4;
		p = p*p.x*vec4(1,1,2,2)+p.yxwz*p.y*vec4(-1,1,-2,2)+n4;
		p = p*p.x*vec4(1,1,2,2)+p.yxwz*p.y*vec4(-1,1,-2,2)+n4;
		p = p*p.x*vec4(1,1,2,2)+p.yxwz*p.y*vec4(-1,1,-2,2)+n4;
		if (dot(p.xy,p.xy) > 16.) break;
	}
	float l = length(p.xy);
	float dl = length(p.zw);
	m = l<4. ? 0. : l*log(l)/dl*dot(cn,cn);
	
	vec3 cb = vec3(30.,1.,.03)*.0001;
	vec3 color = cb/(cb+m);
	
	gl_FragColor = vec4( 1.-color, 1.0 );

}