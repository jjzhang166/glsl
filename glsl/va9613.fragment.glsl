#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float random(vec4 seed)
{
	return fract(sin(dot(seed.xy ,vec2(12.9898,78.233)) + dot(seed.zw ,vec2(15.2472,93.2541))) * 43758.5453);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	float color = random(vec4(position.x, position.y, 304.3, 99.4));
	
	if (texture2D(backbuffer, position).g > 0.9){
		color += 0.01;
		gl_FragColor = vec4( color, color, color, 1.0 );
	} else {
		color = texture2D(backbuffer, position).g + 0.01;
		gl_FragColor = vec4(color,color,color, 1.0);
	}

}