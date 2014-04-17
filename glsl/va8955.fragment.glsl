// Smoke particles - Dave Hoskins. 2013.
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

//-----------------------------------------------------------------------------
float hash( float n )
{
    return fract(sin(n)*43758.5453123);
}

//-----------------------------------------------------------------------------
float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0;

    float res = mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                    mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);

    return res;
}
//-----------------------------------------------------------------------------
float SmokeParticle(vec2 loc, vec2 pos, float size, float rnd)
{
	vec2 v2 = loc-pos;
	float d = dot(v2, v2)/size;
	// Outside the circle? No influence...
	if (d > 1.0) return 0.0;

	// Rotate the partices...
	float r= time*(rnd-.5)*1.5;
	float si = sin(r);
	float co = cos(r);
	d = (1.-d);
	d = pow(d, 3.0);
	//d = texture2D(iChannel3, size*.25+mat2(co, si, -si, co)*(loc-pos).xy*.06, pos.y*2.5).z * d*2.1;
	d = noise(size*12.1+mat2(co, si, -si, co)*(loc-pos).xy*1./(pos.y*.1)) * d*.75;
	return d;
}

//-----------------------------------------------------------------------------
void main( void )
{
    vec2 uv = ((gl_FragCoord.xy/resolution.xy)) * 2.0- 1.0;
	uv.x *= resolution.x/resolution.y;
	vec3 col = vec3(1.0);

	// Position...	
	uv = uv + vec2(0.1,1.1);
	// Loop through particles...
	for (float i = 0.0; i < 120.0; i+=1.0)
	{
		// Magic numbers? Yep....
		float sm = mod(time+i*(2.+hash(i*-1239.)*2.0), 8.6) *.5;
		vec2 pos = vec2(0.0, sm) *.5;
		pos.x += (hash(i)-.5)*.2 * uv.y*5.13;
		float d = SmokeParticle(pos, uv, .03*hash(i*1332.23)+.001+sm*0.03, hash(i*4242.13));
		d = d* max((3.0-(hash(i*127.0)*1.5) - sm*.63), 0.0);
		float c = hash(i*4.4);
		// Blocks/rusty smoke...
		col = mix(col, vec3(c*.2 + .1, c*.3, c*.3), min(d, 1.0));
		// Fiery plasma...
		col = mix(col, vec3(.5, .3, .0), max((d-1.1)*103.0, 0.0));
	}
    gl_FragColor = vec4( col, 1.0 );
}