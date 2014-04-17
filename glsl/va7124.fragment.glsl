#ifdef GL_ES
precision mediump float;
#endif
//basic cloud texture as found in "Texturing and Modeling: a Procedural Approach" pg 50
//scaled to fit screen and scrolled
uniform vec2 resolution;
uniform float time;
float PI = 3.14159265;
float halfPI = PI /2.;
const int NTERMS = 5;
vec3 cloudcolor = vec3 (1.0);
vec3 backcolor = vec3 (.0,.0,.125);
float scale = 50.0;
float offset = .5;
float xoffset = 3.0;
float yoffset = 9.6;

float xphase = .9;
float yphase = .7;

float xfreq = 2. * PI * .023;
float yfreq = 2. * PI * .021;
float amplitude = .3;


void main( void ) 
{	
	vec2 pos = ( gl_FragCoord.xy / resolution.x);
	pos *= scale;
	pos.x += xoffset * sin(time);
	pos.y += yoffset * time;
	float f = 0.0;
	for (int i=0; i < NTERMS; i++)
	{
		float fx = amplitude * (offset + cos(xfreq * (pos.x + xphase)));
		float fy = amplitude * (offset + cos(yfreq * (pos.y + yphase)));
		f += fx * fy;
		xphase = halfPI * .9 * cos(yfreq * pos.y);
		yphase = halfPI * 1.1 * cos(xfreq * pos.x);
		
		xfreq *= 1.9 + float(i) * .1;
		yfreq *= 2.2 - float(i) * .08;
		amplitude *= .707;
	}
	f = clamp(f, 0.0, 1.0);
	vec3 color = mix(backcolor, cloudcolor, f);
	
	gl_FragColor = vec4( color, 1.0 );
}