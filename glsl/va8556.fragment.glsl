#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi = 3.14159;

float round(float v)
{
	return floor(v+0.5);
}
vec2 round(vec2 v)
{
	return vec2(floor(v.x+0.5),floor(v.y+0.5));
}

float noise2 (vec2 coord) 
{
	return fract(sin(dot(coord.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

vec2 sres = vec2(8); //sprite resolution
vec3 sprite(vec2 uv,float idx) //ceiling/floor sprite
{
	vec2 rp = round(uv*sres-0.5);
	if(idx == 0.0)
	{
		float b = 1.-distance(vec2(0.5),rp/sres);
		return vec3(mix(vec3(0.5,0,0),vec3(1),b*0.65));
	}
	if(idx == 1.0)
	{
		float b = mod(rp.x+mod(rp.y,2.0),2.0)*0.5+0.5;
		return vec3(vec3(0,0.5,1)*b);
	}
	if(idx == 2.0)
	{
		vec2 cmp = vec2(clamp(rp.x,2.0,5.0),clamp(rp.y,2.0,5.0));
		float b = 1.-(distance(cmp,rp)*0.3);
		return vec3(mix(vec3(0),vec3(0,0.5,0),b+(noise2(rp)*0.5)));
	}
	if(idx == 3.0)
	{
		vec2 p = rp/sres;
		return vec3(max(abs(p.x-0.5),abs(p.y-0.5)))*vec3(1,1,0);
	}
	return vec3(1,0,0);
}

vec3 tex(vec2 uv)
{
	vec2 rp = round(uv+0.5);
	vec2 suv = mod(uv,1.0);
	float idx = round(noise2(rp)*3.0);
	
	return sprite(suv,idx);
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy )*2.0-1.0;
	
	vec2 sp = mouse-0.5;
	
	vec2 move = vec2(0.2,0.6);

	vec2 uv = vec2(p.x/abs(p.y)+time*move.x,1./(abs(p.y))+time*move.y);
	
	vec3 color = tex(uv);
	color *= vec3(pow(p.y,0.75));
	
	gl_FragColor = vec4(color, 1.0 );

}