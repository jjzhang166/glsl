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

//using code adapted from http://graphicsrunner.blogspot.ca/2010/08/water-using-flow-maps.html

bool flowmap = false; //set to true to show the flow map.

vec3 flow(vec2 p)
{
	vec2 np = p*2.0-1.0;
	vec2 cmp = clamp(np,-0.25,0.25);
	
	float a = (atan(np.y-cmp.y,np.x-cmp.x)+pi);
	float r = distance(np,cmp);
	r = pow(r,0.25);
	
	return vec3(cos(a+hpi)*r,sin(a+hpi)*r,0.0);
}

mat2 m = mat2( 0.90,  0.110, -0.70,  1.00 );

float hash( float n )
{
    return fract(sin(n)*758.5453);
}

float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);
    float n = p.x + p.y*57.0 + p.z*800.0;
    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
		    mix(mix( hash(n+800.0), hash(n+801.0),f.x), mix( hash(n+857.0), hash(n+858.0),f.x),f.y),f.z);
    return res;
}

float fbm( vec3 p )
{
    float f = 0.0;
    f += 0.50000*noise( p ); p = p*2.02;
    f += 0.25000*noise( p ); p = p*2.03;
    f += 0.12500*noise( p ); p = p*2.01;
    f += 0.06250*noise( p ); p = p*2.04;
    f += 0.03125*noise( p );
    return f/0.984375;
}

float Cycle = .65;
float HalfCycle = Cycle * .5;
float FlowSpeed = 0.75;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	
	vec3 color = vec3(0.0);
	
	vec2 f = flow(p).xy;
	
	float offset0 = mod(time*FlowSpeed,Cycle);
	float offset1 = mod(time*FlowSpeed+HalfCycle,Cycle);
	
	float cycleOffset = fbm(vec3(p*4.0,0.25));
	
	float phase0 = cycleOffset * .5 + offset0;
	float phase1 = cycleOffset * .5 + offset1;
	float flowLerp = ( abs( HalfCycle - offset0 ) / HalfCycle );
	
	vec3 cyc1 = vec3(fbm(vec3(((p*8.0)+f*phase0),1.0))); 
	vec3 cyc2 = vec3(fbm(vec3(((p*8.0)+f*phase1),1.0)));
	
	color = mix(cyc1,cyc2,flowLerp);
	
	if(flowmap)
	{
		color.x = f.x*0.5+0.5;
		color.y = f.y*0.5+0.5;
		color.z = 0.0;
		color = clamp(color,0.0,1.0);
	}

	
	gl_FragColor = vec4( vec3( color ), 1.0 );

}