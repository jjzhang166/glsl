#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse; 
uniform vec2 resolution;

// @danbri learnings, move along nothing to see here people...

vec3 redDawn (in vec3 myRGB, in vec2 xy) {

	float r = .5 * ( 1. - xy.x ) + .2 * ( .9 - xy.y ) + (.5 * cos(time / 3.) - sin(time / 2.) ) ;

	myRGB.r = 1. - r * 2. ;
	myRGB.r = myRGB.r / 2.;
	vec3 myRGB2 = myRGB;
        return(myRGB2);
}

vec3 greenTop (in vec3 myRGB, in vec2 xy) {

	float t = xy.y;
	myRGB.g = t * cos(time * 1.5);
	vec3 myRGB2 = myRGB;
        return(myRGB2);
}


vec3 flipRed( in vec3 myRGB, in vec2 xy) { 
	if (xy.x < .15) { myRGB = vec3(.2,.1,.1) + myRGB; }
	if (xy.x < .4) { myRGB = vec3(.4,.1,.0) + myRGB; }
	if (      ( abs(xy.x - mouse.x) < .1)  && ( abs(xy.y - mouse.y)   < .1)    ) { myRGB.r = (xy.y-mouse.y); } 
	return myRGB;	
}


vec3 blueSlider (in vec3 myRGB) {
        return( vec3( .0, .0, sin(time) - myRGB.r) );	
}

void main( void ) {

	vec2 xy = gl_FragCoord.xy / resolution;
        vec3 myRGB = vec3(0.,0.,0.);
	

	myRGB.g = greenTop(myRGB, xy).g;
	myRGB.r = redDawn(myRGB, xy).r;
	myRGB.b = blueSlider(myRGB).b; 
	myRGB = flipRed(myRGB, xy);
	
	gl_FragColor = vec4( myRGB, 1.0 );

	
	
}