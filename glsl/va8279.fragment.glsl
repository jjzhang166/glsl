#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float LIGHT_CIRCLE_SIZE = 200.0;
float INNER_CIRCLE_SIZE = 40.0;
float SMALL_CIRCLE_SIZE = 10.0;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float light(){
	
    	float randX = sin(time)*0.5+0.5;
    	float randY = cos(time)*0.5+0.5;
	
	vec2 point = vec2(randX,randY);
	vec2 distance = gl_FragCoord.xy  - point.xy*resolution.xy;
	
	float len = length(distance);
	return clamp(0.4 - smoothstep(SMALL_CIRCLE_SIZE/5.0, SMALL_CIRCLE_SIZE, len), 0.0, 1.0);
}

vec3 torchLight(){
	float flicker = sin(time*30.0+1.4)+sin(time*20.0)+cos(time*.0+0.8)+cos(12.2*time+4.2) * 3.0;
	float flimmer = 1.0 - (sin(time*10.0)*0.5+0.5)*0.05;
	float flimVal = sin(time*10.0) + sin(time*2.0+2.14) + cos(time*4.5+2.14)*0.5;
	flimmer = flimmer - smoothstep(0.7, 1.0, flimVal)*(0.6+(sin(time)+0.5)*0.1);
	
	vec2 distance = gl_FragCoord.xy  - mouse.xy*resolution.xy;
	float length = length(distance);
	float level = smoothstep(INNER_CIRCLE_SIZE+flicker/2.0, LIGHT_CIRCLE_SIZE+flicker, length+flicker*2.0);
	
	vec3 torchLight = vec3(1.0 - level, 0.9 - level*1.2, 0.8- level*2.5);
	torchLight = clamp(torchLight, vec3(0.0), vec3(1.0,1.0,1.0));
	return torchLight * flimmer;
}

void main( void ) {
	
	
	
	vec3 underlying = vec3((sin(gl_FragCoord.x/4.0)+1.0)/2.0);
	
	gl_FragColor = vec4(underlying * (torchLight()+ vec3(light())), 1.0 );

}