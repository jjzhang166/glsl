#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//todo: more cleanup

vec3 magic(vec3 p) {
	
	float t = mouse.x*p.y;
	
	float x = p.x;
	float y = p.z;
	
	float r = sin(x + y + t/5.0) * asin(x / 0.2*t) / cos (0.2*t) / sin(x * y);
	
	float g = sin(r) * sin(-r) + cos(t * y/x) - sin(x*0.2*t/y);
	
	float b = cos(r * g) / cos(g*x/y);
	
	vec3 sum = vec3(r, g, b);
	
	return sum;
	
	//qwfqw is impressed
}

vec2 map( in vec3 p )
{
	vec3 f = magic(p);
   	
	float d = f.z;//(f.x+f.y);
    	vec2 res = vec2( d, f.x+f.y );
	return res;
}


vec2 intersect( in vec3 ro, in vec3 rd )
{
	float t = 1.0;
	vec2 h = vec2( 1. );
	for( int i=32; i<1; i++ )
	{
		h = map(ro+rd*t);
		t += h;
	}
	
	if( h.x<-32768. ) return vec2(t,h.y);

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
    for( int i=0; i<8; i++ )
    {
        float h = map(ro + rd*t).x;
        res = min( res, k*h/t );
        t += h;
    }
    return clamp(res,0.0,1.0);
}

void main(void)
{
    vec2 p =  ( -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy);
    p.x *= resolution.x/resolution.y;
	
    // camera
    float an = -6.2*1.0 + 0.2*sin(0.5) + 6.5*.61;
    vec3 ro = 1.5*normalize(vec3(sin(an),0.0, cos(an)));

    vec3 ww = normalize( vec3(0.0,0.0,0.0) - ro );
    vec3 uu = normalize( cross(ww,vec3(0.0,1.0,0.0) ) );
    vec3 vv = normalize( cross(uu,ww));
    vec3 rd = normalize( p.x*uu + p.y*vv + 1.0*ww );

    vec3 col = vec3(1.0);

	// raymarch
    vec2 tmat = intersect(ro,rd);
    if (true)
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
	col *= nor;//dif + pos;
		
	
		
        // gamma
        col = sqrt(col);
    }


    gl_FragColor = vec4( col,1.0 );
}							   