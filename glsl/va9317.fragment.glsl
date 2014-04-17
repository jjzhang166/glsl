// fuck that shit.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main()
{
	vec2 position2 = gl_FragCoord.xy / resolution.xy - vec2(0.5, 0.5);
	position2 *= resolution.xy/(sin(time*1.0)*5.0+90.0);

	float angle1 = time*sin(time*0.001) + 0.00;
	float angle2 = time*cos(time*0.005) + 0.04;
	float angle3 = time*0.05 + 0.08;
	vec2 d1 = vec2(cos(angle1), sin(angle1+sin(time)*0.2));
	vec2 d2 = vec2(cos(angle2), sin(angle2));
	vec2 d3 = vec2(cos(angle3), sin(angle3-sin(time)*0.2));

	float rr = cos(dot(position2, d1));
	float gg = cos(dot(position2, d2));
	float bb = cos(dot(position2, d3));

	float r = length(position+sin(time*sin(time*0.005)*0.2)*1.2);
	float a = atan(position.y, position.x);
	float t = time + 1.0/(r+1.0);
	
	float light = 9.0*abs(0.05*(sin(t)+sin(time+a*25.0)));
	vec3 color = vec3(-sin(r*5.0-a-time+sin(r+t)), sin(r*3.0+a-time+sin(r+t)), cos(r+a*2.0+a+time)-sin(r+t));

	color.r *= sin(time)*0.5+0.5;
	color.g *= 0.5;
	color.b *= abs(cos(time*2.0)*0.5);
	
	vec3 fcolor = vec3(((color)+0.69) * light);
	fcolor.r *= 0.9;
	fcolor.g *= 0.3;
	fcolor.b *= 0.8;

	fcolor *= mod(gl_FragCoord.y, 2.0);
	
	fcolor *= vec3(rr, gg, bb)*2.0;
	fcolor = vec3(fcolor.r+fcolor.g, fcolor.r, fcolor.r*1.5);
	gl_FragColor = vec4(fcolor, 1.0);
}