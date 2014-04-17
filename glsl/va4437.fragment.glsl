#ifdef GL_ES
precision mediump float;
#endif

// attempting to hypnotize the poor viewer, also backbuffer test for a friend =D - @dist

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;

float SCREENZOOM = 9.0;
float WIDTH = (cos(time)+1.0);
float RPM = 77.0;

vec3 blade(float blades, float zoom, float fade, float r_fact, float g_fact, float b_fact)
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	vec2 p1 = (gl_FragCoord.xy / resolution.xy - vec2(0.5,0.5));
	vec2 p2 = (gl_FragCoord.xy / resolution.xy - vec2(0.5,0.5)) * vec2(1.0, resolution.y/resolution.x) * SCREENZOOM;
	vec3 color = vec3(1.0);
	
	float dist = distance(p2, vec2(0.,0.)) + sin(atan(p2.y,p2.x)*blades+time*3.1415*2.*RPM/60.);
	if ((dist>1.0) || (dist<1.0-WIDTH)) {
		color = vec3(0.05);
	}else{
		color = vec3(1.00);
	}

	vec3 back = texture2D(bb, p1*zoom+vec2(0.5,0.5)).rgb*fade;
	color += back;
	float r = sin(gl_FragCoord.x*time*r_fact)*0.4+0.8;
	float g = sin(gl_FragCoord.y*time*g_fact)*0.4+0.8;
	float b = sin(time*g_fact)*0.4+0.8;
	return vec3(r,g,b) * color;
}

void main()
{
	vec3 rgb;
	rgb += blade(
		mod(time, 5.0),
		0.95 + sin(time)*2.0,
		0.60 + sin(time)*0.2,
		3.1, 2.2, 2.4);
	rgb += blade(3.33, 0.9, 0.5, 3.0, 1.2, 1.2);
	rgb += blade(11.0, 0.9, 0.5, 1.0, 3.2, 1.2);
	rgb += blade(15.0, 0.9, 0.5, 1.0, 1.2, 3.2);
	gl_FragColor = vec4(rgb/4., 1.0);
}