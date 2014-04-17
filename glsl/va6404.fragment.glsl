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

vec3 waves( vec2 uv )
{

	vec3 tp; 
	tp.z = sin (cos(uv.x*20.)+ (time*1.5+uv.y*12.) );
	tp.z=pow(1.-tp.z,pow(.9+sin(time)*8.5,1.5));
	tp.x = sin (cos(tp.z)*.5);
	tp.x=pow(tp.x,.125);
	return tp;
}

void main( void ) {

	vec2 pos= ( gl_FragCoord.xy / resolution.xy ) + mouse / 2.0;

	vec3 wv=+waves(pos);
	
	float h = wv.x*.5+(gl_FragCoord.x / resolution.x)*0.8;
	float s = 0.3;
	float v = 0.4+wv.z*0.4;
	
	gl_FragColor = vec4(HSV2RGB(vec3(h,s,v)),1.0);

}