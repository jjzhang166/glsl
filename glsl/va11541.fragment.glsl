// Help, Batman!

#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	float aspect = resolution.x / resolution.y;
	vec2 unipos = gl_FragCoord.xy / resolution;
	vec2 pos = unipos*2.0-1.0;
        vec3 clr;
	
	// from http://www.webpronews.com/google-search-takes-graphs-into-the-third-dimension-2012-03
	// I tried to GLSL'ify the batman equation; failed so far. First I dropped the ^2 notation and added '.' to all the ints, if we get 
	// past that, repairing the rest should be easy. Maybe better to break it out into smaller pieces?
	
	pos.x *= aspect;
	float x = float(pos.x);
       // float y = 2.*sqrt(-abs(abs(x)-1.)*abs(3.-abs(x))/((abs(x)-1.)*(3.-abs(x))))(1.+abs(abs(x)-3.)/(abs(x)-3.))sqrt(1.-(x/7.))+(5.+0.97(abs(x-.5)+abs(x+.5))-3.(abs(x-.75)+abs(x+.75)))(1.+abs(1.-abs(x))/(1.-abs(x))),-3.*sqrt(1.-(x/7.))sqrt(abs(abs(x)-4.)/(abs(x)-4.)),abs(x/2.)-0.0913722(x)-3.+sqrt(1.-(abs(abs(x)-2.)-1.) *1.0    ),(2.71052+(1.5-.5*abs(x))-1.35526+sqrt(4.-(abs(x)-1.)))sqrt(abs(abs(x)-1.)/(abs(x)-1.))+0.9;
	
	
        if (pos.x < .2) {
		
          clr = vec3(.0);
	} else {
	  clr = vec3(.3);
	}
	gl_FragColor = vec4(clr, 1.0);

}