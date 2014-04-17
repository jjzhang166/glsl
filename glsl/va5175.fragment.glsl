#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Shabby - the one line basic maze doin' the rounds in a frag shader, a very nice bit of creative coding 

void main( void ) 
{
	float xtime=mod(floor(time*20.0),1300.0);
	vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	pos.y=1.0-pos.y;
	pos.x*=3.0;
	float or=(pos.x*1.0/0.05)+(floor(pos.y*1.0/0.05)*60.0);
	vec3 colour = vec3(0.22,0.18,0.61);
	pos=mod(pos,0.05);
	float r=(floor((sin(cos(tan(floor(or)))*12.0)+1.0)));
	pos.x=((1.0-r)*-pos.x)+(r*pos.x);
	if (xtime>or && (abs(r*0.05-pos.x-pos.y)<0.01))	colour=vec3(0.47,0.43,0.83);
	gl_FragColor = vec4( colour, 1.0 );

}