//
// by Inigo Quilez , http://www.iquilezles.org
// 
// Also here http://www.iquilezles.org/apps/shadertoy/?p=apple
// mouldy apple

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
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
    f += 0.0625*noise( p );

    return f/0.9375;
}



// Scale factor for blob fields
const float scale = 1.534212;

// Rotation matrix for blob fields (to make them appear less uniform). There's no magic behind this - it's just a random orthogonal matrix.
const mat3 dottransform = mat3(
0.11651722197701599,0.3544947103881083,0.9277700347012776,
-0.10673931989767256,-0.9242528744643419,0.3665560552387368,
0.9874363040574016,-0.14173963578072568,-0.06985285304270773
)*scale;

const int maxiter=11;

//

float meteor(vec3 pos)
{
	vec3 position = pos;
	
	// I create 3 sums here, 2 for craters, one for blobs.
	// For 2 of them I don't simply sum but sum squares and later take the square root. This is to suppress undesired accumulation of details.
	// You can observe the outcome at the craters: large craters suppress smaller ones. Similar things happen with blobs.
	// If you are curious you can remove the *abs(dots) part as well as the sqrt(craters) resp. sqrt(blobs) at the outcome.
	// Example:
	// * sqrt(0^2 (no big crater) + 0^2) (no small crater) = 0
	// * sqrt(4^2 (   big crater) + 0^2) (no small crater) = 4
	// * sqrt(0^2 (no big crater) + 1^2) (   small crater) = 1
	// * sqrt(4^2 (   big crater) + 1^2) (   small crater) = 4.12... (suppressed small crater)
	// Just 1 of the "crater" sums actually suppresses small craters. This is to reflect what happens on
	// real asteroids: big impacts destroy previous craters but new impacts still create additional craters.

	float craters = 0.0;
	float craters2 = 0.0;
	float blobs = 0.0;
	float f = .1;	// initial scale
	position *= f;
	for (int i = 0; i < maxiter; i++) {
		// This creates regularly spaced blobs, one per unit cell
		vec3 v = fract(position)-.5;		// distance vector from unit cell center
		float dots = max(0.,0.24-dot(v,v));	// simple blob around the unit cell center
		dots = dots*dots*dots/f;		// 3rd power to smooth out the border of the unit cell

		// Opposite sign for every other unit cell
		vec3 signv = sign(fract(position*.5*mouse.x)-.5);
		float signf = signv.x*signv.y*signv.z;

		// Add blobs to either of the sums, depending on sign. Note that I add the square of the blob.
		craters += max(0.,dots*signf)*abs(dots);
		craters2 += min(0.,dots*signf);
		blobs += min(0.,dots*signf)*abs(dots);
		
		// Rotate and scale the view (and thus the next series of blobs)
		f *= scale;
		position *= dottransform;
	}
	// Isosurface function. < 0 = inside blob, > 0 = in outer space. Ideally any value > 0 should be the distance to the nearest spot where the value is <= 0.
	return (craters2*1.0+sqrt(craters)-sqrt(-blobs))*55.1+1.;
}

vec2 appleShape( vec3 p )
{
   p.y -= 0.75*pow(dot(p.xz,p.xz),0.2);
//   return length(p) - 1.0;

   vec2 d1 = vec2( length(p) - 1.0, 1.0 );
   vec2 d2 = vec2( p.y+0.55, 2.0 );
   if( d2.x<d1.x) d1=d2;
   return d1-meteor(p*10.4)*.01;
}
const float fScale=38.5;

vec3 appleColor( in vec3 pos, in vec3 nor, out vec2 spe )
{
    spe.x = 1.0;
    spe.y = 1.0;

    float a = atan(pos.x,pos.z);
    float r = length(pos.xz);

    // red
    vec3 col = vec3(1.0,0.0,0.0);

    // green
    float f = smoothstep( 0.0, 1.0, fbm(pos*1.0) );
    col = mix( col, vec3(0.8,1.0,0.2), f );

    // dirty
    f = smoothstep( 0.0, 1.0, fbm(pos*4.0) );
    col *= 0.8+0.2*f;

    // frekles
    f = smoothstep( 0.0, 1.0, fbm(pos*48.0) );
    f = smoothstep( 0.7,0.9,f);
    col = mix( col, vec3(0.9,0.9,0.6), f*0.5 );

    // stripes
    f = fbm( vec3(a*7.0 + pos.z,3.0*pos.y,pos.x)*2.0);
    f = smoothstep( 0.2,1.0,f);
    f *= smoothstep(0.4,1.2,pos.y + 0.75*(noise(4.0*pos.zyx)-0.5) );
    col = mix( col, vec3(0.4,0.2,0.0), 0.5*f );
    spe.x *= 1.0-0.35*f;
    spe.y = 1.0-0.5*f;

    // top
    f = 1.0-smoothstep( 0.14, 0.2, r );
    col = mix( col, vec3(0.6,0.6,0.5), f );
    spe.x *= 1.0-f;

    // tint more red
    col.yz *= 0.8;

float ao = 0.5 + 0.5*nor.y;
col *= ao*1.2;
	
	float fBias=resolution.y/resolution.x;

	vec3 p1=(vec3(pos*fBias)*2.0-1.0)*fScale;
	vec3 p2=normalize(vec3(-0.5,-0.5,-1.0));

	vec3 s=vec3(0.0,0.1,0.0);

	float s1=meteor(p1);
	float s2=meteor(p1+s.xyz);
	float s3=meteor(p1+s.yxz);

	vec3 n=normalize(vec3(s1,s2,s3));

	float fHalf=dot(p2,n);
	vec3 c=vec3((fHalf*0.5)+0.4);

	return col*c;
}

