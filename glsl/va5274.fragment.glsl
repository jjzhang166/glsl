#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform sampler2D bb;
uniform vec2 resolution;

// raindrops keep falling on my head

float rand(vec2 n) { return fract(sin(dot(n.xy, vec2(12.9898, 78.233))) * 43758.5453); }

void main( void ) {
	float scale = 20.0;
	vec2 p = -1.0 + ( gl_FragCoord.xy / resolution.xy ) * 2.0;
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 rm = (vec2(rand(vec2(sin(time),cos(time))),0.95) - 0.5) * 2.0 * scale;
	p.x *= 10.0*resolution.x / resolution.y;
	rm.x *= 10.0*resolution.x / resolution.y;
	
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
		color = texture2D(bb, vec2(uv.x, uv.y + 0.08)).x;
	}

	gl_FragColor = vec4( vec3( color - 0.08, color, color), 1.0 );

}