// https://www.shadertoy.com/view/lsf3RH

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float rand(vec2 co){
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float averageForRadius(vec2 co, float radius) {
	float average = float(0);
	
	float sampleSize = 1.0;
	
	int n = 0;
        float y2 = 0.0;
        float x2;
        float x3;
	for (int i = 0; i < 50; i++) {
		if (y2 > radius) break;
		
		x2 = sqrt(pow(radius, 2.0) - pow(y2, 2.0));
                x3 = (x2 - sampleSize) * -1.0;
		
		for (int k = 0; k < 50; k++) {
			if (x3 >= x2) break;
			
			vec2 spoint = vec2(x3 / resolution.x, y2 / resolution.y);
			average += texture2D(backbuffer, co + spoint).r;
			n++;
			
			if (y2 != 0.0) {
				vec2 spoint = vec2(x3 / resolution.x, y2 / resolution.y * -1.0);
				average += texture2D(backbuffer, co  + spoint).r;
				n++;
			}
			
			x3 += sampleSize;   
		}

		y2 += sampleSize;	
	}

        return average / float(n);
}

void main(void) 
{
	vec2 position = gl_FragCoord.xy / resolution.xy;
	position = position + vec2(-1.0 / resolution.x, 0);
	vec4 source = texture2D(backbuffer, position);
	vec4 colour = source;
	
	float random = rand(vec2(position.x + time, position.y + time));
	random = (random * 2.0) - 1.0;
	float randomMultiplier = 1.0 - position.x * 3.0;
	if (randomMultiplier > 0.0) {
		colour += random * randomMultiplier;
	};
	
	float activator = averageForRadius(position, 3.0);
	float inhibitor = averageForRadius(position, 6.0);
	float multiplier = position.x / 30.0;
		
	if (activator > inhibitor) {
		colour += multiplier;
	} else {
		colour -= multiplier;
	}

	gl_FragColor = colour;
}