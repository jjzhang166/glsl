#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;

const float AURA_INNER = 0.0;
const float AURA_OUTER = 0.45;

void main( void ) {

	vec2 position = (gl_FragCoord.xy / resolution.xy) - mouse;
	position.x *= resolution.x/resolution.y;
	
	//sample the texture here
	vec4 texColor = vec4(1.0, 0.5, 0.5, 1.0); 
	
	//get length from mouse position
	float d = length(position);
	
	//smooth the result based on our desired radius
	d = smoothstep(AURA_OUTER, AURA_INNER, d);
	
	//desaturate the texture color
	float L = dot(texColor.rgb, vec3(0.299, 0.587, 0.114));
	
	//lerp saturated with desaturated
	texColor.rgb = mix(texColor.rgb, vec3(L), d);
	
	gl_FragColor = texColor;

}