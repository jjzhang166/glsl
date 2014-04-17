#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.1415926535897932384626433832795

uniform float time;
uniform vec2 resolution;

void main(void) {
	//our final desired color
	vec4 vColor = vec4(0.0, 0.0, 1.0, 0.0);
	
	//changing coordinates
	vec2 pos = gl_FragCoord.xy - resolution.xy*.5;
	vec2 res = resolution.xy*.4;
	
	//calculating the distance
	//float b = (dot(vec2(1.0,0.0), normalize(gl_FragCoord.xy))/(0.0*PI));
	float t = time*10.0;
	//float b = dot(normalize(pos), vec2(0.0,1.0))*200.0;
	float b = dot(normalize(pos), vec2(0.0,1.0))*200.0;
	float dist = distance(pos, vec2(0.0,0.0))+sin(t+b)*10.0;
	
	if (dist > res* .5 && dist < res * .51){		
		gl_FragColor = vColor;
	}
	
	
}