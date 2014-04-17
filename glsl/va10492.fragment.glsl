

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;

float dist(vec2 a,vec2 b)
{
	float x=a.x-b.x;
	float y=a.y-b.y;
	return pow(x*x+y*y,0.5);
}

vec4 d2i(float r,float d)
{
  float intensity=pow(r/d, 2.0);
  vec4 color = vec4(1.0,1.0,1.0,1.0);
  return color*intensity;
}

void main( void )
{
     vec2 a=vec2(0.5*resolution.x,0.5*resolution.y);
     vec2 b=vec2(mouse.x*resolution.x,mouse.y*resolution.y);
     vec2 p=gl_FragCoord.xy;

     float ab=dist(a,b);
     float ap=dist(a,p);
	float bp=dist(b,p);

	float l= ap>bp ? ap:bp;
	
  	 float s=(ab+ap+bp)*0.5;
	 float t=pow(s*(s-ab)*(s-ap)*(s-bp),0.5);
        float h=(t*2.0)/ab;

	 float d=pow(l*l-h*h,0.5)-ab*0.5;
	
     gl_FragColor =d2i(1.0,d);
}
