#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

const int N = 13;
const float pi2 = 3.14159 * 2.0;
float xy = resolution.x/resolution.y;

vec2 loc( float order ){
	float fx = fract(0.2*time+0.8*order);
	float fy = fract(0.3*time+0.7*order);
	float amp = 0.1 * order + 0.8;
	float x = 20.;
	vec2 pos = vec2(amp*cos(3.14*(1.+2.*fx)) / xy,
			amp*sin(3.14*(-1.+2.*fy))
		       );
	
	vec2 a = vec2(0.,0.);
	return pos;
}

vec3 lazer(vec2 pos, vec3 clr, float mult)
{
	
	//float d = distance(pos,vec2(-1.0+fract(x*0.5)*2.,0.0));
	vec3 color;
	for(int i =0; i<N; ++i){
		float order = (1.-float(i)/float(N));
		float w = fract(time*0.6);
		
		w = 1.+sin(pi2*(w+order));
		w *= 0.4*order; //ampli intensite
		w += 0.3;
		
		float d = distance(pos,loc(order));
		color += (clr * 0.25*w/d);
	}
	
	return color;
}


void main()
{
	vec2 pos = ( gl_FragCoord.xy / resolution.xy * 2.0 ) - 1.0;
	vec3 color = max(vec3(0.), lazer(pos, vec3(1.1, 1.5, 3.), 0.25));
	gl_FragColor = vec4(color * 0.05, 1.0);
}
