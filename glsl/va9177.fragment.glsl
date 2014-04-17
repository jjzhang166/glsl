#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

#define PI 3.1416

void main(void)
{
	vec2 p = (gl_FragCoord.xy) / resolution.xy;
	p.x += 0.38;
	p.y -= 0.41;
	vec2 center = vec2(0.5, 0.5);
	float d = distance(p, center);
	
		
	// bluish tint from top left
	vec3 color = vec3(1.0-d*0.75) * vec3(0.33, 0.35, 0.5);
	
	// tweak color near screen-center
	color += (1.0-distance(p, vec2(1.0, 0.0))*1.)*0.5 * vec3(0.65, 0.75, 0.85);
	
	vec3 lightColor = vec3(0.3, 0.45, 0.65);
	
	for (int i=0; i<5; i++) 
	{
		//direction of light
		float zr = (.2*float(i)) - 1.14;
		vec3 dir = vec3(.5, mix(sin(zr),-.45,.2), 0.0);
		
		// beam breakup
		p.x -= float(i) * 0.01;
		
		//normalized spotlight vector
		vec3 SpotDir = normalize(dir);
		
		//
		vec3 attenuation = vec3(0.5, 7.0, 10.0);
		float shadow = 1.0 / (attenuation.x + (attenuation.y*d) + (attenuation.z*d*d));

		vec3 pos = vec3(p, 0.0);
		vec3 delta = normalize(pos - vec3(center, 0.0));
		
		float cosOuterCone = cos(radians(0.4));
		float cosInnerCone = cos(radians(16.0 + float(i*2)));
		float cosDirection = dot(delta, SpotDir);
		
		//light...
		color += smoothstep(cosInnerCone, cosOuterCone, cosDirection) * shadow * lightColor;
	}
	color += sin(time*0.5)*0.1;
	gl_FragColor = vec4(vec3(color), 1.0);
}

  