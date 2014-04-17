#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main()
{
					vec3 test;
	vec2 position = (gl_FragCoord.xy-resolution.xy/2.0) / resolution.y; /// ttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt
	
	vec2 p = position / 800.;
	float len = sqrt(p.x*p.x+p.y*p.y*2.0);

	float ang = atan(p.x,(len+p.x));
	ang += pow(len, time)*1.0;
	
	float f = p.x - ang + -time*3.141592*2.0;
	float r = 1.0 - sin(f);
	float g = 1.0 - cos(f);
	float b = 1.0 + sin(f);
	vec3 color = vec3(r, b, g);

	color /= 2.;

	float ds = len/1000.;
	color *= (1.0-ds);
	
	//color = 1.-sqrt(1.2-color); // while coding
	
	gl_FragColor = vec4( color, 1.0 );

}