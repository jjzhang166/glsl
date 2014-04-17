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

vec3 HSV2RGB( vec3 hsv ) { return ((Hue(hsv.x)-1.0)*hsv.y+1.0) * hsv.z; }

vec2 trans(vec2 p)
{
  float theta = atan(p.y, p.x);
  float r = length(p);
  return vec2(theta, 0.2/r);
}

vec3 waves( vec2 uv,vec2 uv2 )
{

  float r = 1.0-length(uv2);
	vec3 tp; 
	tp.z = sin (cos(time*3.+uv.x*30.+uv.x*99.)+cos(time*9.+uv.x*20.)+ (time*11.5+uv.y*12.) );
	tp.z = pow(abs(1.-tp.z),pow(.9+sin(time*6.)*8.9,0.4));
	tp.y = 1.0-pow(r,9.35); 
	tp.x = sin (cos(tp.z)*.5);
	tp.x = pow(tp.x,.125);
	return tp;
}

void main( void ) {

	vec2 pos= ( gl_FragCoord.xy / resolution.xy )-vec2(.5,.5) ;

	vec3 wv = waves(trans(pos),pos);
	
	float h = time*.1+wv.x*.5+(gl_FragCoord.x / resolution.x)*0.125;
	float s = 0.3;
	float v = ((0.6+wv.z*0.5)*wv.y)+((1.-wv.y)*1.4);
	
	gl_FragColor = vec4(HSV2RGB(vec3(h,s,v)),1.0);

}