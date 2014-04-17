//Barycentric Interpolation
//http://classes.soe.ucsc.edu/cmps160/Fall10/resources/barycentricInterpolation.pdf
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float area(vec2 p1,vec2 p2,vec2 p3)
{
    float a = distance(p1,p2);
    float b = distance(p2,p3);
    float c = distance(p3,p1);
    float s = (a+b+c)/2.0;
    
    return sqrt(s*(s-a)*(s-b)*(s-c));
}

void main( void ) {

	vec2 p = gl_FragCoord.xy;

	vec3 color = vec3(0.0);
	
	vec2 r = resolution;
	
	vec2 m = mouse*resolution;
	
	vec2 p1 = vec2(m.x,m.y),
	     p2 = vec2(r*0.80),
	     p3 = vec2(r.x*0.75,r.y*0.125);
	
	float totalarea = area(p1,p2,p3);
	
	float area1 = area(p2,p3,p);
	float area2 = area(p3,p1,p);
	float area3 = area(p1,p2,p);
	
	float a = area1/totalarea;
	float b = area2/totalarea;
	float c = area3/totalarea;
			
	color = vec3(a,b,c);
		
	color *= vec3(1.-log(a+b+c)*128.);
	
	gl_FragColor = vec4(color, 1.0);

}