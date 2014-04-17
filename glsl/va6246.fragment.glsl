// R.I.P. ATARI

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    co *= 1000.0;
    return fract(sin((co.x+co.y*1e3)*1e-3) * 1e5);
}

vec3 box(in vec2 p)
{
	if (abs(p.x) < 0.08 && abs(p.y) < 0.5)
		return vec3(1.0);
	return vec3(0.0); 
}
vec3 curve(in vec2 p) 
{
	p.x +=  smoothstep(0.0, 1.0, pow(clamp(-p.y, 0.0, 1.0), 1.2));
	if (p.x > -0.1*smoothstep(1.0, 1.5, 1.0-p.y) && p.x < 0.15 && abs(p.y) < 0.5)
		return vec3(1.0);
	return vec3(0.0); 
	
}



void main( void ) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 p = 2.0*(mod( uv, vec2(1.0 / 24.0) ) * 24.0) - 1.0;
	float aspect = resolution.x/resolution.y;
	p.x *= aspect; 
	uv.x *= aspect;
	vec3 color = vec3(0.0); 
	
	color = box(p) + curve(p+vec2(0.30,0.0)) + curve(vec2(-p.x,p.y)+vec2(+0.30, 0.0));  
	color = color+vec3(rand(vec2(floor(uv.x * 8.0), floor(uv.y * 16.0)))
			       , rand(vec2(floor(uv.x * 8.0 + 1.0), floor(uv.y * 16.0 + 1.0))),
			       rand(vec2(floor(uv.x * 8.0 + 2.0), floor(uv.y * 16.0 + 2.0))));
	
	gl_FragColor = vec4(color, 1.0); 
}