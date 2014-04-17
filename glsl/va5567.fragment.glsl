#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//http://actionsnippet.com/?p=1451
float aDiff(float angle0,float angle1)
{
    return abs(mod((angle0 + PI -  angle1),PI*2.) - PI);
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy);
	
	vec2 m = mouse*resolution;
	
	vec3 color = vec3(0.0);
	
	vec3 pln = vec3(p,256.);
	
	vec3 lp = vec3(resolution/2.,0.0);
	vec3 ap = vec3(m,64.);
	
	float ax = asin(distance(vec3(lp.xy,pln.z),pln)/distance(lp,pln));
	float ay = atan(p.y-lp.y,p.x-lp.x);
	
	float lax = asin(distance(vec3(lp.xy,ap.z),ap)/distance(lp,ap));
	float lay = atan(ap.y-lp.y,ap.x-lp.x);
	
	color = vec3(1.-distance( vec2(ax,ay) , vec2(lax,lay)));
	
	color = vec3(1.-sqrt(pow(aDiff(ax,lax),2.)+pow(aDiff(ay,lay),2.)));
	//color = vec3(ax,ay,0.);
	
	gl_FragColor = vec4( color, 1.0 );

}