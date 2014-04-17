#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sphere( in vec3 p, float r )
{
	return (length(p) - r);
}

float sCross( in vec3 p )
{
	float da = sphere(p.xyz,0.5);
 	float db = sphere(p.xyz,1.5);
	float dc = sphere(p.xyz,2.0);
	return min(da,min(db,dc));
}


vec2 map( in vec3 p )
{
	vec2 d1 = vec2( sCross(p), 1.0 );
	return d1;
}

vec3 calcNormal( in vec3 p)
{
	vec3 e = vec3(0.001,0.0,0.0);
	vec3 n ;
	n.x = map(p+e.yyy).x - map(p-e.xyy).x;
	n.y = map(p+e.yxy).x - map(p-e.yxy).x;
	n.z = map(p+e.yyx).x - map(p-e.yyx).x;
	
	return normalize( n );
}

vec2 intersect( in vec3 ro, in vec3 rd)
{
	float t = 0.0;
	for(int i = 0; i < 120; i++)
	{
		vec2 h = map(ro+t*rd);
		if( h.x< 0.000001 ) return vec2(t,h.y);
		t+= h.x;
   	}
	return vec2(0.0);
}

void main( void ) {

	//-- camera
	
	vec2 q = gl_FragCoord.xy / resolution.xy;
	vec2 p = -1.0+2.0*q;
	p.x *= resolution.x/resolution.y;
	
	vec3 ro = vec3( 0.0, 0.0, 5.0);
	vec3 ta = vec3( 0.0, 0.0, 0.0 );
	
	vec3 cw = normalize( ta-ro );
	vec3 cp = vec3( 0.0, 1.0, 0.0 );
	vec3 cu = normalize( cross(cw,cp) );
	vec3 cv = normalize( cross(cu,cw) );
	vec3 rd = normalize( p.x*cu + p.y*cv + 2.5*cw );

	//-- geometry
	   
	vec2 t = intersect(ro,rd);

	//-- color
	
	vec3 col = vec3(0.0);
	
	if( t.y > 0.0)
	{
		vec3 pos = ro + t.x*rd;
		vec3 nor = calcNormal(pos);
		vec3 lig = normalize( vec3(-1.0,0.5,0.5) );
		float amb = 0.5 + 0.5*nor.y;
		float dif = max(0.0,dot(nor,lig)); 
		
		col += amb*vec3(0.2);
		col += dif*vec3(1.0);
	}
	else
	{
		//col += 0.3*vec3(sin(time),cos(time),0.5); 
	}
	
	gl_FragColor = vec4(col, 1.0);
}