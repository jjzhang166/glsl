#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec4 color = vec4(0.627, 0.350, 0.937, 1.0);

void main(void)
{
	float aspectRatio = resolution.y / resolution.x;
	vec2 screenSpaceCoord = vec2((gl_FragCoord.x / resolution.x - 0.5), (gl_FragCoord.y / resolution.y - 0.5) * aspectRatio) * 2.0;
	
	float distanceOrigin = length(screenSpaceCoord);
	
	float exposure = pow(distanceOrigin, 1.0);
	vec3 rgb = color.xyz / exposure ;
	//float a = color.w * (1.0 - exposure);
	float a = 1.0;
	
	gl_FragColor = vec4(rgb, a);
} 
