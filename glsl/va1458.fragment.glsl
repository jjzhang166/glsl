#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sdSphere( vec3 p, float s )
{
//	if((p.x/p.y)<.0+mod(time,2.0))
  return length(p)-s;
}

float opS( float d1, float d2 )
{
    return max(-d1,d2);
}

float udBox( vec3 p, vec3 b )
{
  return length(max(abs(p)-b,0.0));
}

float cunha( vec3 p, vec3 b,vec3 e )
{
  vec3 inter=mix(b,e,p.x);
  return length(max(abs(p)-inter,0.0));
}

float sdCone( vec3 p, vec2 c )
{
    // c must be normalized
    float q = length(p.xy);
    return dot(c,vec2(q,p.z));
}

float sdPlane( vec3 p, vec4 n )
{
  // n must be normalized
  return dot(p,n.xyz) + n.w;
}

float opI( float d1, float d2 )
{
    return max(d1,d2);
}

float opU( float d1, float d2 )
{
    return min(d1,d2);
}

float opDisplace( vec3 p ,float dist)
{
	float t=mod(time*3.0,20.0);
    float d2 = sin(t*p.x)*sin(t*p.y);
    return dist+d2;
}
/*
float softshadow( in vec3 ro, in vec3 rd, float mint, float maxt, float k )
{
    float res = 1.0;
    for( float t=0.0; t < 20.0 )
    {
        float h = sdSphere(ro + rd*t,0.5);
        if( h<0.001 )
            return 0.0;
        res = min( res, k*h/t );
        t += h;
    }
    return res;
}*/

void main( void ) {

	vec2 uv = ((gl_FragCoord.xy / resolution.xy) * 2.0 - 1.0);	
	vec2 mouseuv=mouse * 2.0 - 1.0;
	
	float aspectRatio=resolution.x/resolution.y;
	
	vec3 origen=vec3(mouseuv.x,mouseuv.y,-2.0);
	vec3 destino=normalize(vec3(uv.x*aspectRatio,uv.y,1.0));	
	vec3 luz=vec3(0.0,10.0,-2.0);
	
	float res = 1.0;
	vec3 rayo=origen;
	
	float dist,distESF1,distESF2,distESF3,distESF4;
	for(int i=0;i<45;i++){
		distESF1=sdSphere(rayo/*+mod(vec3(.2,.0,.0)*time*4.0,6.0)*/,.5);
		//distESF1=opDisplace(rayo,distESF1);
		distESF3=cunha(rayo+vec3(4,.0,.0),vec3(.3,.3,.5),vec3(.3,.0,.5));
		distESF4=udBox(rayo+vec3(-0.4,.0,.0),vec3(.5,.2,0.5));//sdPlane(rayo-vec3(0.0,-2.0,0.0),normalize(vec4(0.0,1.0,.0,1.0)));		
		distESF2=sdSphere(rayo+vec3(-0.4,.0,.0),.5);
		dist=opU(distESF3,distESF1);
		rayo+=dist*destino;
	}
	
	if(length(rayo)<1.0)
		gl_FragColor = vec4(luz*rayo,1.0);
	else
		gl_FragColor = vec4(rayo,1.0);
	
}