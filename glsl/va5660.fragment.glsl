#ifdef GL_ES
precision mediump float;
#endif

// Just a little faked perspective. ~Singularity

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 SUN_1 = vec3(1.,0.494,0.);
vec3 SUN_2 = vec3(0.753,0.749,0.678);
vec3 SUN_3 = vec3(1.,0.25,0.1);
vec3 SUN_4 = vec3(0.25,0.5,1.);
const float ssamount = 2.; //This is the supersampling factor. It renders the scene this many times squared to get rid of moire and general aliasing.
const float mblur = 1.; //Not really worth using. It renders everything this many times to provide motion blur.


float sigmoid(float x) {
	return 0.1/(1. + exp2(-x/4.)) + .9;
}
float sqr(float a) {
	return a*a;
}


void main( void ) {
	vec3 color = vec3(0.);
	vec2 aspect = vec2(1.,resolution.y/resolution.x );
	for(float blur = 0.; blur < mblur; blur += 1.)
	{
	float timed = blur/mblur/4.+float(time)*5.;
	for(float x = 0.; x < ssamount; x+=1.)
	for(float y = 0.; y < ssamount; y+=1.)
	{
	vec2 position = gl_FragCoord.xy+vec2(x/ssamount,y/ssamount);
	position /= resolution;
	position -= 0.5;
	/*vec2 position2 = 0.5 + (position-0.5)/resolution*3.;
	float filter = sigmoid(pow(2.1,7.5)*(length((position/resolution-mouse + 0.5)*aspect) - 0.015))*0.5 +0.5;
	position -= (mouse-0.5)*resolution;
	position = mix(position, position2, filter) - 0.5;*/
	position.x+=1.;
	position.x*=2.;

	
	float angle = atan(position.y,position.x);
	float d = length(position);
	
	color += 0.1/length(vec2(.04,2.*position.y*sqr(position.x)-pow(sin(pow(position.x,3.)*2.5-timed),.5)))*SUN_1; // I'm sure there's an easier way to do this, this just happened to look nice and blurry.
	color += 0.1/length(vec2(.04,2.*position.y*sqr(position.x)+pow(sin(pow(position.x,3.)*2.5-timed),.5)))*SUN_1;
	//color += 0.1/length(vec2(.04,2.*position.y+cos(position.x*10.+timed*4.)))*SUN_2;
	//color += 0.1/length(vec2(.01,1.*position.y+sin(position.x*16.+timed)*sin(position.y*16.+time*position.x*position.y/240.)))*SUN_3;
	color += 0.1/length(vec2(.01,.5*position.y*sqr(position.x)+sin(pow(position.x,3.)*8.+sqr(position.x)*32.+timed)*sin(position.y*sqr(position.x)*16.+sin(timed/8.))))*SUN_3;
	color += 0.1/length(vec2(.01,2.*position.y*sqr(position.x)+sin(pow(position.x,3.)*2.+sqr(position.x)*8.+timed*4.)))*SUN_4;
	}}
	gl_FragColor = vec4(color/sqr(ssamount)/mblur, 1.0);
	//gl_FragColor = vec4(filter<1.);
}