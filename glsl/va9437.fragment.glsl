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

float blur(vec2 co, float size) {
    // size of step between box blur samples
    float kernelStep = size;
    
    // box blur
    
    #define KERNEL_HALF_SIZE 2
    #define KERNEL_SIZE 5
    float ave = float(0);
    for (int y=-KERNEL_HALF_SIZE; y<=KERNEL_HALF_SIZE; ++y)
    for (int x=-KERNEL_HALF_SIZE; x<=KERNEL_HALF_SIZE; ++x) {
        vec2 spoint = vec2(float(x), float(y))*kernelStep;
        
        spoint.y = -spoint.y;
        spoint.x /= 0.5;
        ave += texture2D(backbuffer, co+spoint).r;
    }
    ave /= float(KERNEL_SIZE*KERNEL_SIZE);
    return ave;
}

void main(void) 
{
	vec2 position = gl_FragCoord.xy / resolution.xy;
	vec2 adjacentPosition = gl_FragCoord.xy / resolution.xy;
	adjacentPosition.x -= 0.001;
	float source = texture2D(backbuffer, adjacentPosition).r;
	
	if (position.x < 0.2) {
		float random = rand(vec2(position.x + time, position.y + time));
		gl_FragColor = vec4(random, random, random, 1);
		
	} else {
		//gl_FragColor = vec4(position.x, position.y, 0, 1);
		//gl_FragColor = vec4(source, source, source, 1);

		float activator = blur(adjacentPosition, 0.006);
		float inhibitor = blur(adjacentPosition, 0.003);
		if (activator < inhibitor) {
			source += 0.01;
		} else {
			source -= 0.01;
		} 
		gl_FragColor = vec4(source, source, source, 1);
		
		
	}
}