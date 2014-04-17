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

float ease(float t, float b, float c, float d) {
	t /= d;
	t--;
	return -c * (t * t * t * t - 1.0) + b;
}
void main( void ) 
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float w = (position.x - (mouse.x)) * (resolution.x / resolution.y);
	float h = position.y - mouse.y;
	vec2 dir = normalize(vec2(w, h));
	float distMouse = sqrt(w * w + h * h);
	float tmp = ease(distMouse, 0.0, 20.0, 0.3);
	
		
	float noi = noise(vec3(position.xy * 30.0 + dir * tmp, time * 150.0));
	gl_FragColor = vec4(noi, noi, 0.0, noi);
}