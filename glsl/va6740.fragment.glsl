// original by rotwang

// Wooop wooop !!! Thats da sound of da police !!!


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



float rect( vec2 p, vec2 b, float smooth )
{
	vec2 v = abs(p) - b;
  	float d = length(max(v,0.0));
	return 1.0-pow(d, smooth);
}

void main( void ) {

	vec2 unipos = (gl_FragCoord.xy / resolution);
	vec2 pos = unipos*2.0-1.0;
	pos.x *= resolution.x / resolution.y;

	float flash = cos(time*18.0);
	float uflash = flash*0.5+0.5;
	
	
	
	// scroll
	pos.x -= tan(time*2.5)*5.0;
	
	float d1 = rect(pos - vec2(-1.0,0.0), vec2(0.1,0.5), 0.1); 
	vec3 clr1 = vec3(11.2,0.0,1.0) *d1; 
	
	float d2 = rect(pos - vec2(0.0,0.0), vec2(0.1,0.5), 1.0); 
	vec3 clr2 = vec3(0.6,0.0,0.2) *d2; 

	float d3 = rect(pos - vec2(1.0,0.0), vec2(0.1,0.25), uflash*0.2); 
	vec3 clr3 = vec3(0.99,0.0,11.2)*d3 + (0.425*flash); 

	
	
	vec3 clr = clr1+clr2+clr3;
	gl_FragColor = vec4( clr , 0.20 );

}