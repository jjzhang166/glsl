#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//No ray marching
//~MrOMGWTF

void main( void ) {
	float h = sin(time);
	h *= 0.34;
	vec2 position = ( gl_FragCoord.xy / resolution.xy * 2.0 - 1.0);
	position.x *= resolution.x / resolution.y;
	float z= 1.0 / (position.y - h);
	if(position.y > h)
	{
		gl_FragColor = (vec4(mix(vec3(0.0, 0.20, 0.1), vec3(0.0, 0.5, 1.0), position.y -h ) + vec3(
			max(0.0, max(1.0, 1.0 / (length(position + vec2(0.0, -h - 0.75))))) * 0.3 * vec3(1.0, 0.8, 0.3)), 1.0));	
	}
	else
	{
		gl_FragColor = vec4(vec3(0.3, 0.7, 0.1) / (-z) + vec3(0.0, 0.3, 0.7) * 0.01, 1.0);
	}
	
	gl_FragColor *= 1.0 - length(position * 0.45);
	gl_FragColor = pow(gl_FragColor, vec4(1.0 / 2.2));
}