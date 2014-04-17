#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float wave(){ return 1.; }



void main( void ) {

	vec2 	uv = ( gl_FragCoord.xy / resolution.xy );
	float 	xy = resolution.y/resolution.x;
	vec2 ratio = vec2(.5, xy*xy);
	uv *= ratio;
	vec2 m = mouse * ratio;
	
	
	float color = 1.0;
	

	float pos0 = length(uv-m);
	float neg0 = length(uv-m-vec2(0.25, 0.));
	
	float if0 = pos0;
	float if1 = neg0;
	
	if0 *= neg0;
	if1 *= pos0;
	float ifield = if0+if1;
	
	
	float wl0 = 20.0;
	float wl1 = -20.0;
	
	
	
	float t = time * .2;
	
	float f0 = 1.0-mod( abs( (t + 10.0)/ wl0 - pos0 )* wl0 , 1.0) * (1.0-sin(pos0));
	float f1 = 1.0-mod( abs( (t + 10.0)/ wl1 - neg0 )* wl1 , 1.0) * (1.0-sin(neg0));
	
	float field = abs((f0-f1)/(f0*f1))*.25;
	
	gl_FragColor = vec4(step(.3, (field*f0) / (ifield * f1)));
}