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

vec4 subPixel(sampler2D source, vec2 coords) {
	float x = floor(coords.x - 0.5) + 0.5;
	float y = floor(coords.y - 0.5) + 0.5;
	
	vec4 pixel         = texture2D(source, vec2(x, y) / resolution.xy);
	vec4 pixelRight    = texture2D(source, vec2(x + 1.0, y) / resolution.xy);
	vec4 pixelTop      = texture2D(source, vec2(x, y + 1.0) / resolution.xy);
	vec4 pixelTopRight = texture2D(source, vec2(x + 1.0, y + 1.0) / resolution.xy);
	
	float xFraction = coords.x - x;
	float yFraction = coords.y - y;
	
	float pixelFull = (1.0 + xFraction) * (1.0 + yFraction);
	
	vec4 colour = pixel * (1.0 / pixelFull)
		    + pixelRight * (xFraction / pixelFull)
		    + pixelTop * (yFraction / pixelFull)
		    + pixelTopRight * ((yFraction * xFraction) / pixelFull);
	
	return colour;
}

void main(void) 
{
	vec2 position = gl_FragCoord.xy / resolution.xy;
	vec2 from = vec2((gl_FragCoord.y - resolution.y / 2.0) / (gl_FragCoord.x - resolution.x / 2.0),
			 (gl_FragCoord.x - resolution.x / 2.0) / (gl_FragCoord.y - resolution.y / 2.0));
	vec4 source = subPixel(backbuffer, gl_FragCoord.xy + from);
	//vec4 source = texture2D(backbuffer, position);
	
	float random = rand(vec2(position.x + time, position.y + time));
	vec4 colour = source + ((random * 2.0) - 1.0) * 0.1;

	float activator = averageForRadius(position, 6.0);
	float inhibitor = averageForRadius(position, 12.0);
	if (activator > inhibitor) {
		colour += 0.05;
	} else {
		colour -= 0.05;
	} 
	
	//colour += ((activator * 2.0) - 1.0) * 0.02;
	//colour = vec4(activator, 0, 0, 0);
	
	gl_FragColor = colour;
	//gl_FragColor = vec4(position.y, 0, 0, 0);
}