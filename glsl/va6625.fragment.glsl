#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi = 3.141592;
float tpi = 3.141592*2.0;
float hpi = 3.141592/2.0;

//flow map test

//from #6405.13
float Segment(vec2 P, vec2 P0, vec2 P1)
{
	vec2 v = P1 - P0;
	vec2 w = P - P0;
	float b = dot(w,v) / dot(v,v);
	v *= clamp(b, 0.0, 1.0);
	return distance(w,v);
}

vec3 flow(vec2 p)
{
	vec2 np = p*2.0-1.0;
	vec2 cmp = clamp(np,-0.25,0.25);
	
	float a = (atan(np.y-cmp.y,np.x-cmp.x)+pi);
	float r = distance(np,cmp);
	r = pow(r,0.125);
	
	return vec3(cos(a+hpi)*r,sin(a+hpi)*r,0.0);
}

vec3 flowvec(vec2 p0,vec2 dir,float len,vec2 p)
{
	vec2 end = p0+dir*len;
	float b = 1.-.5*Segment(p,p0,end)*resolution.x;
	b = clamp(b,0.0,1.0);
	return vec3(b);
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	
	vec3 color = vec3(0.0);
	
	vec2 f = flow(p).xy;
	
	color.x = f.x*0.5+0.5;
	color.y = f.y*0.5+0.5;
	color = clamp(color,0.0,1.0);
	
	color += flowvec(mouse,flow(mouse).xy,0.125,p);
	
	gl_FragColor = vec4( vec3( color ), 1.0 );

}