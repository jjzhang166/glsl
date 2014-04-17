#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rayIntersect(vec2 cOrigin, float cRadius, vec2 rStart, vec2 rEnd)
{
	vec2 cOrigNew = cOrigin - rStart;
	
	vec2 rDir = normalize(rEnd - rStart);
	
	float b = dot(cOrigNew, rDir);
	float c = cRadius * cRadius - dot(cOrigNew, cOrigNew);
	float a = dot(rDir, rDir);
	
	float invA = 1.0 / a;
	
	if((b * b + a * c) <= 0.0)
		return 0.0;
	
	float b4ac = sqrt(b*b + a * c);
	
	 float l1 = (b - b4ac) * invA;
	 float l2 = (b + b4ac) * invA;
	
	return l2 < 0.0 || dot(rDir, cOrigin - rEnd) > 0.0 ? 0.0 : pow(l2, 0.1);
	
	return 1.0;
	
	return 0.0;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 1.0;

	color *= 1.0 - rayIntersect(vec2(0.25, 0.25), 0.05, mouse, position);
	color *= 1.0 - rayIntersect(vec2(0.5, 0.25), 0.05, mouse, position);
	color *= 1.0 - rayIntersect(vec2(0.75, 0.25), 0.05, mouse, position);
	
	color *= 1.0 - rayIntersect(vec2(0.25, 0.5), 0.05, mouse, position);
	color *= 1.0 - rayIntersect(vec2(0.5, 0.5), 0.05, mouse, position);
	color *= 1.0 - rayIntersect(vec2(0.75, 0.5), 0.05, mouse, position);
	
	
	color *= 1.0 - rayIntersect(vec2(0.25, 0.75), 0.05, mouse, position);
	color *= 1.0 - rayIntersect(vec2(0.5, 0.75), 0.05, mouse, position);
	color *= 1.0 - rayIntersect(vec2(0.75, 0.75), 0.05, mouse, position);
	
	gl_FragColor = vec4(color, color, color, 9.0 );

}