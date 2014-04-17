// by rotwang

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float rect( vec2 p, vec2 b, float smooth )
{
	vec2 v = abs(p) - b;
  	float d = length(max(v,0.0));
	return 1.0-pow(d * 10.0, smooth);
}

void main( void ) {

	vec2 unipos = (gl_FragCoord.xy / resolution);
	vec2 pos = unipos*2.0-1.0;
	pos.x *= resolution.x / resolution.y;

	float uflash = 0.4;
	
	
	float d1 = rect(pos - vec2(-0.3,0.0), vec2(0.1,1.0), uflash); 
	vec3 clr1 = vec3(0.2,0.6,1.0) * d1; 
	
	float d2 = rect(pos - vec2(0.0,0.0), vec2(0.1,1.0), uflash); 
	vec3 clr2 = vec3(0.6,1.0,0.2) * d2; 

	float d3 = rect(pos - vec2(0.3,0.0), vec2(0.1,1.0), uflash); 
	vec3 clr3 = vec3(1.0,0.0,0.2) * d3; 
	
	float d4 = rect(pos - vec2(0.0,0.0), vec2(1.0,0.1), 0.2);
	vec3 clr4 = vec3(1.0,1.0,1.0) * d4;
	
	
	vec3 clr = clr1+clr2+clr3+clr4;
	gl_FragColor = vec4( clr , 1.0 );

}