#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
const float radius = 120.0;
const float PI = 3.14159;
const float RIM_BASE_WIDTH = 10.0;

vec3 calcColor(vec2 pos, vec2 center)
{
	vec2 line = pos - center;
	float dist = length(line);
	float diameter = (PI * 2.0 * radius);
	float sinL = line.y / length(line);
	float angle = asin(sinL);
	float arc = angle / (2.0 * PI) * diameter;
	float bump = arc / (diameter / 15.0);
	float sinArc1 = sin(2.0 * PI * bump + 3.0 * time);
	float rim1Width1 = RIM_BASE_WIDTH * sinArc1;
	float sinArc2 = pow((2.0 * PI * bump + 10. - 2.0 * time), .1);
	float rim1Width2 = RIM_BASE_WIDTH * (sinArc2 + 1.5);
	float sinArc3 = pow(tan(2.0 * PI * bump + 20. + 1.0 * time), 0.4);
	float rim1Width3 = RIM_BASE_WIDTH * (sinArc3 + 2.0);
	
	float lum1 = pow(dist / (radius + rim1Width1), 1.0);
	float lum2 = pow(dist / (radius + rim1Width1 + rim1Width2), 50.0);
	float lum3 = pow(dist / (radius + rim1Width1 + rim1Width2 + rim1Width3), 50.0);
	
	if (dist <= radius + rim1Width1) return vec3(0.5 * lum1,lum1,lum1);
	else if (dist <= radius + rim1Width1 + rim1Width2) return vec3(1.0,0,0);
	else if (dist <= radius + rim1Width1 + rim1Width2 + rim1Width3) return vec3(lum3,lum3,1);
	return vec3(0);
}

void main( void ) {
	vec3 color = vec3(0, 0, 0);
	vec2 pos = gl_FragCoord.xy;
	vec2 center = vec2(resolution.x * 0.5, resolution.y * 0.5);
	color = calcColor(pos, center);
	gl_FragColor = vec4(color, 1);
}
