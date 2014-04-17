#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform sampler2D bb;
uniform vec2 resolution;

//I don't know what is it and i don't want to know.

float rand(vec2 n) { return fract(sin(dot(n.xy, vec2(12.9898, 78.233))) * 43758.5453); }

void main( void ) {
	float scale = 20.0;
	vec2 p = -1.0 + ( gl_FragCoord.xy / resolution.xy ) * 2.0;
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 rm = (vec2(sin(time)*.5+.5,1.) - 0.5) * 2.0 * scale;
	vec2 rm2 = (vec2(sin(time+3.14159)*.5+.5,1.) - 0.5) * 2.0 * scale;
	p.x *= resolution.x / resolution.y;
	rm.x *= resolution.x / resolution.y;
	rm2.x *= resolution.x / resolution.y;
	
	p *= scale;
	float color = 0.0;
	float dist = distance(rm, p);
	float dist2 = distance(rm2, p);
	if(dist < 2.0 || dist2 < 2.0)
	{
		color = 1.0;
	}
	else
	{
		vec2 np = p;
		color = texture2D(bb, vec2(uv.x, uv.y + 0.01)).x;
	}

	gl_FragColor = vec4( vec3( color - 0.01, color - 0.1, color), 1.0 );

}