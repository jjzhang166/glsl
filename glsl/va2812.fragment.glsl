// a simple sphere raytracer for educational purposes
// hellfire/haujobb

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

// position and radius of the 3 spheres
vec4 sphere[3];

// colors of the 3 spheres
vec3 colors[3];
		  
// position and color of the light sources
vec3 lightpos[2];
vec3 lightcol[2];


void main(void)
{
   float aspect= resolution.x / resolution.y;
   vec3 p= vec3(
	   (gl_FragCoord.x*2.0/resolution.x-1.0)*aspect,
	   (gl_FragCoord.y*2.0/resolution.y-1.0),
	   -1.0 );
   vec3 d= normalize(p);


   gl_FragColor=vec4(0,0,0,1); //background color
}
