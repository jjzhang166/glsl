#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.14159;
const float TWO_PI = 2.0 * PI;
const vec4 MainColor = vec4(0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 0.0);

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	// relative to center
	vec2 toCenter = position - vec2(0.5);
	float distToCenter = length( toCenter );
	// get the angle to the current frag
	float angle = acos(dot(toCenter, vec2(1.0, 0.0)) / distToCenter);

	float posAngle = ceil(clamp(toCenter.y, 0.0, 1.0));
	float negAngle = ceil(clamp(-toCenter.y, 0.0, 1.0));
	angle = (posAngle * angle) + (negAngle * (TWO_PI - angle));
	
	// ellipse coords
	float x = 0.3 * cos(angle);
	float y = 0.3 * sin(angle);
	vec2 ellipsePoint = vec2(0.5 + x, 0.5 + y);
	
	float intensity = 0.0;
	
	// edge
	float distToEllipseEdge = length(position - ellipsePoint);
	float lineIntensity = ceil(clamp(0.001 - distToEllipseEdge, 0.0, 1.0));
	intensity += lineIntensity * ((0.0000 + (0.001 - distToEllipseEdge)) / 0.001);
	
	// fill
	float d = length(ellipsePoint - vec2(0.5));
	float fillIntensity = ceil(clamp(d - distToCenter, 0.0, 1.0));
	intensity += fillIntensity * (1.0 - clamp((0.1 + (d - distToCenter)) * 5.0, 0.0, 1.0));

	// color mix
	gl_FragColor = mix(MainColor, vec4(1.0), intensity);
}
