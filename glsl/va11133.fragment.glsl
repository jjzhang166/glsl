// Distance Field ray marcher / sphere marcher

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// FragmentProgram
// based on iq/rgba 's seminar 
//   "Rendering Worlds with Two Triangles with raytracing on the GPU in 4096 bytes"
// at NVSCENE 08
// I have watched this great seminar, I have coded the below test program. ;)
// [http://www.rgba.org/iq/]
 
float flr(vec3 p, float f)
{
	return abs(f - p.y);
}

float sph(vec3 p, vec4 spr)
{
	return length(spr.xyz-p) - spr.w;
}
float heart(vec3 p, vec3 pHeart) {
	vec3 d = p-pHeart;
	float x2 = d.x*d.x;
	float y2 = d.y*d.y;
	float z2 = d.z*d.z;
	float y3 = d.y*d.y*d.y;
	float dd = pow(x2+y2+z2-1.0, 3.0) - (x2+z2)*y3;
	//if (dd > 0.0) 	
	//dd = pow(dd,1./5.);
	//else			return 1.0;
	return dd;
}
float cly(vec3 p, vec4 cld)
{
	return length(vec2(cld.x + 0.5 * sin(p.y + p.z * 2.0), cld.z) - p.xz) - cld.w;
}

float scene(vec3 p)
{
	float d = flr(p, -5.0);
	d = min(d, flr(p, 5.0));
	d = min(d, sph(p, vec4( 0,-2, 15, 1.5)));
	d = min(d, sph(p, vec4(-8, 0, 20, 2.0)));
	d = min(d, sph(p, vec4(-5, 4, 15, 0.5)));
	d = min(d, sph(p, vec4(-1, 3, 15, 2.0)));
	d = min(d, sph(p, vec4( 2,-3, 15, 0.5)));
	d = min(d, cly(p, vec4(10, 0, 20, 1.0)));
	d = min(d, cly(p, vec4( 4, 0, 15, 1.0)));
	d = min(d, cly(p, vec4( 0, 0, 20, 1.0)));
	d = min(d, cly(p, vec4(-2, 0, 25, 1.0)));
	d = min(d, cly(p, vec4(-6, 0, 30, 1.0)));
	d = min(d, cly(p, vec4(-12,0, 35, 1.0)));
	d = min(d, heart(p, vec3( 8, 0, 15)));
	return d;
}

vec3 getN(vec3 p)
{
	float eps = 0.01;
	return normalize(vec3(
		scene(p+vec3(eps,0,0))-scene(p-vec3(eps,0,0)),
		scene(p+vec3(0,eps,0))-scene(p-vec3(0,eps,0)),
		scene(p+vec3(0,0,eps))-scene(p-vec3(0,0,eps))
	));
}

float AO(vec3 p,vec3 n)
{
	float dlt = 0.5;
	float oc = 0.0, d = 1.0;
	for(int i = 0; i < 6; i++)
	{
		oc += (float(i) * dlt - scene(p + n * float(i) * dlt)) / d;
		d *= 2.0;
	}
	return 1.0 - oc;
}
//############################### 7SEGMENT 

const int d_tt = 0x01;
const int d_tr = 0x02;
const int d_tl = 0x04;
const int d_dd = 0x10;
const int d_dr = 0x20;
const int d_dl = 0x40;
const int d_cc = 0x88;

float thickness = 0.001;

float line(vec2 p, vec2 pa, vec2 pb ) {
	float d = distance(p, pa) + distance(p, pb) - distance(pa, pb);
	return 1.0-step(thickness, d);
}

float digit7(vec2 p, int spec, vec2 offset, vec2 size) {
	float d = 0.0;
	if ( spec >= d_cc ) { spec -= d_cc; d += line(p, offset + vec2 ( .0     , size.y * .5 ) , offset + vec2 ( size.x , size.y * .5 ) ); }
	if ( spec >= d_dl ) { spec -= d_dl; d += line(p, offset                                 , offset + vec2 ( .0     , size.y * .5 ) ); }
	if ( spec >= d_dr ) { spec -= d_dr; d += line(p, offset + vec2 ( size.x , .0 )          , offset + vec2 ( size.x , size.y * .5 ) ); }
	if ( spec >= d_dd ) { spec -= d_dd; d += line(p, offset                                 , offset + vec2 ( size.x , .0          ) ); }
	if ( spec >= d_tl ) { spec -= d_tl; d += line(p, offset + vec2 ( .0     , size.y * .5 ) , offset + vec2 ( .0     , size.y      ) ); }
	if ( spec >= d_tr ) { spec -= d_tr; d += line(p, offset + vec2 ( size.x , size.y * .5 ) , offset + size ); }
	if ( spec >= d_tt ) { spec -= d_tt; d += line(p, offset + vec2 ( .0     , size.y )      , offset + size ); }
	return d;
}
float digit(vec2 p, float val, vec2 offset, vec2 size) {
	val = fract(val/10.0);
	// Ugly bisect	
	if ( val < 0.5 ) {
		if ( val < 0.3 ) {
			if ( val < 0.1 )            return digit7(p, 0x77 , offset , size ); //0
			else if ( val < 0.2)        return digit7(p, 0x22  , offset , size ); //1
			else                        return digit7(p, 0xdb , offset , size ); //2
		} else {
			if ( val < 0.4 )            return digit7(p, 0xbb  , offset , size ); //3
			else               	    return digit7(p, 0xae  , offset , size ); //4
		}
	} else {
		if ( val < 0.8 ) {
			if ( val < 0.6 )            return digit7(p, 0xbd  , offset , size ); //5
			else if ( val < 0.7)        return digit7(p, 0xfd , offset , size ); //6
			else                        return digit7(p, 0x23  , offset , size ); //7
		} else {
			if ( val < 0.9 )            return digit7(p, 0xff , offset , size ); //8
			else               	    return digit7(p, 0xbf  , offset , size ); //9
		}
	}
}
float show5(vec2 p, float val, vec2 offset, vec2 size) {
	float d = 0.0;
	const int digits = 5;
	for(int i=0; i<digits; i++)  
		d += digit(p, val/pow(10.0,float(i)), offset+vec2(-float(i)*size.x - 0.03*float(i),0.0), size);
	return d;
}
//################################################ VORONOI

