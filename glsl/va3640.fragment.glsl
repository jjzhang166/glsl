// rotwang: more tests for Krysler(2012)
#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
const float PI = 3.1415926535;

float Krysler_255(vec2 p)
{
	float x = abs(p.x) *PI;
	float shade = sqrt(1.0-x*x*x) * sin(x);

	return shade*0.5;
}



void main(void)
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    p.x *= resolution.x / resolution.y;

	float a = Krysler_255(p);
	float b = sin(p.y*p.y)*8.0;
	
	float shy = abs(p.y);
	float mask = step(p.y,0.0);
	shy *= mask;

	
	float shade_a = a-b + pow(p.y, 0.5);
	float shade_b = a+b * pow(p.y, 4.0)*shy;
	
	
	vec3 clr_a = vec3(shade_a*0.2, shade_a*0.65, shade_a*0.99);
	vec3 clr_b = vec3(shade_b*0.99, shade_b*0.65, shade_b*0.2);
	
	vec3 clr = mix(clr_a, clr_b, 0.5);
    gl_FragColor = vec4(clr,1.0);
}