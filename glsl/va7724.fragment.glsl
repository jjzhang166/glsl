#ifdef GL_ES
precision mediump float;
#endif

//My attempt at a visualization of Pulse Width Modulation which this isn't yet
// ~Singularity

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float pi = 3.1415926535897932;

float lerp(float a, float b, float i)
{
	return a*(1.-i)+b*i;
}

float cerp(float a, float b, float i)
{
	float ii = .5-cos(i*3.14)/2.;
	return a*(1.-ii)+b*ii;
}

float saw(float rad)
{
	return lerp(1.,-1.,mod(rad/pi/2.,1.));
}
float tri(float rad)
{
	float modd = mod(rad/pi/2.+.25,1.);
	if(modd>.5)
		return lerp(1.,-1.,modd*2.-1.);
	else
		return lerp(-1.,1.,modd*2.);
}

float pwm = sin(time/10.)*pi/20.;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position.x*=2.;
	position.y -= .5;
	float pxnorm = mod(position.x,pwm);
	float tan1, tan2;
	tan1 = lerp(tri((position.x-pxnorm)*20.),sin((position.x-pxnorm)*20.),-20.); //Change this to different waves, such as sine, tangent, etc.
	tan2 = lerp(tri((position.x-pxnorm+pwm)*20.),sin((position.x-pxnorm+pwm)*20.),-20.); //Make this the same as above, or risk craziness with interpolation

	float color = 0.0;
	//Cosine interpolated
	//color += 1./distance(position.y*20.,cerp(tan1,tan2,pxnorm/pwm));
	//Linearly interpolated
	color += 1./distance(position.y*20.,lerp(tan1,tan2,pxnorm/pwm));
	//No interpolation
	//color += 1./distance(position.y*20.,tan1);
	
	gl_FragColor = vec4( vec3( cos(color+time/1.7), cos(color+time/1.1), sin( color + time ) ), 1.0 );

}