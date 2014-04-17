// by rotwang
//#version 120
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float PI = 3.1415926535;

vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

float max3(float a,float b,float c)
{
	return max(a, max(b,c));
}



float rect( vec2 p, vec2 b, float smooth )
{
	vec2 v = abs(p) - b;
  	float d = length(max(v,0.0));
	return 1.0-pow(d, smooth);
}
/*
float sizes[5] = float[]
(
	3.4, 4.2, 5.0, 5.2, 1.1
);
*/
/*
vec3 colors[3] = vec3[3]
(
  vec3(1.0, -19.0, 4.5),
  vec3(-3.0, 2.718, 2.0),
  vec3(29.5, 3.142, 3.333)
);
*/




vec3 bars( vec2 p )
{
	vec3 clr= vec3(0);
	float x = 0.0;
	for(int i=0; i<=8; i++)
	{
		x = mod(float(i),8.0);
		float d = rect(p - vec2(x,0.0), vec2(0.1,0.5), 0.1);
		float hue = float(i) / 8.0;
		vec3 clr1 = hsv2rgb(hue,0.9,2.0) *d; 
		clr += clr1;
		
	}
	return clr;
}


void main( void ) {

	vec2 unipos = (gl_FragCoord.xy / resolution);
	vec2 pos = unipos*2.0-1.0;
	pos.x *= resolution.x / resolution.y;
	
	
	// scroll
	pos.x += mod(time,8.0);
	
	
	vec3 clr = bars(pos);
	gl_FragColor = vec4( clr , 1.0 );

}