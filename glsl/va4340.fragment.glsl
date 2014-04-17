//Dr.Zoidberg
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float noise(vec2 v);
float interpolate(vec2 p);

float interpolate(vec2 p)
{
	vec2 v0 = floor(p); 
	vec2 v1 = floor(p.xy + vec2(1.0,0.0));
	vec2 v2 = floor(p.xy + vec2(0.0,1.0));
	vec2 v3 = floor(p.xy + vec2(1.0,1.0));
	float fv0 = noise(v0);
	float fv1 = noise(v1);
	float fv2 = noise(v2);
	float fv3 = noise(v3);
	
		
	return 1.0*(fv0+(fv1-fv0)*(p.x-v0.x)+(fv2-fv0)*(p.y-v0.y)+(fv0-fv1-fv2+fv3)*(p.x-v0.x)*(p.y-v0.y));
	
}
float noise(vec2 v)
{
	return fract(sin(v.x-v.y)*0.12 + 14.3 - cos(v.y) + cos(v.x*0.1500) + v.x+v.y);//0.5*floor(sin(2.0*3.14159265358979*v.y)+1.0) + 0.5*floor(sin(2.0*3.1415926538979*v.x)+1.0);	
}


void main( void ) {
	vec2 p = gl_FragCoord.xy / resolution.y;
	vec3 color = vec3(0.0,0.0,0.0);
	p.y -= 0.5;
	p.x -= (resolution.x / resolution.y) * 0.5;
	p *=70.0;
	float fx = (interpolate(0.35*p-time) + interpolate(0.5*p+time) + 3.5*interpolate(0.1*p+mouse*30.0))/3.0;	
	color = vec3(fx*0.7,fx*0.7*(0.5+((sin(time*0.5)+1.0) / 2.0)),0.8*fx);

	gl_FragColor = vec4(color,1.0);
}