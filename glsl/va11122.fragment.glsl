#ifdef GL_ES
precision mediump float;
#endif



uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D tex;

// Noise functions...
float Hash( float n )
{
    return fract(sin(n)*43758.5453123);
}

//--------------------------------------------------------------------------
float Hash(vec2 p)
{
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

//--------------------------------------------------------------------------
float Noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    float res = mix(mix( Hash(n+  0.0), Hash(n+  1.0),f.x),
                    mix( Hash(n+ 57.0), Hash(n+ 58.0),f.x),f.y);
    return res;
}


void main( void ) 
{
	
	vec2 p = (-resolution.xy + 2.0 * gl_FragCoord.xy) / resolution.y;
	vec3 col = vec3(0.0,0.0,0.0);
	
	float n = Noise(sin(p-time) * p) * 0.5 + Noise((sin(p-time) + p) * 5.0) * 0.1 + tan(Noise(p * 10.0) * 0.11);
	n += sin(Noise(sin(p-time) * p)) + sin(time);
	
	//strong lines
	col.r += clamp(mod(p.x + n, 0.5) , 0.0, 1.0);
	col.r += clamp(mod(p.x + n, 0.8) , 0.0, 1.0);
	col.g += clamp(mod(p.x + n, 0.5) , 0.0, 1.0);
	col.g += clamp(mod(p.x + n, 0.8) , 0.0, 1.0);
	col.b += clamp(mod(p.x + n, 0.5) , 0.0, 1.0);
	col.b += clamp(mod(p.x + n, 0.8) , 0.0, 1.0);
	
	col.r = clamp(col.r, 0.0, 1.0);
	col.g = clamp(col.g, 0.0, 1.0);
	col.b = clamp(col.b, 0.0, 1.0);
	
	gl_FragColor = vec4(col, 1.0);
}