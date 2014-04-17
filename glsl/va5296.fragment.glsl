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
	vec2 rm = (mouse - 0.5) * 2.0 * scale;
	p.x *= resolution.x / resolution.y;
	rm.x *= resolution.x / resolution.y;
	
	p *= scale;
	float color = 0.0;
	float dist = distance(rm, p);
	if(dist < 2.0)
	{
		color = 1.0;
	}
	else
	{
		vec2 np = p;
		color = texture2D(bb, vec2(uv.x+ sin(uv.y*3.02+0.2*time)*.05, uv.y + sin(uv.x*3.02+time)* .05)).x;
	}

	gl_FragColor = vec4( vec3( color - 0.05, color - 0.5, color), 1.0 );

}