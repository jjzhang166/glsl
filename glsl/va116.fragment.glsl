// forked from http://glsl.heroku.com/37/4 by @Flexi23

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D buf;

float rand(vec2 co){
    return fract(sin(dot(co.xy + time ,vec2(12.9898,78.233))) * 43758.5453);
}

vec4 blur(vec2 p) {
	vec2 d = 1.0 / resolution + rand(p) * 0.005;
	p = p + vec2(sin(time * 0.3), sin(time * 0.7)) * d;
	return (texture2D(buf, p - vec2(d.x,0)) + texture2D(buf, p - vec2(-d.x,0)) + texture2D(buf, p - vec2(0,d.y)) + texture2D(buf, p - vec2(0,-d.y))) * 0.25;
}

const float R = 0.02;
vec4 C = vec4(0.5 + 0.5 * sin(time), 0.5 + 0.5 * cos(time * 0.3), 0.5 + 0.5 * sin(time * 0.4), 1.);
float brush(vec2 p) {
	vec2 d = p - mouse;
	float r = R + (sin(5. * (time + atan(d.y, d.x))) * 0.005);
	return clamp(r - length(d), 0., r) / r;
}

void main( void ) {
        vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1./resolution;

	gl_FragColor = vec4(0.);

	float b = brush(position);
	gl_FragColor = C * b;
	gl_FragColor += (texture2D(buf, position) + blur(position)) * 0.5 * (1. - b);
}