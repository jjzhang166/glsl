// Something strange by Dima..
// Use your mouse to repulse red ball
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float r = 0.15, ds = 0.01, g = .006, dt = .5;
vec2 pos, vel, frag;
vec3 color;
void image();
void shift();
void read();
void write();

void main( void ) {

	frag = gl_FragCoord.xy / resolution.xy;
	
	read();
	shift();
	image();
	write();
	
	gl_FragColor.rgb = color;

}

void shift() {
	vel.y -= g * dt;
	vel.x = clamp ( vel.x , -.05 , .05 );
	vel.y = clamp ( vel.y , -.05 , .05 );
	pos = pos + ( vel * dt );;

	vec2 l = mouse - pos;
	l.x *= resolution.x / resolution.y;
	if ( length ( l ) < 2. * r ) {
		vel -= l * ( 1. - pow ( length ( l ) , 2.1 ) ) * .03;
	}
	
	if ( pos.x < r ) { pos.x =  r; vel.x = - vel.x; }
	if ( pos.x > 1. - r ) { pos.x = 1. - r;	vel.x = - vel.x; }
	if ( pos.y < r ) { pos.y = r; vel.y = - vel.y * 1.1; }
	if ( pos.y > 1. - r ) {	pos.y = 1. - r; vel.y = - vel.y; }
}

void image() {
	vec2 a = vec2 ( resolution.x / resolution.y , 1. );	
	float d = distance  ( frag * a , pos * a ); 
	if ( d < r )
		color.r += max ( 1. - pow ( d * 2. , .4 ) , .0 );
	color.rgb += vec3 (1.0 , .5 , .5) * pow ( max ( 1. - d , .0 ) , 10.2 );
	float dm = distance ( mouse * a , frag * a );
	if ( dm < r )
		color.rg += max ( 1. - pow ( dm * 6. , .2 * ( sin ( time * 5. + dm ) + 2. + dm ) * .5 ) , .0 );
	if ( mod ( frag.y + time * .04 , 0.02 ) < 0.01 )
		color.b += 0.05;
	else    color.r += 0.05;
	if ( mod ( frag.x + sin (time) * .004 , 0.05 ) < 0.03 )
		color.rg += 0.01;
}

void read() {
	pos = texture2D ( backbuffer , vec2 ( ds * 0.5 , ds * 0.5 ) ).gb;
	vel = texture2D ( backbuffer , vec2 ( ds * 1.5 , ds * 0.5 ) ).gb - .5;
	if ( pos.x < ds && pos.y < ds ) {
		pos = vec2 ( .5 );
		vel = vec2 ( .01 , .02 );
	}
}

void write() {
	if ( frag.y < ds ) {
		if ( frag.x < ds )
			color.gb = pos;
		else if ( frag.x < ds * 2. )
			color.gb = vel + .5;
		else color.gb = vec2 ( color.r );
	}
}