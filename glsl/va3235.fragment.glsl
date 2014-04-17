#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.1415926535;
const float TWOPI = PI*2.0;



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
	float loglen = log(len);
	
	float ra = invlen;
	ra = smoothstep(0.0,0.05, abs(angle*0.125 + (angle*0.125*unsint)));
	float shade = 1.0*ra;
	float rb = smoothstep(0.0,0.25, -pos.y);
	shade *= rb;
	gl_FragColor = vec4(shade,shade,shade, 1.0 );

}