vec3 floorColor( in vec3 pos, in vec3 nor, out vec2 spe )
{
    spe.x = 1.0;
    spe.y = 1.0;
    vec3 col = vec3(0.5,0.4,0.3)*1.7;

    float f = fbm( 4.0*pos*vec3(6.0,0.0,0.5) );
    col = mix( col, vec3(0.3,0.2,0.1)*1.7, f );
    spe.y = 1.0 + 4.0*f;

    f = fbm( 2.0*pos );
    col *= 0.7+0.3*f;

    // frekles
    f = smoothstep( 0.0, 1.0, fbm(pos*48.0) );
    f = smoothstep( 0.7,0.9,f);
    col = mix( col, vec3(0.2), f*0.75 );

    // fake ao
    f = smoothstep( 0.1, 1.55, length(pos.xz) );
    col *= f*f*1.4;
col.x += 0.15*(1.0-f);
    return col;
}

vec2 intersect( in vec3 ro, in vec3 rd )
{
    float t=0.0;
    float dt = 0.05;
    float nh = 0.0;
    float lh = 0.0;
    float lm = -1.0;
    for(int i=0;i<90;i++)
    {
        vec2 ma = appleShape(ro+rd*t);
        nh = ma.x;
        if(nh>0.0) { lh=nh; t+=dt;  } lm=ma.y;
    }

    if( nh>0.0 ) return vec2(-1.0);
    t = t - dt*nh/(nh-lh);

    return vec2(t,lm);
}

float softshadow( in vec3 ro, in vec3 rd, float mint, float maxt, float k )
{
    float res = 1.0;
    float dt = 0.05;
    float t = mint;
    for( int i=0; i<80; i++ )
    {
        float h = appleShape(ro + rd*t).x;
        if( h>0.001 )
            res = min( res, k*h/t );
        else
            res = 0.0;
        t += dt;
    }
    return res;
}
vec3 calcNormal( in vec3 pos )
{
    vec3  eps = vec3(.001,0.0,0.0);
    vec3 nor;
    nor.x = appleShape(pos+eps.xyy).x - appleShape(pos-eps.xyy).x;
    nor.y = appleShape(pos+eps.yxy).x - appleShape(pos-eps.yxy).x;
    nor.z = appleShape(pos+eps.yyx).x - appleShape(pos-eps.yyx).x;
    return normalize(nor);
}

void main(void)
{
    vec2 q = gl_FragCoord.xy / resolution.xy;
    vec2 p = -1.0 + 2.0 * q;
    p.x *= resolution.x/resolution.y;

    // camera
    vec3 ro = 2.5*normalize(vec3(cos(0.2*time),1.15+0.4*cos(time*.11),sin(0.2*time)));
    vec3 ww = normalize(vec3(0.0,0.5,0.0) - ro);
    vec3 uu = normalize(cross( vec3(0.0,1.0,0.0), ww ));
    vec3 vv = normalize(cross(ww,uu));
    vec3 rd = normalize( p.x*uu + p.y*vv + 1.5*ww );

    // raymarch
    vec3 col = vec3(0.96,0.98,1.0);
    vec2 tmat = intersect(ro,rd);
    if( tmat.y>0.5 )
    {
        // geometry
        vec3 pos = ro + tmat.x*rd;
        vec3 nor = calcNormal(pos);
        vec3 ref = reflect(rd,nor);
        vec3 lig = normalize(vec3(1.0,0.8,-0.6));
     
        float con = 1.0;
        float amb = 0.5 + 0.5*nor.y*mouse.y;
        float dif = max(dot(nor,lig),0.0);
        float bac = max(0.2 + 0.8*dot(nor,vec3(-lig.x,lig.y,-lig.z)),0.0);
        float rim = pow(1.0+dot(nor,rd),3.0);
        float spe = pow(clamp(dot(lig,ref),0.0,1.0),16.0);

        // shadow
        float sh = softshadow( pos, lig, 0.06, 4.0, 4.0 );

        // lights
        col  = 0.10*con*vec3(0.80,0.90,1.00);
        col += 0.70*dif*vec3(1.00,0.97,0.85)*vec3(sh, (sh+sh*sh)*0.5, sh*sh );
        col += 0.15*bac*vec3(1.00,0.97,0.85);
        col += 0.20*amb*vec3(0.10,0.15,0.20);


        // color
        vec2 pro;
        if( tmat.y<1.5 )
        col *= appleColor(pos,nor,pro);
        else
        col *= floorColor(pos,nor,pro);

        // rim and spec
        col += 0.60*rim*vec3(1.0,0.97,0.85)*amb*amb;
        col += 0.60*pow(spe,pro.y)*vec3(1.0)*pro.x*sh;

        col = 0.3*col + 0.7*sqrt(col);
    }

    col *= 0.25 + 0.75*pow( 16.0*q.x*q.y*(1.0-q.x)*(1.0-q.y), 0.15 );

    gl_FragColor = vec4(col,1.0);
}