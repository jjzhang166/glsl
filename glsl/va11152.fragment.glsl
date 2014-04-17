//http://www1-c703.uibk.ac.at/mathematik/project/bildergalerie/gallery.html


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

#define ITER_MAX 128

float sphere(vec3 p, vec3 pSphere, float radius)
{
	return length(pSphere-p) - radius;
}
///herat: (x2+9/4y2+z2-1)^3 - x2z3-9/80y2z3=0
float heart(vec3 p, vec3 pHeart, float size) {
	vec3 d = p-pHeart;
	float x2 = d.x*d.x;
	float y2 = d.y*d.y;
	float z2 = d.z*d.z;
	float y3 = d.y*d.y*d.y;
	float dd = pow(x2+y2+z2-1.0, 3.0) - (x2+z2)*y3;
	//if (dd > 0.0) 	
	//dd = pow(dd,1./5.);
	//else			return 1.0;
	return dd - size;
}
float cube(vec3 p, vec3 pObj, float size) {
	
	vec3 d = p-pObj;
	float dd = pow(d.x,4.0)+pow(d.y,4.0)+pow(d.z,4.0);
	return pow(dd,1./4.)-size;
}
float scene(vec3 p, inout vec4 outColor)
{
	float d = 1000000.0;
	//d = min(d, sphere(p, vec3(sin(time)*5.0,0,cos(time)*5.0), 1.0));
	d = min(d, cube(p, vec3(-2.0,3.0,-10), 1.0));
	d = min(d, sphere(p, vec3(-2.0,0.0,-10), 1.0)); 
	d = min(d, heart(p, vec3(2.0,0.0,-10), 0.0)); //sphere marcher aint good enough to pick up the details of the heart?
	return d;
}
///raymarcher using spheres (distance fields), returns smallest distance
void rayMarchS(inout float dist, inout vec3 p, vec3 ray, inout vec4 outColor)
{
	for(int i = 0; i < ITER_MAX; i++)
	{
		dist = scene(p,outColor);
		p = p + dist * ray;
	}
}

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy ); //0,0 is bottom left corner
	pos = surfacePosition; //0,0 is in screen middle
	
	vec3 color;
	
	float dist;
	vec4 outColor;
	vec3 p;
	vec3 ray = vec3(pos.x, pos.y, -1.0);
	rayMarchS(dist, p, ray, outColor);
	vec3 vLight = vec3(sin(time)*5.0,0,cos(time)*5.0)-p;
	vec3 vCam = vec3(0,0,0)-p;
	float angle2LC = dot(normalize(vLight), normalize(vCam));
	if (abs(dist) <= 1.0) {
		color += fract(p*5.0);
		//color += vec3(sin(p.x*20.0)+sin(p.y*20.0)+sin(p.z*20.0));
		//color += vec3(1.0-dist,0,0);
		//color += normalize(vLight) * (pow(angle2LC+1.0,1.0));
	}
	
	
	gl_FragColor.xyz = color;
	gl_FragColor.w = 1.0;
}
