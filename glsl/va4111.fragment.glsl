#ifdef GL_ES
precision mediump float;
#endif

#define ITERATIONS 20

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

bool intersect(vec3 rayPos, vec3 rayDir, bool flip, out vec3 normal) {
	float ra = time;
	vec3 center = vec3(0.5, 0.5, -2);
	
	mat3 rot = mat3(1.0, 0.0, 0.0,
			0.0, cos(ra), -sin(ra),
			0.0, sin(ra), cos(ra)
		        );
	
	vec3 dist = (center - rayPos) * rot;
	
	if (flip) {
		dist.x *= -1.0;
	}
	
	vec2 dir = dist.xz;
	
	float a = atan(dir.y, dir.x);
	float r = abs(sin(a * 1.0 + time)) * 0.2 + 0.1;
	normal = normalize(center - rayPos);
	
	return length(dist) < r;
}

void main( void ) {
	vec2 position = gl_FragCoord.xy / resolution.xy;

	vec3 lightPos = vec3(0.8, 0.8, 0.0);
	
	vec3 rayPos = vec3(position, 0);
	vec3 rayDir = vec3(0, 0, -0.1);
	int i = 0;
	
	for (int i = 0; i < ITERATIONS; i++) {
		vec3 normal;
		vec3 color;
		
		bool found = false;
		if (intersect(rayPos, rayDir, true, normal)) {
			color = vec3(1.0, 1.0, 1.0);
			found = true;
		} else if (intersect(rayPos, rayDir, false, normal)) {
			color = vec3(1.0, 0.0, 0.0);
			found = true;
		}
		
		if (found) {
			vec3 lightDir = rayPos - lightPos;
			float lambertTerm = dot(normal, lightDir);
	
			if(lambertTerm > 0.0)
			{				
				gl_FragColor = vec4(color * lambertTerm, 1.0);
			}
			
			break;
		}
		rayPos += rayDir;
	}
}