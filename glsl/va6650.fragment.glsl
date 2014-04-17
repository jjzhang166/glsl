/**
 * @author Zephod
 *
 **/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// Riftwarp from "Perception" (https://github.com/cybereality/Perception/blob/master/Release/Perception/fx/SideBySideRift.fx ) rewritten for GLSL 
// combined with a raytraced sphere from IQ/RGBA (http://www.iquilezles.org/www/material/isystem1k4k/isystem1k4k.htm) 
// made by Zephod

float intersctSphere(in vec3 rO, in vec3 rD, in vec4 sph)
{
    vec3  p = rO - sph.xyz;
    float b = dot( p, rD );
    float c = dot( p, p ) - sph.w*sph.w;
    float h = b*b - c;
    if( h>0.0 )
    {
        h = -b - sqrt( h );
    }
	return h;
}



vec2 RiftWarp(vec2 Tex)
{
  vec2 newPos = Tex;
  float c = -81.0/10.0;
  float u = Tex.x*2.0 - 1.0;
  float v = Tex.y*2.0 - 1.0;
  newPos.x = c*u/((v*v) + c);
  newPos.y = c*v/((u*u) + c);
  newPos.x = (newPos.x + 1.0)*0.5;
  newPos.y = (newPos.y + 1.0)*0.5;
  return newPos;
}


vec4 Color(vec2 inp)
{
	float x= sin(inp.x*100.0)*0.5+0.5;
	x *=x*x;
	x *=x*x;

	float y= sin(inp.y*100.0)*0.5+0.5;
	y *=y*y;
	y *=y*y;

	vec2 ii = (inp- vec2(0.5,0.5))*2.0;
	vec3 eyeray = normalize(vec3(ii.x/1.3, ii.y,0.75));
	
	
	vec3 d=normalize(vec3(0.,0.,-1.));
    	vec3 r=normalize(cross(d,vec3(0.0,1.0,0.0)));
    	vec3 u=cross(r,d);
    	
	vec3 e=vec3(ii.x*1.333,ii.y,.75);   //    eye space ray
    	vec3 ws=mat3(r,u,d)*e;              //  world space ray
	
	vec4 sph = vec4(sin(time),cos(time),0.,0.5);
	float t = intersctSphere(ws, e, sph);
	float dif = 0. ;
	

	
	if(t>0.0)
    	{
        	vec3 inter = e + t*ws;
        	vec3 norma = normalize( inter - sph.xyz );
        	dif = dot(norma,vec3(0.57703));
		
		return (dif*vec4(0.5,0.4,0.3,0.0) + vec4(0.1,0.1,0.1,1.0));
    	}
    
	return vec4(x*0.1,y*0.1,0,0);
	
}


void main( void ) {

	
	vec4 tColor;
	vec2 newPos = gl_FragCoord.xy/resolution.xy;
	if(newPos.x < 0.5)
	{
		newPos.x = newPos.x * 2.0;
		tColor = Color( RiftWarp(newPos));	
	}
	else 
	{
		newPos.x = (newPos.x - 0.5) * 2.0;
		tColor = Color(RiftWarp(newPos));
	}

	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;

	gl_FragColor = tColor;

}