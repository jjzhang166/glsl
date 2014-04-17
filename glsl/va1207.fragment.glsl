#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// interfered with by @danbri - split the colour channels
float random(vec2 seed)
{
	return fract(sin(dot(seed, vec2(2.2, 5.3))) * 6523.4);
}

float dots(vec2 pos)
{
	return step(0.5, fract(pos.x * resolution.x / 100.0)) + step(0.5, fract(pos.y * resolution.y / 100.0));
}

vec2 distort0(vec2 pos)
{
	return pos;
}

vec2 distort1(vec2 pos)
{
	return vec2(sin(pos.y * 10.0 + (time)) * 0.05 + pos.x, sin(pos.x * 10.0 + (time)) * 0.05 + pos.y);
}

vec2 distort2(vec2 pos)
{
	return pos / (length(pos) + (sin(time) + 1.1));
}

void main( void )
{
	vec2 position = (gl_FragCoord.xy / resolution.xy - vec2(0.5)) * 2.0;
	vec3 hippy = vec3( 1. - dots(distort1(distort1(distort1(position.xy))))  , dots(distort2(distort2(position.xy - ( mouse.xy-.5)))) , dots(distort1(distort2(position.xy / mouse.xy))) );
        vec3 bw = vec3 ( dots(position.xy+ .05*time) );
	vec3 red = vec3 ( dots(distort0(position.xy)) , 0.,0. );
	gl_FragColor = vec4(  hippy * (bw  + red) , 1.0 );
}