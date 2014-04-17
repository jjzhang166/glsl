#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//rob dunn
#define ITER 100.0

vec2 cmult(vec2 x, vec2 y) {
	float a = x.x;
	float b = x.y;
	float c = y.x;
	float d = y.y;
	return vec2(a*c-b*d, a*d+b*c);
}

vec2 f(vec2 x,vec2 c) {
	return cmult(x,x)+c;
}

vec4 colormap(float x){
	x*=4.;
	return vec4( sin(x), sin(3.14/4.+x),sin(3.14/2.+x),1.0);	
}

void main( void ) {

	vec2 p = 2.5*(( gl_FragCoord.xy / resolution.xy ) - vec2(0.5,0.5));
	p.x *= resolution.x/resolution.y;
	vec2 m = 2.0*(( mouse.xy ) - vec2(0.5,0.5));

	for(float i = 0.0 ; i < ITER; i+= 1.0)
	{
		gl_FragColor = vec4( 0.0,0.0,0.0,1.0);
		if(length(p) > 100.)
		{
			float dist = i/ITER;
			gl_FragColor = colormap(dist);
			break;
		} else {			
			p = f(p,m);
		}		
	}
}