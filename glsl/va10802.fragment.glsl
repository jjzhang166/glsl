// Pong Shader
//   by Nick Hogle
//   May, 2013
//   glsl@nickhogle.com
//   http://nickhogle.com
//
// Description:
//   Pong! (Need I say more? ;)
//
// Version History:
//   v1.1 September 2, 2013
//      Made paddle motion a little more "snappy"
//   v1.0 May 2013:
//      https://glsl.heroku.com/e#8551.0
//      Initial Release 


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float ball_radius = 0.02;
const float paddle_w = 0.02;
const float paddle_h = 0.15;
const vec2 period = vec2( 3.55, 4.27 );
const vec2 padding = vec2( 0.08, 0 );
const float pi = 3.14159265359;

float aspect = resolution.x / resolution.y;
vec2 arena = vec2( aspect, 1.0 );

float rect( vec2 x, vec2 a, vec2 b ) {
	return
		step(a.x, x.x) * (1.0 - step(b.x, x.x)) *
		step(a.y, x.y) * (1.0 - step(b.y, x.y));
}

float circle( vec2 position, vec2 center, float radius ) {
	return 1.0 - smoothstep( radius*0.95, radius, length(position-center) );
}

float paddle( vec2 p, vec2 pad_pos ) {
	vec2 a = pad_pos - vec2(paddle_w, paddle_h)/2.0;
	vec2 b = pad_pos + vec2(paddle_w, paddle_h)/2.0;
	return rect( p, a, b );
}

vec2 ball_pos( float time ) {
	vec2 ball = vec2(
		abs( mod(4.0*time/period.x + 2.0, 4.0) - 2.0 ) * 0.5,
	    abs( mod(4.0*time/period.y + 2.0, 4.0) - 2.0 ) * 0.5
	);
	return padding + vec2(ball_radius) + ball*(arena-(padding+vec2(ball_radius))*2.0);
}

float ease_fn( float t ) {
	float b = 0.0;
	float d = 1.0;
	float c = 1.0;
	float p = d * 0.4;
	float a = 1.3;
	
	if (( t /= d ) >= 1.0 )
		return b + c;

	float s = p / (2.0*pi) * asin(c/a);
	
	if (a < abs(c)) {
		a = c;
		s = p/4.0;
	}

	return a * pow(4.0, -8.0*t) * sin((t*d - s) * (2.0*pi) / p) + 1.0 + b;
}

vec2 paddle_pos( float time, float track_period, bool left ) {
	float time_offset = left ? 0.0 : period.x/2.0;
	time -= time_offset;
	float x = left ? padding.x : aspect - padding.x;

	int count = int( time / period.x );
	float prog = mod( time, period.x ) /  period.x;
	float o = 0.0;

	float y = ball_pos( float(count)*period.x + time_offset ).y;
	if (prog > 1.0-track_period) {
		o = ( prog-(1.0-track_period))/track_period;
	}

	y = mix( y, ball_pos( float(count+1)*period.x + time_offset ).y, ease_fn(o) );
	return vec2( x, y );
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.y );
	vec2 ball = ball_pos( time );

	float color = 0.0;
	color += circle( position, ball, ball_radius );
	color += paddle( position, paddle_pos( time, 0.25, true ) );
	color += paddle( position, paddle_pos( time, 0.25, false ) );

	gl_FragColor = vec4( color );
}
