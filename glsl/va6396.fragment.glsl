#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 Hue( float hue )
{
	vec3 rgb = fract(hue + vec3(0.0,2.0/3.0,1.0/3.0));

	rgb = abs(rgb*2.0-1.0);
		
	return clamp(rgb*3.0-1.0,0.0,1.0);
}

vec3 HSV2RGB( vec3 hsv )
{
	return ((Hue(hsv.x)-1.0)*hsv.y+1.0) * hsv.z;
}

float lengthN(vec2 v, float n)
{
  vec2 tmp = pow(abs(v)*1., vec2(n));		
  return pow(tmp.x+tmp.y,1.0/n);
}
 
float rings(vec2 p)
{
	
  vec2 p2 = mod(p*8.0, 4.0)-2.0;
  float r2 = 1.0-abs(sin(p.y*2.62+time*2.4));	
  float r3 = 4.0+(sin(time*0.4)*2.0);
  float p3 = sin(lengthN(p2, 1.0+r2*3.0)*r3*r2);
  return pow(p3,pow(r2*p3,3.)*500.);
}
 
vec2 trans(vec2 p)
{
  float theta = atan(p.y, p.x);
  float r = length(p);
  return vec2(theta, r);
}
 

void main( void ) {

        vec2 pos2 = ((gl_FragCoord.xy*2.0 -resolution) / resolution.y)+ mouse / 2.0;
	pos2.x =pos2.x+sin(time*0.2)*0.5;
	pos2.y =pos2.y+cos(time*0.2)*0.5;		
	pos2 =pos2*(1.0+sin(time*0.6)*0.5);
	float h = gl_FragCoord.x / resolution.x;
	float s = 0.4;
	float v = rings(trans(pos2))*0.25 +0.75;
	
	h=sin(pos2.x*0.5+h*0.1+time*0.5)*0.5;
	
	gl_FragColor = vec4(HSV2RGB(vec3(h,s,v)),1.0);

}
