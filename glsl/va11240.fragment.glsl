#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sphereDist(float radius ,vec3 p)
{
    return length(p) - radius;	
}

void main( void ) {
	
	vec2 fragPos = (gl_FragCoord.xy / resolution.xy) - vec2(0.5,0.5);
	fragPos *= 1.2;
	fragPos.x *= resolution.x / resolution.y;
	
	float color = step(-0.5, fragPos.x) * (1.0-step(0.5, fragPos.x)) * step(-0.5, fragPos.y) * (1.0-step(0.5, fragPos.y));
	
	gl_FragColor = vec4( color, color , color, 1.0 );
}