#ifdef GL_ES
precision mediump float;
#endif

//Amiga Copper rulez forever!

uniform vec2 mouse;
uniform float random;

uniform float time;
uniform vec2 resolution;
float speed = 20.0;
float fps1 = 10.0;
float radius = 50.0;
float grid = 25.0;

vec2 pos( float move, float fps ){
	float steptime = floor(time * fps) / fps * speed / 20.0;
	vec2 s = vec2( sin(steptime) / 7.0 + 0.5 + move * ( radius * 4.0 / resolution.x ), cos(steptime) / 3.0 + 0.5 );
	return s * resolution;
}

void main( void ) {
	vec3 blueprint = vec3( 30.0 / 255.0, 144.0 / 255.0, 255.0 / 255.0 );
	vec3 white = vec3( 1.0, 1.0, 1.0 );
	vec4 color = vec4(1.0);
	
	// Get a value between -1.0 and 1.0 based on y coord 
	// Basically making bands
	float blue_val = gl_FragCoord.y *mouse.x/ 50.0;
	float red_val = gl_FragCoord.x *mouse.y/ 50.0;
	
	if( mod( gl_FragCoord.x, grid ) == grid - 0.5 || mod( gl_FragCoord.y, grid ) == grid - 0.5  )
		color = vec4(red_val,0.5,blue_val,1.0);
	
	float dist1 = dot( gl_FragCoord.xy - pos(-1.0,fps1), gl_FragCoord.xy - pos(-1.0, fps1) );
	radius *= radius;
	if (dist1 < radius)
		color = vec4(red_val,0.5,blue_val,1.0);
	
	gl_FragColor = color;	
}