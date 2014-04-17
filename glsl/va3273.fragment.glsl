#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 c = vec2(0.5,0.5);

float pi = 3.14159;

vec3 shader( vec2 pos , vec2 res) 
{
	vec2 p = pos;//( gl_FragCoord.xy / resolution.xy );
	
	c = vec2(0.5,0.5);

	vec3 color = vec3(0.0);
	
	float a = atan((p.x-c.x)/(p.y-c.y))+time*0.25;
	
	float d = sqrt((p.x-c.x)*(p.x-c.x)+(p.y-c.y)*(p.y-c.y));
	
	color = vec3(sin(a*2.0+sin(d*(sin(time*0.25)*128.0)+time)));
	color *= vec3(1.0-d*3.0);
	color += vec3(1.0-d*3.0);
	color = clamp(color,0.0,1.0);
	color *= vec3(1.0-d*3.0);
	color += vec3(1.0-d*3.0);
	color = clamp(color,0.0,1.0);
	
	color = mix(mix(mix(vec3(0.0),vec3(0.0,0.75,0.0),color),vec3(1.0),color),vec3(0.0,0.0,0.25),d);
	
	if(pos.x < 1.0/64.0 || pos.y < 1.0/64.0) color = vec3(1.0);
	


	return  vec3( color ); 
}

void main( void ) {

	c.x = 0.5+(sin(time*0.5)/4.0);
	vec2 p = ( gl_FragCoord.xy / resolution.xy );

	vec3 color = vec3(0.0);
	vec2 uv = vec2(0.0);
	
	float a = atan((p.x-c.x)/(p.y-c.y))+time*0.125;
	
	float d = sqrt((p.x-c.x)*(p.x-c.x)+(p.y-c.y)*(p.y-c.y));
	

	uv = vec2(mod(a*8.0,pi*2.0)/pi*0.5,mod(pow(d,-0.75)+time,1.0));
	
	color = shader(uv,vec2(pi*0.5,1.0))*(d*2.0);
	
	gl_FragColor = vec4( color, 1.0 ); 

}