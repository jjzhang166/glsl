// rotwang: @mod* shader
// @mod+ blink

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
	vec2 p = pos - c;
	
	float a = atan((p.x)/(p.y))+time*0.25;
	float d = length(p);
	float blink = step(fract(time*0.5),0.15);
	blink -= sin(time)*0.5+0.5;
	float dx = 0.25;
	float sx = 0.01;
	float mx = smoothstep( dx-sx, dx+sx, pos.x) ;
	
	float dy = 0.5;
	float sy = 0.01;
	float my = smoothstep( dy-sy, dy+sy, pos.y);
	
	vec3 clr_blink = vec3(0.99, 0.66, 0.2) * blink;
	vec3 color = mix(vec3(0.0,0.0,d), vec3(0.33), mx) * mix(vec3(0.3, 0.2, d+d), clr_blink, my) * 3.0-d;
	
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