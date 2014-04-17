#ifdef GL_ES
precision mediump float;
#endif

// Posted by Trisomie21

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define LAYERS 100.0

float rand(vec2 co){ return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); }

// From http://glsl.heroku.com/e#44.6
vec3 clover( float x, float y )
{
    float a = atan(x,y);
    float r = sqrt(x*x+y*y);
    float s = 0.5 + 0.5*sin(3.0*a + time);
    float g = sin(1.57+3.0*a+time);
    float d = 0.3 + 0.6*sqrt(s) + 0.15*g*g;
    float h = r/d;
    float f = 1.0-smoothstep( 0.95, 1.0, h );
    h *= 1.0-0.5*(1.0-h)*smoothstep(0.95+0.05*h,1.0,sin(3.0*a+time));
    return mix( vec3(0.0), vec3(0.4*h,0.2+0.3*h,0.0), f );
}
void main( void ) {
	
	float count = 4.0;
	vec3 color = vec3(0.0);
	
	vec2 pos = gl_FragCoord.xy - resolution.xy*.5;
	float dist = length(pos) / resolution.y;
	vec2 c = vec2(dist, atan(pos.x, pos.y) / (3.1416*2.0));
	
	for (float i = 0.0; i < LAYERS; ++i)
	{
		float t = i*10.0 + time*(1.0+i*i)*.1;
		
		vec2 uv = c*(1.0);
		
		uv.y += i*.025;
		uv.y = fract(uv.y);
		
		
		vec2 p = uv;
		
		p.x = pow(uv.x, .1) - (t*.01);
		p.y /= 2.0;
		
		float r = pow(uv.x, .1) - (t*.01);
		
		uv.x = mod(r, 0.01)/.01;
		uv.y = mod(uv.y, 0.02)/.02;
		
		vec3 co = clover(uv.x*2.0-1.0, uv.y*2.0-1.0);
	
		float m = fract(r*100.0)+i*.2;
		
		p = floor(p*100.0);
		float d = (rand(p)-0.5)*10.0;
		d = clamp(d*dist, 0.0, 2.0);
	
		color = max(color, co*m*d);
	}

	gl_FragColor =  vec4(color, 1.0 );
}