#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D tex;

void main( void ) 
{
	vec2 pixelPos = gl_FragCoord.xy / resolution.xy;
	vec3 color = vec3(0.0, 0.0, 0.0);
	vec2 mousePos = resolution.xy * mouse;
	float modifier = mousePos.x / resolution.x;
	
	modifier += mousePos.y / resolution.y;
	modifier += mousePos.x / resolution.y;
	modifier /= 2.0;
	modifier += 0.05;

	color.r += floor(mod(gl_FragCoord.x, 15.0)) / 15.0;
	color.g += floor(mod(gl_FragCoord.y, 15.0)) / 15.0;
	color.b += floor(mod(gl_FragCoord.x + gl_FragCoord.y, 15.0)) / 15.0;
	color *= vec3(0.25 + 0.4 * sqrt(sin(time)), 0.50 + 0.2 * sqrt(cos(time)), 0.75 + 0.1 * sqrt(cos(time)));
	color *= modifier;
	
	modifier = distance(mousePos, gl_FragCoord.xy);
	modifier = clamp(modifier, 0.0, 200.0);
	modifier = -modifier / 200.0;
	color +=  modifier;
	
	
	gl_FragColor = vec4(color, 1.0);
}