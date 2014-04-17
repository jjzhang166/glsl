#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main()
{
	vec2 position = (gl_FragCoord.xy-resolution.xy/2.0) / resolution.yy;
	
	vec2 p = position * 800.;
	float len = sqrt(p.x*p.x+p.y*p.y*2.0);

	float ang = 2.0*atan(p.y,(len+p.x));
	ang += pow(len, 0.5)*1.0;
	
	float f = ang + -time*3.141592*2.0;
	float r = 1.0 - sin(f);
	float g = 1.0 - cos(f);
	float b = 1.0 + sin(f);
	vec3 color = vec3(r, g, b);

	color /= 2.;

	float ds = len/1000.;
	color *= (1.0-ds);
	
	//color = 1.-sqrt(1.2-color); // while coding
	
	gl_FragColor = vec4( color, 1.0 );

}