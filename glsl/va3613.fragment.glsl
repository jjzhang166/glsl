#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float round(float v)
{
	if(v - floor(v) >= 0.5) return floor(v)+1.0;
	else return floor(v);

}

vec2 round(vec2 v)
{
	vec2 ret = vec2(0.0);
	if(v.x - floor(v.x) >= 0.5) ret.x = floor(v.x)+1.0;
	else ret.x = floor(v.x);
	if(v.y - floor(v.y) >= 0.5) ret.y = floor(v.y)+1.0;
	else ret.y = floor(v.y);
	return ret;
}

float triwave(float x)
{
	return 1.0-4.0*abs(0.5-fract(0.5*x + 0.25));
}

float rand(vec2 co){
	float t = round(time*4.0);
    return fract(sin(dot(co.xy ,vec2(1.9898,7.233))) * t*t);
}

float pixelsize = 16.0;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy);
	
	vec3 color = vec3(0.0);
	
	vec2 rposition = round(((position-(pixelsize/2.0))/pixelsize));
	
	color = vec3(rand(rposition),rand(rposition-12.0),rand(rposition+46.0));
	
	//color *= vec3(abs(sin((position.x+2.0))) * abs(sin((position.y+2.0))));
	
	color *= vec3(clamp( abs(triwave(position.x/pixelsize))*2.0 , 0.0 , 1.0 ));
	color *= vec3(clamp( abs(triwave(position.y/pixelsize))*2.0 , 0.0 , 1.0 ));
	
	
	
	gl_FragColor = vec4( color, 1.0 );

}