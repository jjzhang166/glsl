
// Time distorsion WTF shader or windows7 loading screen
// @html5snippet on twitter 

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform sampler2D backBuffer;

float veclen(vec2 v)
{
	return sqrt(v.x * v.x + v.y * v.y);
}


void draw_sphere(vec3 p)
{
	vec2 center = resolution / 2.0;
	
	vec3 rgb = vec3(0.0, 0.0, 0.0);

	vec2 dist = (center + p.xy) - gl_FragCoord.xy;

	float radial = abs(sin(time/100.0)) * 700.0 * veclen(dist) * veclen(dist)  / (p.z + 1000.0);

	if (floor(veclen(dist)) < p.z)
	{
		rgb.r = p.x / radial;
		rgb.g = p.y / radial;
		rgb.b = p.z / radial;
		gl_FragColor += vec4(rgb.r, rgb.g, rgb.b, 1.0);
	}
}

void main( void )
{
	
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec4 bb = texture2D(backBuffer, position);
	
	float speed = 2.5;
	float t = time * speed + gl_FragCoord.x / 1000.0;

	draw_sphere(vec3(cos(t)*10.0, 0.0, cos(t+90.0)*10.0 + 20.0));
	draw_sphere(vec3(sin(t + 10.0)*10.0, 20.0, sin(t+90.0)*100.0 + 20.0));
	draw_sphere(vec3(cos(t + 20.0)*200.0, 40.0, cos(t+90.0)*10.0 + 20.0));
	draw_sphere(vec3(sin(t + 30.0)*105.0, 80.0, sin(t+90.0)*50.0 + 20.0));
	draw_sphere(vec3(cos(t + 40.0)*100.0, 100.0, cos(t+90.0)*50.0 + 20.0));
	draw_sphere(vec3(cos(t + 50.0)*100.0, 150.0, sin(t+90.0)*40.0 + 20.0));


	draw_sphere(vec3(cos(t+ 50.0)*200.0, sin(t+ 50.0)*150.0, sin(t+90.0)*10.0 + 20.0));
	draw_sphere(vec3(cos(t+ 300.0)*300.0, sin(t+ 100.0)*100.0, sin(t+90.0)*10.0 + 20.0));
	draw_sphere(vec3(cos(t+ 200.0)*100.0, sin(t+ 20.0)*100.0, cos(t+90.0)*10.0 + 20.0));
	draw_sphere(vec3(sin(t+ 50.0)*200.0, cos(t+ 50.0)*100.0, cos(t+90.0)*10.0 + 20.0));
	draw_sphere(vec3(cos(t+ 450.0)*100.0, sin(t+ 25.0)*200.0, sin(t+90.0)*10.0 + 20.0));
	draw_sphere(vec3(cos(t+ 50.0)*200.0, sin(t+ 50.0)*200.0, cos(t+90.0)*10.0 + 20.0));	
	
	gl_FragColor = gl_FragColor * 0.1 + bb * 0.9;
}
