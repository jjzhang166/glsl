#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define M_PI 3.1415926535897932384626433832795
#define CAM_DIST 3.0
#define TUNNEL_RADIUS 8.0

void main( void ) {

	vec2 pos = (( gl_FragCoord.xy / resolution.xy )) - 0.5;
	pos -= (mouse - 0.5) * 0.3;
	
	float alpha = atan(pos.y, pos.x) + time;
	float sx = alpha;
	
	float d = sqrt(dot(pos, pos));
	float beta = atan(d / CAM_DIST);
	float sy = TUNNEL_RADIUS * (d/CAM_DIST) - (time * 0.3);
	
	float color;
	//color = mod(sx, 0.25) * 4.0 + cos(sy * 512.0);
	color = sin(20.0 * sx) * cos(sy*3.0) + sin(atan(sx + sy));
	color *= (sx / (sin(1.0 / sy * 2.0) + sin(sy*8.0) * 300.0) * 0.4);
	color = abs(color);
	//color = tan(color);
	
	color *= (beta * 4.0);
	color *= 16.0;
	gl_FragColor = vec4( vec3( color, color * (sin(time) + 0.5) * 0.5, sin( color  ) * tan(time) ), 1.0 );
}