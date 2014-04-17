// by @vividsnow
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float hash( float n )
{
    return fract(sin(n)*758.5453);
}

float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    float res = mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
    return res;
}

void main( void ) {

	vec2 q = gl_FragCoord.xy / resolution.xy + vec2(0,0.25);
        vec2 position = -1. + 2.0 * q;
    	position.x *= resolution.x/resolution.y;
	vec2 rc = (position.xy - vec2(0.5));
	float d = length(rc);
        float a = atan(rc.y, rc.x);
        gl_FragColor = vec4(
            1. - abs(pow(abs(sin(-time/2.)), 4.) - d), 
            abs(pow(abs(sin(-time/3.)), 4.) - d) * sin((a-sin(d*cos(time*(4.+d))))*16.)*(1.-abs(sin(time/4.5)/2.+0.5)/2.), 
            abs(sin((a-sin(d*sin(time))*8.)*2.+sin(time)*time*9.*(rc.x/8.+1.)*(d+1.)+time*8.*(rc.y/8.+1.)*(d+1.))), 
        1)
        * clamp(1. - d * (1.5+cos(time)/2.),0.,1.) 
        * vec4(vec3(noise(vec2(floor(d*(floor(fract(time/4.)*10.)+sin(time))*floor(a+fract(time)*(4.+sin(time)))),5.))/2. + 1.),1);
}