#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;


mat3 m = mat3( 0.00,  0.80,  0.60,
              -0.80,  0.99, -0.48,
              -0.60, -0.9,  0.64 );

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

float fbm( vec3 p )
{
	float f = 0.0;

 	f += 0.5000*noise( p ); p = m*p*2.02;
	f += 0.2500*noise( p ); p = m*p*2.03;
	f += 0.1250*noise( p ); p = m*p*2.01;
	f += 0.0625*noise( p ); p = m*p*2.04;
	f += 0.03125*noise( p ); p = m*p*2.05;
	f += 0.015625*noise( p );

	return f;
}


void main(void)
{
	vec2 p=(2.0*gl_FragCoord.xy-resolution)/max(resolution.x,resolution.y);

	vec4 col=vec4(1.0,1.0,1.0,0.0);
	for(int i=1;i<64;i++)
	{
		float z=float(i)*float(i)*0.004;
		float x=p.x*z;
		float y=p.y*z;
		float c=fbm(0.3*vec3(x,y,z+time*3.0));
		c=clamp((c-0.5)*4.0,0.0,1.0);
		c=clamp(c-y*0.3-0.0,0.0,1.0);
		col.a+=(1.0-col.a)*c*0.04;
		if(col.a>0.99) break;
	}

	vec3 skycol=mix(vec3(0.2,0.5,1.0),vec3(0.05,0.2,0.7),clamp((p.y+0.6)/1.2,0.0,1.0));
	vec3 finalcol=mix(skycol,col.rgb,col.a);

	gl_FragColor=vec4(vec3(finalcol),1.0);
}
