// by rotwang

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.1415926535;
const float TWOPI = PI*2.0;

float curve_112(vec2 p, float f)
{
	f *=p.y + 1.0- abs(p.y);
	p.x *= f;
	float r = max(min( cos(p.x*PI), 0.5),0.0);
	return r;
}

void main( void ) {

	float speed = time*0.5;
	float aspect = resolution.x /resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
	vec2 pos = unipos*2.0-1.0;
	pos.x *=aspect;
    
	float sint = sin(speed);
	float unsint = sint*0.5+0.5;
	float cost = cos(speed);	
	float angle = atan(pos.y/pos.x);

	angle /= TWOPI;
	
	float len = length(pos);
	float invlen = 1.0-len;
	
	float shade = curve_112(pos, 8.0);
	
	
	gl_FragColor = vec4(shade,shade,shade, 1.0 );

}