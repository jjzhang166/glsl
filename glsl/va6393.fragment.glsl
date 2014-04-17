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
  vec2 tmp = pow(abs(v), vec2(n));		
  return pow(tmp.x+tmp.y,1.0/n);
}
 
float rings(vec2 p)
{
	
  vec2 p2 = mod(p*8.0, 4.0)-2.0;
  float r2 = 1.0-abs(sin(p.x*0.02+time*0.4));	
  float r3 = 4.0+(sin(time*0.4)*2.0);
  float p3 = sin(lengthN(p2, 1.0+r2*10.0)*r3);
  return pow(p3,0.25);
}
 
vec2 trans(vec2 p)
{
	vec2 p1;
	p1.x =sin(time*0.4);
	p1.y =cos(time*0.7);	
	
  float theta = atan(p.y+p1.y, p.x+p1.x);
  float r = length(p);
  return vec2(theta, r);
}


void main( void ) {

	vec2 pos1 = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
        vec2 pos2 = (gl_FragCoord.xy*2.0 -resolution) / resolution.y;
	pos2.x =pos2.x+sin(time*0.2)*0.5;
	pos2.y =pos2.y+cos(time*0.2)*0.5;		
	pos2 =pos2*(0.9+sin(time*0.6)*0.35);
	float h = gl_FragCoord.x / resolution.x;
	float s = 0.4;
	float v = rings(trans(pos2))*0.5 +0.25;
	
	h=sin(h*0.1+time*0.5)*0.5;
	
	gl_FragColor = vec4(HSV2RGB(vec3(h,s,v)),1.0);

}
