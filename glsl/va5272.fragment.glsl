#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// no idea how that would sound like... probably pretty strange

void main( void ) {
	vec2 pos = gl_FragCoord.xy / resolution.xy;
	float x = pos.x*20.-10.;
	float y = pos.y*10.-5.;
	
	float s = 0.;
	for (float f = 1.; f <= 55.; f+=2.) {
		s += sin(x*f)*(exp(sin(time*f))-1.-sin(time*f))/(f);
		s += (exp(cos(x*f))-1.-cos(x*f))*cos(time*f)/(f);
		s *= -1.;
	}	
	gl_FragColor = vec4(0,step(0.,s-y),0,1);
}