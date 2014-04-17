#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Volcano - Dave Hoskins. 2013.
// https://www.shadertoy.com/view/4dfGW4
// V. 1.2 Rocks.
// V. 1.1 Removed texture dependancy and increased detail at base.

//-----------------------------------------------------------------------------
float hash( float n )
{
    return fract(sin(n)*43758.5453);
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
	float r= time*rnd*1.5;
	float si = sin(r);
	float co = cos(r);
	// Grab the rotated noise decreasing resolution due to Y position.
	// Also used size as a slight additional noise changer.
	d = noise(size*13.1+mat2(co, si, -si, co)*(loc-pos).xy*1./(pos.y*.09)) * pow((1.-d), 3.0)*.7;
	return d;
}

//-----------------------------------------------------------------------------
float RockParticle(vec2 loc, vec2 pos, float size, float rnd)
{
	vec2 v2 = loc-pos;
	float d = dot(v2, v2)/size;
	// Outside the circle? No influence...
	if (d > 1.0) return 0.0;
	float r= time*1.5 * (rnd);
	float si = sin(r);
	float co = cos(r);
	d = noise(size*430.0+mat2(co, si, -si, co)*(loc-pos)*143.0) * pow(1.0-d, 15.25);
	return pow(d, 3.)*10.;
	
}

//-----------------------------------------------------------------------------
void main( void )
{
    vec2 uv = ((gl_FragCoord.xy/resolution.xy)) * 2.0- 1.0;
	uv.x *= resolution.x/resolution.y;
	vec3 col = vec3(1.0);

	// Position...	
	uv = uv + vec2(0.1,1.1);
	// Loop through rock particles...
	for (float i = 0.0; i < 30.0; i+=1.0)
	{
		float t=  time*1.3+i*(2.+hash(i*-1239.)*2.0);
		float sm = mod(t, 9.3);
		float rnd = floor(t / 9.3);
		vec2 pos = vec2(0.0, sm) *.5;
		pos.x += (hash(i*33.0+rnd)-.5)*.2 * sm*2.13;
		// Mechanics... :)
		pos.y += (.05 - (.05+hash(i*30.0)*.02)*(sm*sm) );
		float d = RockParticle(pos, uv, .01*hash(i*1332.23)+.001, (hash(-i*42.13)-.5)*15.0);
		float c = max(.3+abs(hash(i*11340.0))*.8+(1.0-sm*.3), 0.0);
		col = mix(col, vec3(c,c*.3, 0.0), min(d, 1.));
	}

	// Loop through smoke particles...
	for (float i = 0.0; i < 120.0; i+=1.0)
	{
		// Lots of magic numbers? Yerp....
		float t=  time+i*(2.+hash(i*-1239.)*2.0);
		float sm = mod(t, 8.6) *.5;
		float rnd = floor(t / 8.6);

		vec2 pos = vec2(0.0, sm) *.5;
		pos.x += (hash(i)-.5)*.2 * uv.y*5.13;
		float d = SmokeParticle(pos, uv, .05*hash(i*1332.23+rnd)+.001+sm*0.01, hash(i*rnd*2242.13)-0.5);
		d = d* max((3.0-(hash(i*127.0)*1.5) - sm*.63), 0.0);
		float c = abs(hash(i*4.4));
		// Black/rusty smoke...
		col = mix(col, vec3(c*.2 + .1, c*.3, c*.3), min(d, 1.0));
		// Fiery plasma...
		col = mix(col, vec3(.52, .25, 0.0), max((d-1.)*8.0, 0.0));
	}
	

    gl_FragColor = vec4( col, 1.0 );
}