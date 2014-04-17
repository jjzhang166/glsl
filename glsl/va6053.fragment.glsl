#ifdef GL_ES
precision mediump float;
#endif

/** underwater intro by matt deslauriers / mattdesl */

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

#define PI 3.1416

vec3 dir(vec3 pos, float rotation) {
	
	return vec3(0.0);	
}

void main(void)
{
	vec2 p = (gl_FragCoord.xy) / resolution.xy;
	p.x += 0.55;
	p.y -= 0.55;
	vec2 center = vec2(0.5, 0.5);
	float d = distance(p, center);

	
	//vec3 color = vec3(0.3, 0.3, 0.4);
	vec3 color = vec3(1.0-d*0.75) * vec3(0.33, 0.35, 0.5);
	
	vec3 lightColor = vec3(0.3, 0.45, 0.65);
	//p.y -= 0.5;
	//p.x += 0.5;

	//will be better as uniforms
	for (int i=0; i<3; i++) {
		//direction of light
		float zr = sin(time*0.45*float(i))*0.5 - PI/4.0;
		vec3 dir = vec3(cos(zr), sin(zr), 0.0);
		
		//normalized spotlight vector
		vec3 SpotDir = normalize(dir);
		
		//
		vec3 attenuation = vec3(0.5, 7.0, 10.0);
		float shadow = 1.0 / (attenuation.x + (attenuation.y*d) + (attenuation.z*d*d));

		vec3 pos = vec3(p, 0.0);
		vec3 delta = normalize(pos - vec3(center, 0.0));
		
		float cosOuterCone = cos(radians(1.0));
		float cosInnerCone = cos(radians(25.0));
		float cosDirection = dot(delta, SpotDir);
		
		//light...
		color += smoothstep(cosInnerCone, cosOuterCone, cosDirection) * shadow * lightColor;
	}
	
	gl_FragColor = vec4(vec3(color), 1.0);
}

  