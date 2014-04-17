#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


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
	vec2 offset = 0.5 + complex_mul((mouse-0.5)*vec2(-1.,1.)*aspect, mousePolar)*aspect*8. ;
	
	vec2 uPos = torus_mirror(complex_div(mousePolar*vec2(0.25), uv) - offset);
	
	float vertColor = 0.1;
	float qTime = time/25.0;
	for( float i = 0.0; i < 5.0; ++i )
	{
		float t = qTime * i;
	
		uPos.x += clamp(sin( (uPos.y + t)* 10. ),-0.025,0.025);
	
		float fTemp = 1.0/abs(uPos.x )/1000.0;
		vertColor += fTemp;
	}
	
	gl_FragColor = vec4( vertColor*3.0, vertColor, vertColor , 1.0 );
}