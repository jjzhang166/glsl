#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

float dtl(vec2 pt1, vec2 pt2, vec2 testPt)
{
  	vec2 lineDir = pt2 - pt1;
  	vec2 perpDir = vec2(lineDir.y, -lineDir.x);
  	vec2 dirToPt1 = pt1 - testPt;
	return abs(dot(normalize(perpDir), dirToPt1));
}

vec3 lazer(vec2 pos, vec3 clr, float mult)
{
	vec3 color;
	float w = abs(sin(time*0.5))+0.5;

	vec2 mousepos = (mouse.xy * 2.0) - 1.0;
	color = clr * mult * w / dtl(vec2(0), mousepos, pos) * (distance(vec2(0), mousepos)/distance(vec2(0), pos)*0.3);

	return color;
}

void main()
{
	vec2 pos = ( gl_FragCoord.xy / resolution.xy * 2.0 ) - 1.0;
	//pos.x *= resolution.x / resolution.y;
	vec3 color = max(vec3(0.), lazer(pos, vec3(1.75, 0.2, 3.), 0.25));
	gl_FragColor = vec4(color * 0.05, 1.0);
}
