#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define iGlobalTime time
#define iResolution resolution
#define iMouse mouse


vec2 disp( in vec3 p )
{
	return vec2( smoothstep(-10.0,-5.0,p.x),
		     smoothstep(1.0,0.0, cos(p.y*30.0))
	);
}

float sphere( in vec3 p, in float s )
{
  return length(p)-s;
}


float plane( in vec3 p, in vec3 ax)
{
	return dot(p,ax) - 0.1;
}

float opRep( vec3 p, vec3 c )
{
    vec3 q = mod(p,c)-0.6*c;
    return sphere( q, 0.6 );
}

float obj( in vec3 p )
{
	//vec3 ax = vec3(0.0,0.0,1.0)/1.0;
	vec3 ax = vec3(0.150,.5,0.2)/0.1;
	//float d1 = plane(p,ax);
	//float d1 = sphere(p, 0.75);
	float d1  = opRep(p, ax);
	return d1;
}


vec2 map( in vec3 p )
{
	float d1 = obj( p );
    	vec2 res = vec2( d1, 0.0 );

	vec2 di = disp( p );
	res.x -= 0.04*di.x*di.y;

	return res;
}


vec2 intersect( in vec3 ro, in vec3 rd )
{
	float t = 0.0;
	vec2 h = vec2( -1.0 );
	for( int i=0; i<32; i++ )
	{
		h = map(ro+rd*t);
		t += h.x;
	}
	
	if( h.x<0.1 ) return vec2(t,h.y);

	return vec2(-1.0);
}


vec3 calcNormal( in vec3 pos )
{
    vec3 eps = vec3(0.02,0.0,0.0);

	return normalize( vec3(
           map(pos+eps.xyy).x - map(pos-eps.xyy).x,
           map(pos+eps.yxy).x - map(pos-eps.yxy).x,
           map(pos+eps.yyx).x - map(pos-eps.yyx).x ) );
}



float softshadow( in vec3 ro, in vec3 rd, float mint, float k )
{
    float res = 1.0;
    float t = mint;
    for( int i=0; i<16; i++ )
    {
        float h = map(ro + rd*t).x;
        res = min( res, k*h/t );
        t += h;
    }
    return clamp(res,0.0,1.0);
}



void main(void)
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / iResolution.xy;
    p.x *= iResolution.x/iResolution.y;

    vec2 m = iMouse.xy/iResolution.xy;
	
    // camera
    float an = -6.2*1.0 + 0.2*sin(0.5) + 6.5*iMouse.x;
    vec3 ro = 1.5*normalize(vec3(sin(an),0.0, cos(an)));

    vec3 ww = normalize( vec3(0.0,0.0,0.0) - ro );
    vec3 uu = normalize( cross(ww,vec3(0.0,1.0,0.0) ) );
    vec3 vv = normalize( cross(uu,ww));
    vec3 rd = normalize( p.x*uu + p.y*vv + 1.0*ww );

    vec3 col = vec3(1.0);

	// raymarch
    vec2 tmat = intersect(ro,rd);
    if( tmat.y>-1.0 && tmat.y < 1.0)
    {
        // geometry
        vec3 pos = ro + tmat.x*rd;
        vec3 nor = calcNormal(pos);
        vec3 ref = reflect(rd,nor);
		vec3 lig = normalize(vec3(-0.6,0.5,0.2));
		vec2 dis = disp( pos );
     
        // lights
        float con = 1.0;
        float amb = 0.5 + 0.5*nor.y;
        float dif = max(dot(nor,lig),0.0);
        float bac = max(0.2 + 0.8*dot(nor,vec3(-lig.x,lig.y,-lig.z)),0.0);
        float rim = pow(1.0+dot(nor,rd),8.0);
        float spe = pow(clamp(dot(lig,ref),0.0,1.0),100.0);
        float occ = mix( 1.0, 0.9 + 3.0*dis.y, dis.x );
		
        col  = 0.10*con*vec3(1.0)*occ;
        col += 1.00*dif*vec3(1.0,0.8,0.6);
        col += 0.40*bac*vec3(1.0)*occ;
        col += 0.25*amb*vec3(0.6,0.8,1.0)*occ;

        // material
	col *= vec3(0.9,0.1,0.1);
		
	// speculars
        col += 1.50*spe*vec3(1.0);
	col += 2.00*rim*vec3(0.9, 0.75, 0.5);
	
		
        // gamma
        col = sqrt(col);
    }


    gl_FragColor = vec4( col,1.0 );
}							   