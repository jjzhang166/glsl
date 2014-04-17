#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main()
{
	vec3 test;
	vec2 position = (gl_FragCoord.xy-resolution.xy/2.0) / resolution.yy; /// ttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt
	
	vec2 p = position * 10.;
	float len = sqrt(p.x*p.x+p.y*p.y*1.0);

	float ang = 10.0*atan(p.y,(len+p.x));
	ang += pow(len, 1.0)*3.0;
	
	float f = ang + -time*3.141592*1.0;
	float r = 1.0 - sin(f);
	float g = max( 1.0 - cos(f) , 1.0 + cos(f) );
	float b = 1.0 + sin(f);
	vec3 color = vec3(r, g, b);

	color /= 2.;

	float ds = len/100.;
	color *= (1.1-ds);
	
	//color = 1.-sqrt(1.2-color); // while coding
	
	gl_FragColor = vec4( log( color * 1.0 ) * 8.0 , 1.0 );

}