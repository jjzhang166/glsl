#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

mat2 m = mat2( 0.80,  0.60, -0.60,  0.80 );

//HDR Lighting
//MrOMGWTF

float point(vec2 p, vec2 p2)
{
	return pow(1.0 / (distance(p, p2)) * 0.02, 0.75);	
}

float bokeh(vec2 p, float r, float smooth)
{
	vec2 q = abs(p);
	float d = dot(q, vec2(0.866024,  0.5));
	float s = max(d, q.y) - r;
	return smoothstep(smooth, -smooth, s);
}
float hash( float n )
{
    return fract(sin(n)*43758.5453);
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
float fbm( vec2 p )
{
    	float f = 0.0;
	float t = time * 0.2;
    	f += 0.50000*noise( p -t); p = m*p*2.02;
    	f += 0.25000*noise( p +t); p = m*p*2.03;
    	f += 0.12500*noise( p +t); p = m*p*2.01;
    	f += 0.06250*noise( p -t); p = m*p*2.04;
    	f += 0.03125*noise( p +t);
    	return f/0.984375;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position.x *= resolution.x / resolution.y;
	vec3 color = vec3(0.0, 1.2 - length(vec2(position.x - 1.0, position.y + 0.1) * 0.7), 1.0);
	
	vec2 sun = vec2(1.15, 0.7);
	float x = min(1.0, 1.0 / length(sun - position) * 0.05);
	
	
	
	vec3 clouds = vec3((max(0.0, fbm(vec2(position.x * 0.5, position.y) * 2.0) - 0.5) * 3.0));
	
	color += clouds;
	
	color += x * (1.0 - clouds.x);

	gl_FragColor = vec4( color, 1.0 );

}