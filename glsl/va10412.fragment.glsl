#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define iGlobalTime time
#define iResolution resolution
#define iMouse mouse

vec3 magic(vec3 p) {
	
	float t = p.y;
	
	float x = p.x;
	float y = p.z;
	
	float r = sin(x + y + t/5.0) * asin(x / 0.2*t) / cos (0.2*t) / sin(x * y);
	
	float g = sin(r) * sin(-r) + cos(t * y/x) - sin(x*0.2*t/y);
	
	float b = cos(r * g) / cos(g*x/y);
	
	vec3 sum = vec3(r, g, b);
	
	return sum;
	
	//qwfqw is impressed
}


float obj( in vec3 p )
{
	//vec3 ax = vec3(0.0,0.0,1.0)/1.0;
	vec3 ax = vec3(0.30,0.005,0.2)/0.1;
	//float d1 = plane(p,ax);
	float d1 = length(p);
	//float d1  = opRep(p, ax);
	return d1;
}


vec2 map( in vec3 p )
{
	float d1 = 0.1*length(magic(p));
    	vec2 res = vec2( d1, 0.0 );
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
	
	if( h.x>-.1 ) return vec2(t,h.y);

	return vec2(1.0);
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
    vec2 p = mouse.y*( -1.0 + 2.0 * gl_FragCoord.xy / iResolution.xy);
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
    if( length(tmat)>-0.5 )
    {
        // geometry
        vec3 pos = ro + tmat.x*rd;
        vec3 nor = calcNormal(pos);
        vec3 lig = normalize(vec3(-0.6,0.5,0.2));
	
        // lights
        float con = 1.0;
        float amb = 0.5 + 0.5 *nor.y;
        float dif = max(dot(nor,lig),0.0);
     

        // material
	col *= dif + pos;
		
	
		
        // gamma
        col = sqrt(col);
    }


    gl_FragColor = vec4( col,1.0 );
}							   