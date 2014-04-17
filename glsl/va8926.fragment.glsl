#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0 + 113.0*p.z;

    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                        mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
                    mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                        mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
    return res;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / 50.0) + mouse / 4.0;
	position.x += time;

	float color = 0.0;
	color += noise(vec3(position.x, sin(position.x) + cos(position.y), position.y));
	position *= 2.0;
	color += noise(vec3(position.x, sin(position.x) + cos(position.y), position.y));
	position *= 2.0;
	color += noise(vec3(position.x, sin(position.x) + cos(position.y), position.y));
	position *= 2.0;
	color += noise(vec3(position.x, sin(position.x) + cos(position.y), position.y));
	color *= 0.25;
	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}