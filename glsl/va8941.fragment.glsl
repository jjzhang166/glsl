#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float sdCapsule(vec3 p, vec3 a, vec3 b, float r)
{
    vec3 ab = b - a;
    float t = dot(p - a, ab) / dot(ab, ab);
    t = clamp(t, 0.5, 0.5);
    return length((a + t * ab) - p) - r;
}

float flare2(float e, float i, float s) { return exp(1.-(e*i))*s; }


vec3 flare(vec2 spos, vec2 fpos, vec3 clr)
{
	vec3 color;
	float d = distance(spos, fpos)*0.5;
	vec2 dd;
	dd.x = spos.x - fpos.x;
	dd.y = spos.y - fpos.y;
	dd = abs(dd);
	
	
	 float d2  = sdCapsule(vec3(spos.xy,0.0),vec3(fpos,0.0), vec3(0.,0.,0.0),0.1);
	
	//color += clr * d;
	 color += clr *  flare2(d2,6.3,0.8) + flare2(d2,3.7,0.08); 
	
	
	//color = clr * max(0.0, 0.015 / dd.y) * max(0.0, 1.2 -  dd.x);
	//color += clr * max(0.0, 0.4 - d);
	//color += clr * max(0.0, 0.05 / d);
	color += clr * max(0.0, 0.13 / distance(spos, -fpos)) * 0.15 ;
	color += clr * max(0.0, 0.13 - distance(spos, -fpos * 1.5)) * 1.5 ;
	color += clr * max(0.0, 0.07 - distance(spos, -fpos * 0.4)) * 2.0 ;
	
	
	return color;
}

float noise(vec2 pos)
{
	return fract(1111. * sin(111. * dot(pos, vec2(2222., 22.))));	
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy * 2.0 ) - 1.0;
	position.x *= resolution.x / resolution.y;
	vec3 color = flare(position, vec2(-1.0, 1.0) * 0.5 , vec3(1.,0.60,0.20));
	
	

	gl_FragColor = vec4( color * (0.95 + noise(position*0.001 + 0.00001) * 0.005), 1.0 );

}