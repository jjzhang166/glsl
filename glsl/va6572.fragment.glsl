#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float RADIUS = 0.75;
const float SOFTNESS = 0.45;
const vec3 SEPIA = vec3(1.2, 1.0, 0.8);

const vec3 COLOR_1 = vec3(1.0, 0.0, 0.0);
const vec3 COLOR_2 = vec3(1.0, 1.0, 0.0);
const float SIZE = 64.0;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - vec2(0.5);
	float len = length(position);
	
	float vignette = smoothstep(RADIUS, RADIUS - SOFTNESS, len);
	vec2 p = floor(position / SIZE );
	vec3 color = (mod(p.x + p.y, 2.0) > 0.5) ? COLOR_1 : COLOR_2;
	color = mix(color.rgb, color * vec3(vignette), 0.5);
	
	//gl_FragColor = vec4(vec3(len),1.0);
	gl_FragColor = vec4(color,1.0);
}