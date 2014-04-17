// plasma, by Piers Haken
// mrdoob: It didn't work on my gpu. seems like mod()'n the values is required?
// piersh: abs, not mod

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float p0 = 2.0;
float p1 = 3.9;
float p2 = 5.0;
float p3 = 93.0;

void main ()
{
	vec2 pos = (gl_FragCoord.xy / resolution.xy);

	float d0 = distance (pos, vec2(sin(time*.112), sin(time*.091)));
	float d1 = distance (pos, vec2(sin(time*.029), sin(time*.081)));
	float d2 = distance (pos, vec2(sin(time*.033), sin(time*.107)));
	float d3 = distance (pos, vec2(sin(time*.104), sin(time*.116)));
	float d4 = distance (pos, vec2(cos(time*.105), sin(time*.051)));
	float d5 = distance (pos, vec2(sin(time*.046), sin(time*.141)));
	float d6 = distance (pos, vec2(sin(time*.107), sin(time*.031)));
	float d7 = distance (pos, vec2(sin(time*.078), sin(time*.121)));

	float R = abs(+d0 +d1 +d2 +d3 -d4 -d5 -d6 -d7*.9);
	float G = abs(-d0 +d1 -d2 -d3 -d4 +d5 +d6*.9 +d7);
	float B = abs(-d0 +d1 -d2 +d3 +d4 +d5*.9 -d6 -d7);

	gl_FragColor = vec4(p0 - p1 * normalize (p2 + p3 * log (vec3 (R, G, B))), 1.0);
}