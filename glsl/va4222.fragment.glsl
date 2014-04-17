// A naive way of plotting the solution of fn(p) = 0
// made by darkstalker (@wolfiestyle)
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

const float eps = .0001;

// the function to plot
float fn(vec2 p)
{
	vec2 p2 = p * p;
	return p2.y*(p2.y - .12) - p2.x*(p2.x - .2);
}

// approximate distance to the curve
float dist_fn(vec2 p)
{
	return abs(fn(p));
}

// gradient of dist_fn
vec2 gradient(vec2 p)
{
	float f = dist_fn(p);
	return vec2(
		(dist_fn(p + vec2(eps, 0)) - f) / eps,
		(dist_fn(p + vec2(0, eps)) - f) / eps
	);
}

void main( void )
{
	float max_v = length(gradient(surfacePosition)) * .0025;
	float val = smoothstep(max_v, 0., dist_fn(surfacePosition));
	vec2 axis = abs(surfacePosition);
	vec3 color = vec3(val) + vec3(axis.x < .002 , 0, axis.y < .002);
	gl_FragColor = vec4( color, 1.);
}