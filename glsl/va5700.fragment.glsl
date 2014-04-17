#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

#define PI 3.1416

vec3 color(float d) {
	return d * vec3(0, 1, 0);	
}

void main(void)
{
	vec2 p = ((gl_FragCoord.xy) / resolution.xy);
	float aspect = resolution.x / resolution.y;
	vec2 center = vec2(0.5, 0.5);
	
	//ugly code! needs to be cleaned up
	
	vec3 lightColor = vec3(0.8, 0.4, 0.6);
	
	float Angle = degrees(atan(mouse.y-center.x, mouse.x-center.y));
	float Azimuth =  0.0;
	float zr = radians(Angle);
	float yr = radians(Azimuth);
	vec3 dir = vec3(-sin(yr));
	float a = cos(yr);
	dir.x = a * cos(zr);
	dir.y = a * sin(zr);
	vec3 SpotDir = normalize(dir);
	
	float d = distance(p, center);
	vec3 attenuation = vec3(0.5, 10.0, 100.0);
	float shadow = 1.0 / (attenuation.x + (attenuation.y*d) + (attenuation.z*d*d));
	
	float s = clamp(sin(time*2.0)/2.0+0.5, 0.75, 1.0);

	vec3 delta = normalize(vec3(p, 0.0) - vec3(center, 0.0));
	
  	float cosOuterCone = cos(radians(10.0));
	float cosInnerCone = cos(radians(55.0));
  	float cosDirection = dot(delta, SpotDir);
		
	//float cone = max(0.0, (cosDirection-cosCone) / (1.0-cosCone));
	
	float len = 1.0 - length(p-0.5);
	vec3 color = vec3(smoothstep(cosInnerCone, cosOuterCone, cosDirection) * shadow * lightColor);
	
	/*
	vec3 delta = normalize(vec3(mouse, 0.0) - vec3(p, 0.0));
	float cosCone = cos(radians(45.0));
	float cone = -dot(delta, vec3(s, 0.0, 1.0));
	cone = max(0.0, (cone-cosCone) / (1.0-cosCone));
	*/
	
	gl_FragColor = vec4(vec3(color), 1.0);
}

  