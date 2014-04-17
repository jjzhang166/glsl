#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.1415926535897932384626433832795

uniform float time;
uniform vec2 resolution;

void main(void) {
	//our final desired color
	vec4 vColor = vec4(0.4, 0.7, 0.5, 1.0);
	
	//changing coordinates
	vec2 pos = gl_FragCoord.xy - resolution.xy*0.5;
	vec2 res = resolution.xy*0.5;
	
	//calculating the distance
	//float b = (dot(vec2(1.0,0.0), normalize(gl_FragCoord.xy))/(2.0*PI));
	float t = time/10.0;
	//float b = dot(normalize(pos), vec2(0.0,1.0))*200.0;
	float b = dot(normalize(pos), vec2(0.0,1.0))*200.0;

	float dist = distance(pos+(mat2(cos((pos.x*(t)-pos.y*(t+70.0))/10.0),
					-sin((pos.x*(t)-pos.y*(t+70.0))/10.0),
					sin((pos.x*(t)-pos.y*(t+70.0))/10.0),
					cos((pos.x*(t)-pos.y*(t+70.0))/10.0))
				   *vec2(4.0,0.0)), vec2(0.0,0.0));

	
	//float dist = distance(pos+vec2(10.0,0.0), vec2(0.0,0.0));
	
	if (dist > 500.0*0.5 && dist < 500.0 * 0.51){		
		gl_FragColor = vColor;
	}
	

	if (dist > 400.0*0.5 && dist < 400.0 * 0.51){		
		gl_FragColor = vColor;
	}	
	
	if (dist > 300.0*0.5 && dist < 300.0 * 0.51){		
		gl_FragColor = vColor;
	}	
}