// Created by inigo quilez - iq/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

// I've not seen anybody out there computing correct cell interior distances for Voronoi
// patterns yet. That's why they cannot shade the cell interior correctly, and why you've
// never seen cell boundaries rendered correctly. 
//
// However, here's how you do mathematically correct distances (note the equidistant and non
// degenerated grey isolines inside the cells) and hence edges (in yellow):
//
// http://www.iquilezles.org/www/articles/voronoilines/voronoilines.htm


#define ANIMATE

float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

vec2 hash( vec2 p )
{
    p = vec2( dot(p,vec2(127.1,311.7)), dot(p,vec2(269.5,183.3)) );
	return fract(sin(p)*43758.5453);
}

vec3 voronoi( in vec2 x )
{
    vec2 n = floor(x);
    vec2 f = fract(x);

    //----------------------------------
    // first pass: regular voronoi
    //----------------------------------
	vec2 mg, mr;

    float md = 8.0;
    for( int j=-1; j<=1; j++ )
    for( int i=-1; i<=1; i++ )
    {
        vec2 g = vec2(float(i),float(j));
		vec2 o = hash( n + g );
		#ifdef ANIMATE
        o = 0.5 + 0.5*sin( time + 6.2831*o );
        #endif	
        vec2 r = g + o - f;
        float d = dot(r,r);

        if( d<md )
        {
            md = d;
            mr = r;
            mg = g;
        }
    }

    //----------------------------------
    // second pass: distance to borders
    //----------------------------------
    md = 8.0;
    for( int j=-2; j<=2; j++ )
    for( int i=-2; i<=2; i++ )
    {
        vec2 g = mg + vec2(float(i),float(j));
		vec2 o = hash( n + g );
		#ifdef ANIMATE
        o = 0.5 + 0.5*sin( time + 6.2831*o );
        #endif	
        vec2 r = g + o - f;

		
        if( dot(mr-r,mr-r)>0.000001 )
		{
        // distance to line		
        float d = dot( 0.5*(mr+r), normalize(r-mr) );

        md = min( md, d );
		}
    }

    return vec3( md, mr );
}
vec3 voronoiIsoLines(vec2 p)
{
    vec3 c = voronoi( p );

    // isolines
    vec3 col = (c.x+0.1)*(1.0 + 0.5*sin(64.0*c.x))*vec3(0.4, 0.9, 1.5);

	// feature points
	float dd = length( c.yz );
	col += vec3(1.0,0.6,0.1)*(1.0-smoothstep( 0.0, 0.04, dd));

	return col;
}
//####################################################

void main()
{
	vec3 mouz = vec3((mouse-vec2(0.5)),0.0);
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - 0.5;
	vec3 org = vec3(0.0,0.0,0.0) + vec3(mouz.x, 0, mouz.y)*50.0;
	vec3 dir = (vec3(position.x*resolution.x/resolution.y, position.y, 0.9)) ; //ray
	
	float g,d = 0.0;
	vec3 p = org;
	for(int i = 0; i < 64; i++)	{
		d = scene(p);
		p = p + d * dir;
	}
	if(d > 1.0)	{
		gl_FragColor = vec4(0,0,0,1);
		return;
	}
	vec3 n = getN(p);
	float a = AO(p,n);
	vec3 s = vec3(0.0,0.0,0.0);
	vec3 lp[3],lc[3];
	lp[0] = vec3(-4,0.0,4.0);
	lp[1] = vec3(2.0,.0,8.0);
	lp[2] = vec3(4,-2,24.0);
	lc[0] = vec3(1.0,0.5,0.4);
	lc[1] = vec3(0.4,0.5,1.0);
	lc[2] = vec3(0.2,1.0,0.5);
	for(int i = 0; i < 3; i++)
	{
		vec3 l,lv;
		lv = lp[i] - p;
		l = normalize(lv);
		g = length(lv);
		g = max(0.0,dot(l,n)) / g * 10.0;
		s += g * lc[i];
	}
	float fg = min(1.0,20.0 / length(p - org));
	gl_FragColor = vec4(s * a,1) * fg * fg;
	gl_FragColor += vec4(vec3(show5((p.xz*0.1), time, vec2(-1.0,2.0),vec2(0.5,0.5))),1);
	//gl_FragColor.xyz += voronoi(p.xz);
	gl_FragColor.xyz += voronoiIsoLines(p.xz); //BUG: has black spots for unknown reason
	
//-------------------------------------------------------------------------------
	//Tests
	//gl_FragColor = vec4(d);
	//gl_FragColor = vec4(position,0.0,0.0);
	//gl_FragColor = vec4(dir,0.0);
}
