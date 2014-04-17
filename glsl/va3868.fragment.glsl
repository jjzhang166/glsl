

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float PI = 3.1415926535;

float max3(float a,float b,float c)
{
	return max(a, max(b,c));
}



float rect( vec2 p, vec2 b )
{
	p*= 2.0;
	vec2 v = abs(p) - b;
  	float d = length(max(v,0.0));
	return 1.0-pow(d, 1.0/8.0);
}

void main( void ) {

	vec2 unipos = (gl_FragCoord.xy / resolution);
	vec2 pos = unipos*2.0-1.0;
	pos.x *= resolution.x / resolution.y;

	// scroll
	pos.x += time*0.1;
	
	
	float d = rect(pos, vec2(1.0,0.5)); 
	
	
	vec3 clr = vec3(0.2,0.6,1.0) *d; 
			

	
	gl_FragColor = vec4( clr , 1.0 );

}