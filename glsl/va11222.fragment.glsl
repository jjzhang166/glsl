#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
const float radius = 100.0;
const float fadeWidth = 30.0;

vec3 calcColor(vec2 pos, vec2 center, float waveOffset, float t)
{
	float dist = length(center - pos);
	if(dist > radius) return vec3(0, 0, 0); // Don't set a pixel color if not in range
	
	float x = t + waveOffset;
	float lum = (sin(x) + sin(1.5 * + 10.0) + sin(2.0 * x + 19.0) + sin(0.5 * x + 5.0) + 2.0) / 5.0;

	float edge = 1.0;
	float distFromEdge = radius - dist;
	if (distFromEdge < fadeWidth)
	{
		edge = distFromEdge / fadeWidth;
		edge *= edge;
	}
	
	float colorShift = (sin(x) + 1.0) / 2.0;
	float colorShift2 = (sin(x * 3.0) + 1.0) / 2.0;
	
	vec3 color = vec3(1.0 * lum * edge * colorShift, 1.0 * lum * edge * colorShift2, 1.0 * lum * edge);
	return color;
}

void main( void ) {
	vec3 color = vec3(0, 0, 0);
	vec2 pos = gl_FragCoord.xy;
	vec2 centers[3];
	centers[0] = vec2(resolution.x * 0.5, resolution.y * 0.75);
	centers[1] = vec2(resolution.x * 0.25, resolution.y * 0.25);
	centers[2] = vec2(resolution.x * 0.75, resolution.y * 0.25);
	float waveOffset[3];
	waveOffset[0] = 0.0;
	waveOffset[1] = 5.0;
	waveOffset[2] = 10.0;
	
	vec3 color1 = calcColor(pos, centers[0], waveOffset[0], time);
	vec3 color2 = calcColor(pos, centers[1], waveOffset[1], time);
	vec3 color3 = calcColor(pos, centers[2], waveOffset[2], time);
	color = color1 + color2 + color3;
	
	gl_FragColor = vec4(color, 1);
}
