#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//Mouse over the rectangles at the bottom

vec3 effect0(vec2 p)
{
	p = p/resolution;
	
	float d = distance(p,vec2(0.5));
	
	float a = atan(p.x-0.5,p.y-0.5);
	
	float color = sin(1.0-d*PI*((sin(a*32.0+time)+1.0)*0.5));
	
	return vec3(color);
}

vec3 effect1(vec2 p)
{
	p = p/resolution;
	
	float color = sin((p.x+sin(p.y*PI+time))*PI)*sin(p.x*PI*64.0);
	
	return vec3(color);
}

vec3 effect2(vec2 p)
{
	p = p/resolution;
	
	float color = abs(fract((p.x+p.y)*8.0)-0.5)*2.0;
	
	return vec3(color);
}

vec3 effect3(vec2 p)
{
	p = p/resolution;
	
	p = p-0.5;
	
	float d = distance(p,vec2(0.5));
	
	float a = atan(p.x,p.y);
	
	float color = sin((a+sin(d+time))*2.0);
	
	return vec3(color);
}

bool inRect(vec2 p,vec4 bt)
{
	return (p.x >= bt.x &&  p.y >= bt.y && p.x <= bt.z &&  p.y <= bt.w);
}

void main( void ) 
{

	vec2 p = ( gl_FragCoord.xy );
	vec2 m = mouse*resolution;

	vec3 color = effect0(p);
	
	
	
	if(inRect(m,vec4(0,0,64,32)))
	{
		color = effect1(p);
	}
	
	if(inRect(m,vec4(64,0,128,32)))
	{
		color = effect2(p);
	}
	
	if(inRect(m,vec4(128,0,192,32)))
	{
		color = effect3(p);
	}
	
	if(inRect(p,vec4(0,0,64,32))) color = vec3(1,0,0);
	if(inRect(p,vec4(64,0,128,32))) color = vec3(0,1,0);
	if(inRect(p,vec4(128,0,192,32))) color = vec3(0,0,1);
	
	gl_FragColor = vec4( color , 1.0 );

}