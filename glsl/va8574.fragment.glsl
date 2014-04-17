#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 bgW = vec4(.6,.6,.9,1.);
vec4 bgE = vec4(.3,.2,.3,1.);

vec4 sunN = vec4(1.,1.,1.,1.);
vec4 sunS = vec4(.9,.3,.9,1.);

vec4 ground1 = vec4(1.,.8,.2,1.);
vec4 ground2 = vec4(1.,.8,.2,1.);


vec4 nightColor = vec4(-2.,-2.,-.2,1.);
vec4 dayColor = vec4(-2.,-.1,-.2,1.);


float hash( float n ) {
	return fract(sin(n)*43758.5453);
}

float noise( in vec2 x ) {
	vec2 p = floor(x);
	vec2 f = fract(x);
    	f = f*f*(3.0-2.0*f);
    	float n = p.x + p.y*57.0;
    	float res = mix(mix(hash(n+0.0), hash(n+1.0),f.x), mix(hash(n+57.0), hash(n+58.0),f.x),f.y);
    	return res;
}

float cloud(vec2 p) {
	float f = 0.0;
    	f += 0.50000*noise(p*1.0); 
    	f += 0.25000*noise(p*2.0); 
    	f += 0.12500*noise(p*4.0); 
    	f += 0.06250*noise(p*8.0);
	return f;
}

vec4 addCircle(vec4 color, vec4 backColor, vec2 center, float size, float smoothness)
{
	vec2 fragPos = ( gl_FragCoord.xy / resolution.xy );
	vec2 vDist = center - fragPos;
	vDist.y /= (resolution.x/resolution.y);
	float d = length(vDist);

	if( d > size/2. )
		return backColor;
	
	d /= size/2.;
	d = 1. - d;
	d = pow(d,1./smoothness);
	
	vec4 outColor = mix(color,backColor,1.-d);
	
	return outColor;	
}

void main( void ) 
{
	float WE = mouse.x;
	float SN = mouse.y;

	vec4 background = mix(bgW,bgE,WE);
	vec4 sun = mix(sunS,sunN,SN);
	float sunSize = SN * .4;
	vec4 ground = mix(ground1,ground2, WE);
	vec4 clouds = vec4(cloud(vec2(gl_FragCoord.x,gl_FragCoord.y*7.)/time));
	
	vec4 o = background;
	o += clouds;
	o = addCircle(sun, o, mouse, sunSize, 2.);
	o = addCircle(ground, o, vec2(.5,-1.7), 2.5, 33.);
	o = addCircle(ground*.7, o, vec2(1.-mouse.x,-mouse.y/2.-1.7), 2.5, 5.);
	
	o += mix(-o*.98,o*.0,SN);
	
	gl_FragColor = o; 
}	