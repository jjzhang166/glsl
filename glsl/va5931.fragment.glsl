#ifdef GL_ES
precision mediump float;
#endif

// Posted by Trisomie 21
// A try at a fake single pass delayed DoF

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D frame;

vec2 dxy = 1./resolution;

// Scene Background
vec2 random2f( vec2 seed ) {
	float t = sin(seed.x+seed.y*1e3);
	return vec2(fract(t*1e5), fract(t*1e6));
}

float cvoronoi( in vec2 x )
{
    vec2 p = floor( x );
    vec2  f = fract( x );

    float res = 1.0;
    for( int j=-1; j<=1; j++ )
    for( int i=-1; i<=1; i++ )
    {
        vec2 b = vec2( i, j );
	vec2 o = random2f( p + b );
        vec2 r = vec2( b ) - f + o;
        float d = dot( r,r );
	res = min(res,(abs(fract(d*3.0-time*0.02 +o.x*8.)-.5)*2.+d*.9)/(d+.1));
    }	
    return res*.5+.25;
}

// Sample scene From : http://glsl.heroku.com/e#5855
vec4 func( vec2 p ) {
	float t=2.0;
	lowp vec4 P=vec4(0,0,-1.5,0),D=vec4(p,0,0),S=vec4(cos(t),-sin(t),cos(time*.9),0)*.8,C=vec4(.5,.6,.7,9),f,T;
	for(int r=0;r<70;r++){T=P;T.w=dot(S,S)/(5.0+sin(time));
	lowp float s=D.z=1.0,k=dot(T,T);
	for(int m=0;m<7;m++)k<4.?s*=4.*k,f=2.*T.x*T,f.x=2.*T.x*T.x-k,k=dot(T=f+S,T):k;s=sqrt(k/s)*log(k)/4.;P+=D/length(D)*s;
	if(.002>s){C*=log(k);break;}
	}
	if(P.z > .5) return vec4(vec3(cvoronoi(p*2.)), 1.);
	return vec4((C+D.y*.4).xyz, 1.-(P.z*P.z+.5));
}

#if 0 // Bilinear
vec4 sample(vec2 offset, vec2 uv, vec2 res) {
	vec2 xy = (uv * res)+.5;
	vec2 f = fract(xy);
	xy = floor(xy)/resolution + offset + dxy*.1;
	vec4 color = mix(mix(texture2D(frame, xy+dxy*vec2(0.,0.)), texture2D(frame, xy+dxy*vec2(1.,0.)), f.x),
			 mix(texture2D(frame, xy+dxy*vec2(0.,1.)), texture2D(frame, xy+dxy*vec2(1.,1.)), f.x), f.y);
	return color;
}
#else // Cubic
vec4 sample(vec2 offset, vec2 uv, vec2 res) {
	
	vec2 ddxy = 1.0/resolution;
	vec2 xy = (uv * res)+.5;
	vec2 f = fract(xy);
	xy = floor(xy)/resolution + offset + dxy*.1;
	
	vec2 st0 = ((2.0 - f) * f - 1.0) * f;
	vec2 st1 = (3.0 * f - 5.0) * f * f + 2.0;
	vec2 st2 = ((4.0 - 3.0 * f) * f + 1.0) * f;
	vec2 st3 = (f - 1.0) * f * f;
	
	vec4 row0 =
	st0.s * texture2D(frame, xy + ddxy*vec2(-1.0, -1.0)) +
	st1.s * texture2D(frame, xy + ddxy*vec2(0.0, -1.0)) +
	st2.s * texture2D(frame, xy + ddxy*vec2(1.0, -1.0)) +
	st3.s * texture2D(frame, xy + ddxy*vec2(2.0, -1.0));
	vec4 row1 =
	st0.s * texture2D(frame, xy + ddxy*vec2(-1.0, 0.0)) +
	st1.s * texture2D(frame, xy + ddxy*vec2(0.0, 0.0)) +
	st2.s * texture2D(frame, xy + ddxy*vec2(1.0, 0.0)) +
	st3.s * texture2D(frame, xy + ddxy*vec2(2.0, 0.0));
	vec4 row2 =
	st0.s * texture2D(frame, xy + ddxy*vec2(-1.0, 1.0)) +
	st1.s * texture2D(frame, xy + ddxy*vec2(0.0, 1.0)) +
	st2.s * texture2D(frame, xy + ddxy*vec2(1.0, 1.0)) +
	st3.s * texture2D(frame, xy + ddxy*vec2(2.0, 1.0));
	vec4 row3 =
	st0.s * texture2D(frame, xy + ddxy*vec2(-1.0, 2.0)) +
	st1.s * texture2D(frame, xy + ddxy*vec2(0.0, 2.0)) +
	st2.s * texture2D(frame, xy + ddxy*vec2(1.0, 2.0)) +
	st3.s * texture2D(frame, xy + ddxy*vec2(2.0, 2.0));
	
	return 0.25 * ((st0.t * row0) + (st1.t * row1) + (st2.t * row2) + (st3.t * row3));
}
#endif

vec4 sample(vec2 uv, float level) {
	float mip = floor(level);
	float f = fract(level);	
	vec4 c = sample(vec2(1.-pow(.5, mip), 1.-pow(.5, mip+1.)), uv, resolution*pow(.5, mip+1.))*(1.-f);	
	mip += 1.;
	c += sample(vec2(1.-pow(.5, mip), 1.-pow(.5, mip+1.)), uv, resolution*pow(.5, mip+1.))*f;
	return c;
}

void main( void )
{
	vec2 margin;

	vec2 p = gl_FragCoord.xy / resolution.xy;

	vec2 uv = mod(p*2., 1.);
	
	if(p.x < .5 && p.y > .5) { // Top left : Source frame
		gl_FragColor = func(uv*2.-1.);
		return;
	}
	
	if(p.x > .5 && p.y > .5) { // Top right : mipmap
		if(p.y < .752) {
			gl_FragColor = vec4(.3);
			return;
		}
		uv -= dxy*2.5;
		vec4 color = vec4(0.);
		for(float j=0.; j<5.; j++) for(float i=0.; i<5.; i++) 
			color  += texture2D(frame, uv+dxy*vec2(i,j));
		gl_FragColor = color/25.;
		return;
	}
	
	margin = abs(p-.25-vec2(.5,0.)) - .25 + dxy*0.;
	if(margin.x < 0. && margin.y < 0.) { // Bottom right : debug out , swipe color & Z blur	
		vec4 c = gl_FragColor = vec4(sample(uv, 4.5));
		if(p.y > (sin(time)+1.)*.25) gl_FragColor = c;
		else gl_FragColor = vec4(c.w);
		return;
	}
	
	margin = abs(p-.25) - .25 + dxy*4.;
	if(margin.x < 0. && margin.y < 0.) { // Botom left : Final composite
#if 0 // Interesting Bugy fx
		float mip = sample(uv, 2.5).w;
		vec4 color0 = sample(vec2(1.-pow(.5, mip), 1.-pow(.5, mip+1.)), uv, resolution*pow(.5, mip+1.));
		gl_FragColor = color0;
#else
		float level = 1.-sample(uv, 3.5).w;
		level *= 3.5;
		vec4 color = sample(uv, level);
		gl_FragColor = color;
#endif		
		return;
	} else gl_FragColor = vec4(.2,.4,0.6,0.);
	
}