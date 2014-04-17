#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float triArea(vec2 t1, vec2 t2, vec2 t3){
	return abs(0.5*(-t1.x*t2.y - t1.y*t3.x - t2.x*t3.y + t3.x*t2.y + t3.y*t1.x + t1.y*t2.x));
}

bool inTriangle(vec2 p, vec2 t1, vec2 t2, vec2 t3){
	return abs((triArea(t1,t2,p) + triArea(t1,p,t3) + triArea(p,t2,t3)) - triArea(t1,t2,t3)) < 0.300001;
}


vec2 complex_mul(vec2 factorA, vec2 factorB){
   return vec2( factorA.x*factorB.x - factorA.y*factorB.y, factorA.x*factorB.y + factorA.y*factorB.x);
}

vec2 complex_div(vec2 numerator, vec2 denominator){
   return vec2( numerator.x*denominator.x + numerator.y*denominator.y,
                numerator.y*denominator.x - numerator.x*denominator.y)/
          vec2(denominator.x*denominator.x + denominator.y*denominator.y);
}

vec2 torus_mirror(vec2 uv){
	return vec2(1.)-abs(fract(uv*.5)*2.-1.);
}

void main( void ) {
	vec2 aspect = vec2(1.,resolution.y/resolution.x);
	vec2 uv = (gl_FragCoord.xy / resolution.xy - 0.5)*aspect;
	float mouseW = -atan((mouse.y - 0.5), (mouse.x - 0.5));
	vec2 mousePolar = vec2(-cos(mouseW), sin(mouseW));
	vec2 offset = 0.5 + complex_mul((mouse-0.1)*vec2(-1.,1.)*aspect, mousePolar)*aspect*5. ;
	
	vec2 p = torus_mirror(complex_div(mousePolar*vec2(0.25), uv) - offset);
//	vec2 p = ( 2.0 * gl_FragCoord.xy / resolution.xy) - vec2(1.0,1.0);
	vec2 m = vec2(0.0,0.0);
	float a = 0.30;
	if(inTriangle(p, m+vec2(-a,-a), m+vec2(a,-a), m+vec2(0,a*1.5))){
		gl_FragColor = vec4( vec3( 0.99, 0.6, 0.2 ), 1.0 );
	}else{
		gl_FragColor = vec4( vec3( 0, 0, 0 ), 1.0 );
	}
}