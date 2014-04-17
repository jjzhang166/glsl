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

float sq(vec2 p)
{
	vec2 p2 = floor(p*5.)*0.2;
	p2 = mod(p2*8.0, 4.0)-2.0;
	p2.x = 0.2+sin(p2.x*2.)*p2.x;	
	p2.y = 0.2+cos(p2.y*2.)*p2.y;
	float r2 = (p2.x*p2.y);	
	return r2;
}

void main( void ) {

        vec2 pos2 = ((gl_FragCoord.xy*2.0 -resolution) / resolution.y)-vec2(.5,.5);
	pos2 = vec2(
		cos(time) * pos2.x - sin(time) * pos2.y, 
		sin(time) * pos2.x + cos(time) * pos2.y);
		
	pos2.x = pos2.x+sin(time*0.15)*1.5;
	pos2.y = pos2.y+cos(time*0.1)*1.5;		
	pos2 = pos2*abs(1.0+sin(time*0.24)*1.1);
	pos2 = floor(pos2*6.0)*0.5;

	float s = 0.1;
	float v = sq(pos2)*0.15 +0.80;
	float h = (gl_FragCoord.x / resolution.x);
	
	h = sin(pos2.x*0.25+h*0.1+time*0.25+v*0.5);
	
	gl_FragColor = vec4(HSV2RGB(vec3(h,s,v)),1.0);
}