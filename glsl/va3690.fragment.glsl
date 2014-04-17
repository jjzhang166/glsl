#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float threshold = 10.0;

void main(void)
{	
	float speed = 1.2;
	const int amount = 4;
	float followDelay = 1.5;
	
	const int tailLength = 8;
	float tailDelay = 0.00001;
	
	float movementSize = 0.9;
	
	float value = 0.0;
	vec4  color; 
	vec4 finalColor = vec4(0.0,0.0,0.0,0.0);
	
	for(int j=0;j<=amount;j++) {
		
		value = 0.0;
		
		float masterTime = (time - followDelay * float(j)) *speed;
		
		vec2 master_pos = vec2(0.5+(sin(masterTime/6.0))/3.5,0.5-(cos(masterTime/5.0)/3.5));
	
		float rel_master_x = (resolution.x/2.0)-abs((master_pos.x*resolution.x)-(resolution.x/2.0));
		float rel_master_y = (resolution.y/2.0)-abs((master_pos.y*resolution.y)-(resolution.y/2.0));
		vec2 offset 	 = (master_pos * resolution) - vec2((sin(masterTime*4.0))*(rel_master_x)*0.66*movementSize+(0.33*movementSize*(float(j)/float(amount))),-(cos(masterTime*5.0))*(rel_master_y)*0.66*movementSize+(0.33*movementSize*(float(j)/float(amount))));
		float dist	 = distance(gl_FragCoord.xy, offset);
		float brightness = (threshold * ((cos(masterTime * 4.0) + 5.0) / 8.0));
	
		value += smoothstep(0.0, dist, brightness);
	
		for(int i=0;i<=tailLength;i++) {

			float timeOffset = masterTime-0.01*(float(i));
			vec2 offset 	 = (master_pos * resolution) - vec2((sin((timeOffset)*4.0))*(rel_master_x)*0.66*movementSize+(0.33*movementSize*(float(j)/float(amount))),-(cos((timeOffset)*5.0))*(rel_master_y)*0.66*movementSize+(0.33*movementSize*(float(j)/float(amount))));
			float dist	 = distance(gl_FragCoord.xy, offset);
			float brightness = (threshold * ((cos(timeOffset * 4.0) + 5.0) / 12.0));
		
			value += smoothstep(0.2,dist*sqrt(sqrt(float(i))),brightness);
	
		
		}
	color	= vec4(vec3(value), 1.0);
	if(j==0) {	
		color.r *= 0.9;	
		color.g *= 0.3;
		color.b *= 0.8;	
	} else {
		color.r *= 0.2;	
		color.g *= 0.3;
		color.b *= 0.9;
	}
	finalColor += color;
	}
	
	
	finalColor += vec4(0.05,0.4,0.1,1.0);
	
	gl_FragColor = finalColor;
	

}