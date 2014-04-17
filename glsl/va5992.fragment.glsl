// Stella by JvB. 

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float ear(vec2 p, vec2 c, float r)
{
	p -= c; 
	r = (r - sin(p.y)+sin(-p.x-0.5*p.y)*0.2); 
	if (length(p) < 1.0*r)
		return 1.0; 
	return 0.0; 
}
float head_circle(vec2 p, vec2 c, float r)
{
	float px = abs(p.x - c.x)*(1.0 + 0.1*p.y);
	float py = abs(p.y - c.y);
	float d = pow(pow(px,4.0) + pow(py,4.0), 1.0/4.0); 
	if (d < r) 
		return 1.0;
	return 0.0; 
}
float circle(vec2 p, vec2 c, float r)
{
	if (length(p - c) < r) 
		return 1.0;
	return 0.0; 
}


void main( void ) 
{

	float aspect = resolution.x/resolution.y; 
	vec2 p = 2.0 * ( gl_FragCoord.xy / resolution.xy ) - 1.0;
	p.x *= aspect; 
	
	
	vec3 color = vec3(0); 
	

	p.y *= 1.2;
	color += circle(p-vec2(0,-0.60), vec2(+0.0,+0.0), 0.30)*vec3(0.05,0.05,0.05);
	color += circle(p-vec2(-0.25,-0.50+sin(time*2.0)*0.05), vec2(+0.0,+0.0), 0.10)*vec3(0.91,0.91,0.91);
	color += circle(p-vec2(+0.25,-0.50), vec2(+0.0,+0.0), 0.10)*vec3(0.91,0.91,0.91);
	color += circle(p*vec2(1.0,1.5)-vec2(-0.25,-1.20), vec2(+0.0,+0.0), 0.20)*vec3(0.91,0.91,0.91);
	color += circle(p*vec2(1.0,1.5)-vec2(+0.25,-1.20), vec2(+0.0,+0.0), 0.20)*vec3(0.91,0.91,0.91);


	#if 1
	p.y += sin(time*2.2)*0.005; 
	if (length(color) < 0.0001 || abs(color.x)==0.71) {
		color = head_circle(p*vec2(1.0,1.25)+vec2(0.0,-0.07), vec2(0,0), 0.5)*vec3(0.01); 
		color += circle(p*vec2(2.0,8.0)-vec2(0,0), vec2(+0.0,-2.65), 0.30)*vec3(0.71,0.01,0.01);
		color += circle(p, vec2(-0.28,+0.0), 0.1)*vec3(1.0,1.0,0.0);
		color -= circle(p, vec2(-0.28,+0.0), 0.085)*vec3(1.0,1.0,0.0);
		color += circle(p, vec2(+0.28,+0.0), 0.1)*vec3(1.0,1.0,0.0);
		color -= circle(p, vec2(+0.28,+0.0), 0.085)*vec3(1.0,1.0,0.0);
		color += circle(p*vec2(2.0,5.0), vec2(+0.0,-0.45), 0.1)*vec3(0.3,0.3,0.3);

		color += ear(p*vec2(3.1,4.3)+vec2(0.75,0), vec2(0,2.5), 0.1)*vec3(0.01,0.01,0.01); 
		color += ear(p*vec2(-3.1,4.3)+vec2(0.75,0), vec2(0,2.5), 0.1)*vec3(0.01,0.01,0.01); 
	}
	#endif

	if (length(color) <.00001)
		color = vec3(0.5); 
	gl_FragColor = vec4(color, 1.0); 
}