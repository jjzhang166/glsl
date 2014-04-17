#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float random(vec2 v) 
{
return fract(sin(dot(v ,vec2(12.9898,78.233))) * (100.0+time*100.05));
}

void main( void ) 
{
	const int numColors = 9000;
	vec3 colors[numColors];
	colors[0] = vec3( random(vec2(time,time*time))*255., random(vec2(time*1.1,time*time*1.1))*255., random(vec2(time*1.2,time*time*1.2))*255.) / 255.0;
	colors[1] = vec3( random(vec2(time*1.3,time*time*1.3))*255., random(vec2(time*1.4,time*time*1.4))*255., random(vec2(time*1.6,time*time*1.6))*255.) / 255.0;
	colors[2] = vec3( random(vec2(time*1.7,time*time*1.7))*255., random(vec2(time*1.8,time*time*1.8))*255., random(vec2(time*1.9,time*time*1.9))*255.)/ 255.0;
	
	vec2 screenPos = gl_FragCoord.xy;
	vec2 screenPosNorm = gl_FragCoord.xy / resolution.xy;
	vec2 position = screenPosNorm + mouse / 4.0;
	vec4 prevColor = texture2D( backbuffer, screenPosNorm );
	
	
	// calc block
	vec2 screenBlock0 = floor(screenPos*0.16 + vec2(time,0) + mouse*3.0);
	vec2 screenBlock1 = floor(screenPos*0.08 + vec2(time*1.5,0) + mouse*5.0);
	vec2 screenBlock2 = floor(screenPos*0.02 + vec2(time*2.0,0)+mouse*10.0);
	float rand0 = random(screenBlock0);
	float rand1 = random(screenBlock1);
	float rand2 = random(screenBlock2);
	
	float rand = rand1;
	if ( rand2 < 0.05 ) { rand = rand2; }
	
	// block color
	vec3 color = mix( colors[0], colors[1], pow(rand,5.0) );
	if ( rand < 0.05 ) { color=colors[2]; }
	
	
	
	
	float vignette = (1.6-length(screenPosNorm*2.0-1.0))*(sin(time*time)+0.5);
	vec4 finalColor = vec4(color*vignette, 1.0);
	
	//gl_FragColor = finalColor;
	gl_FragColor = mix(prevColor, finalColor, sin( sin(screenPos.x)+cos(screenPos.y) +time*10.0)*0.5+0.5);
	
	if( rand==rand2) { gl_FragColor = finalColor;}

}