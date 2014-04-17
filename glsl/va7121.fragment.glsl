#ifdef GL_ES
precision mediump float;
#endif
//basic star texture as found in "Texturing and Modeling: a Procedural Approach" pg 47-48
//with spin added to slightly reduce potent boringness
uniform vec2 resolution;
uniform float time;
float PI = 3.14159265;
vec3 starcolor = vec3 (1.0,0.5161,0.0);
vec3 backcolor = vec3 (.0,.0,.125);
float npoints = 5.;
float sctr = .5;
float tctr = .25;
float rmin = 0.07;
float rmax = 0.2;
float starangle = 2. * PI / npoints;
vec2 p0 = rmax * vec2(cos(0.),sin(0.));
vec2 pi = rmin * vec2(cos(starangle/2.0), sin(starangle/2.0));
vec2 d0 = pi - p0;


void main( void ) 
{	
	vec2 pos = ( gl_FragCoord.xy / resolution.x);
	float ss = pos.x - sctr;	
	float tt = pos.y - tctr;
	
	float angle = atan(ss, tt) + time * .25;
	
	float r = sqrt(ss*ss + tt*tt);
	float a = mod(angle, starangle) / starangle;
	if (a >= .5) a = 1.0 - a;
	vec2 d1 = r * vec2(cos(a), sin(a)) - p0;
	float f = step (0.0, cross(vec3(d0,0.0),vec3(d1,0.0)).z);
	vec3 color = mix(backcolor, starcolor, f);
	
	gl_FragColor = vec4( color, 1.0 );
}